import { AuthMode, getAuthInfo, signOut,Login } from '@hw-agconnect/auth-component'
import {  promptAction, router } from '@kit.ArkUI'
import cloud from '@hw-agconnect/cloud'
import { BusinessError } from '@kit.BasicServicesKit'
/**
 * @Auhtor DLY
 *
 */
@Entry
@Component
struct LoginIndex {
  build() {
    Column() {
      Login({
        modes:[AuthMode.PHONE_VERIFY_CODE],
        onSuccess:async ()=>{
          const authInfo = await getAuthInfo()
          console.log(JSON.stringify(authInfo))
          router.pushUrl({
            url:'pages/home/MapLocation'
          })
        },
        onError:()=>{
          promptAction.showToast({message:'登录失败'})
        }
      }){
        Button('手机验证码登录')
          .width('50%')
          .margin({top:30})
      }
    }
    .width('100%')
    .height('100%')


  }
}