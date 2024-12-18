//[内置：http封装]
import { http } from '@kit.NetworkKit';

//对象不能被重复使用，用完后手动关闭
//案例中，当前工具提供：在线客服功能使用

/**
 * http请求接口工具类
 * @param path 请求路径
 * @param method 请求方法
 * @param data 请求参数
 * @returns   Promise<http.HttpResponse>
 */
class HttpRequest {
  private static readonly URL: string = 'http://api.qingyunke.com'

  //属性：类中常量：静态的，内存公共数据区（静态区），类目标注对象的
  //青云客免费只能聊天网志
  static async req(
    path: string,
    method:http.RequestMethod = http.RequestMethod.GET,
    data: string = ''):Promise<http.HttpResponse|null> {
    //请求对象
    const httpReq = http.createHttp()
    //请求
    try{
      const res: http.HttpResponse = await httpReq.request(
        HttpRequest.URL + path,
        {
          method,
          extraData:data
        }
      )
      httpReq.destroy()
      return res
    } catch (e) {
      console.error(JSON.stringify(e))
      return null
    }
    //关闭
    //返回

  }
}

export default HttpRequest