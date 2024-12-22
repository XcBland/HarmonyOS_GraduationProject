// 地图导航页面
import { promptAction, router } from '@kit.ArkUI'

import { Permissions } from '@kit.AbilityKit'
import { webview } from '@kit.ArkWeb'
import { permissionManager, WebSdkClass } from '../../utils'
import { HmNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import { CommonRouterParams } from '../../models'

@Entry
@Component
struct NavigationPage {
  startAddress: string = ''
  endAddress: string = ''
  permissions: Permissions[] = ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"]
  webSdk: WebSdkClass = new WebSdkClass()

  aboutToAppear(): void {
    WebSdkClass.Context = getContext()
    WebSdkClass.webController = new webview.WebviewController()
    const params = router.getParams() as CommonRouterParams
    if (params && params.startAddress && params.endAddress) {
      this.startAddress = params.startAddress
      this.endAddress = params.endAddress
    }
  }

  aboutToDisappear(): void {
    WebSdkClass.Context!.eventHub.off("search_list") // 销毁时取消监听
    WebSdkClass.Context = null // 销毁时清空Context
    WebSdkClass.webController = null // 销毁时清空WebController
  }

  // 获取当前位置（实时定位）
  async checkPermission() {
    try {
      //没有权限，需要去向用户申请权限，有的话就直接获取
      //1.获取用户权限
      if (permissionManager.checkPermissions(this.permissions)) {
        //已授权
        // this.getLocation()
        return
      } else {
        await permissionManager.requestPermissions(this.permissions)
      }
    } catch (error) {
      promptAction.showDialog({
        alignment: DialogAlignment.Center,
        title: "权限提示",
        message: "定位功能需要获取权限，请在系统设置中打开定位开关！",
        buttons: [
          { text: "取消", color: $r("app.color.primary_disabled") },
          { text: "立即开启", color: $r("app.color.primary") }
        ]
      }).then((res) => {
        //点击的是“立即开启”按钮
        if (res.index === 1) {
          permissionManager.openPermissionSettingsPage()
        }
      })
    }

  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get<number>(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.background_page'))
      HmNavBar({ title: '地图导航' })
      Web({
        src: $rawfile("navigation.html"),
        controller: WebSdkClass.webController
      })
        .height('100%')
        .onPageEnd(() => {
          WebSdkClass.webController!.runJavaScript(`beginDriving('${this.startAddress}','${this.endAddress}')`)
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))

  }
}