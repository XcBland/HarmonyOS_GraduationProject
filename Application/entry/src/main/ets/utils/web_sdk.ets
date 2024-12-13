import { webview } from '@kit.ArkWeb'
import { promptAction } from '@kit.ArkUI'
import { geoLocationManager } from '@kit.LocationKit'

export class WebSdkClass {
  static webController: webview.WebviewController | null = null
  static Context: Context | null = null

  //提供业务方法给网页端使用
  alert(message: string) {
    AlertDialog.show({ message: message })
  }

  toast(message: string) {
    promptAction.showToast({ message: message })
  }

  //设置地图的中心点位置
  async setCurrentLocation() {
    try {
      //1.获取经纬度
      const result = await geoLocationManager.getCurrentLocation()

      //2.设置地图定位
      WebSdkClass.webController?.runJavaScript(`setLocation(${result.longitude}, ${result.latitude})`)
    } catch (error) {
      AlertDialog.show({ message: JSON.stringify(error) })
    }
  }


  //当前方法中获取的了网页端传递的数据，需要在组件中显示数据内容
  receiveData(json: string) {
    //AlertDialog.show({ message: "鸿蒙端显示：" + json })
    //eventHub：线程内
    //Emitter：线程间、线程内、进程间
    //AppStorage
    WebSdkClass.Context?.eventHub.emit("search_list", json)
  }
}