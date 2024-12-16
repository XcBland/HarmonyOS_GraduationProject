import { BASE_URL } from '../constants/url_var';
import { http } from '@kit.NetworkKit';
import { TOKEN_KEY } from '../constants';
import { promptAction, router } from '@kit.ArkUI';
import { UserSettingClass } from '.';
import { ResponseData } from '../models';
import axios, { AxiosRequestConfig, AxiosResponse, Method } from '@ohos/axios';


/*
 * 封装网络请求的工具
 * 实现网络请求的方法
 */

export async function requestHttp<T>(url: string = "",
  method: Method = 'get',
  data?: object): Promise<T> {
  // 1.创建请求
  const axiosRequest = axios.create({
    baseURL: BASE_URL,

  })
  // 2.设置请求头
  const config: AxiosRequestConfig = {
    url,
    method,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': AppStorage.get<string>(TOKEN_KEY) || ''  // ||===??
    },
    params: method === 'get' ? data : null, // (第二种)
    data: method !== 'get' ? data : null, // get请求需要单独设置请求参数
  }
  try {
    // 3. 发送请求
    const res: AxiosResponse<ResponseData<T>> = await axiosRequest.request(config)
    switch (res.status) {
      case 401:
        promptAction.showToast({ message: '未授权或Token过期，请重新登录' });
        AppStorage.set(TOKEN_KEY, ''); // 清空用户令牌
        new UserSettingClass(getContext()).setUserToken('');
        console.log("401==>" + JSON.stringify(res));
        router.replaceUrl({ url: 'pages/Login/Login' })
        return Promise.reject(new Error('未授权或Token过期，请重新登录'));
      case 404:
        promptAction.showToast({ message: '服务器请求的资源不存在/地址错误' });
        return Promise.reject(new Error('服务器请求的资源不存在/地址错误'));
      case 500:
        promptAction.showToast({ message: '服务器内部错误' });
        return Promise.reject(new Error('服务器内部错误'));
      default:
        if (res.data.code === 200) {
          console.log("requestSuccess==>" + JSON.stringify(res.data))
          return res.data.data as T;
        } else {
          promptAction.showToast({ message: res.data.message });
          return Promise.reject(new Error(res.data.message));
        }

    }

  } catch (e) {
    promptAction.showToast({ message: JSON.stringify(e) })
    console.log("requestError==>" + JSON.stringify(e))
    return Promise.reject(e)

  }
  // 4.关闭请求
  finally {
    axiosRequest.delete(url, config)
  }

}


export class Request {
  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'get', data)
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'post', data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'put', data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, 'delete', data)
  }
}