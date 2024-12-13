// 导出封装的axios的实例

import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { router } from '@kit.ArkUI'
import { BASE_URL, TOKEN_KEY } from '../constants'
import { UserSettingClass } from '.'

// 创建一个axios的实例
const instance = axios.create({
  baseURL: BASE_URL, // 基础地址  http://122.51.240.24:31007 + /a/b/c/d
  timeout: 20000 // 网络请求超时时间
})

// 两个拦截器
instance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  // config就是请求的参数 地址 以及一些头信息
  // 一般在这个位置统一注入token
  console.info("1.请求参数：" + JSON.stringify(config))

  config.headers.Authorization = AppStorage.get(TOKEN_KEY) || "" //获取用户令牌

  return config // 返回的这个参数是必须的 axios就是用我们返回的这个config发送请求
}, (error: AxiosError) => {
  // 说明失败了
  console.error("3.异常信息：" + JSON.stringify(error))
  return Promise.reject(error)
}) // 注册请求拦截器- 看看你是不是把参数带全了 有没有必要报个错

// Promise pending  fullfilled rejected
instance.interceptors.response.use((response: AxiosResponse) => {
  // reponse是服务器返回给我的结果
  // axios的默认返回选项是 包了一层data的数据
  // 判断 是否执行成功
  if (response.data && response.data.code !== 200) {
    // 说明执行出现问题 要提示错误 返回promise的异常
    AlertDialog.show({ message: response.data.msg }) // 提示错误
    return Promise.reject(new Error(response.data.msg))
  }
  console.info("2.响应结果：" + JSON.stringify(response.data))
  return response.data.data // 直接返回我们需要的数据

}, (error: AxiosError) => {
  // 4xx 5xx会走到axios的响应拦截器的错误回调函数中
  if (error.response?.status === 401) {
    // 说明登录失效了 因为有效期为180天 没必要重新用复活 直接重新登录即可
    AppStorage.set(TOKEN_KEY, "") //删除token
    new UserSettingClass(getContext()).setUserToken("") //清空首选项
    router.replaceUrl({ url: "pages/Login/Login" })
  } else {
    // 除401之外的错误可以弹出显示
    AlertDialog.show({ message: error.message }) // 弹出错误信息
  }
  //
  console.error("3.异常信息：" + JSON.stringify(error))
  return Promise.reject(error)

}) // 注册响应拦截器- 数据回来，有些东西是不是没有必要啊 没有必要 就脱掉 去掉 删掉

// R是返回的类型 D是请求类型
export function request<Response = null, DataParams = null>(config: AxiosRequestConfig) {
  return instance<null, Response, DataParams>(config)
}

// ts的类型系统

// http状态码 401 通用状态码 token没传 token失效 token不对

export class RequestAxios {
  static get<T>(url: string, data?: object): Promise<T> {
    return request<T, null>({ url: url, params: data, method: "get" })
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return request<T, object>({ url: url, data: data, method: "post" })
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return request<T, object>({ url: url, data: data, method: "delete" })
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return request<T, object>({ url: url, data: data, method: "put" })
  }
}