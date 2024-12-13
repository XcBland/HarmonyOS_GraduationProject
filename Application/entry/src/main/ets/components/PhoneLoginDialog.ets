import cloud from '@hw-agconnect/cloud'
import UserModel from '../models/UserModel'
import { promptAction, router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'
import { AuthMode, Login } from '@hw-agconnect/auth-component'

@CustomDialog
@Component
export struct PhoneLoginDialog {
  phoneLogin: CustomDialogController
  userInstance: UserModel = UserModel.getInstance()
  // 状态变量
  @State phoneNum: string = ''
  @State verifyCode: string = ''
  @State isEnable: boolean = false

  // 登录
  phoneLoginAction() {
    cloud.auth().signIn({
      credentialInfo: {
        kind: 'phone',
        phoneNumber: this.phoneNum,
        verifyCode: this.verifyCode,
        countryCode: '86'
      }
    }).then(() => {
      router.replaceUrl({ url: 'pages/home/Index' })
      this.phoneLogin.close()
    }).catch((error: BusinessError) => {
      console.log("phoneLogin29" + error.message)
    })
  }

  build() {
    Column({space:20}) {
      Text('手机号登录')
        .fontFamily('single')
        .width('100%')
        .fontSize(24)
        .fontColor($r('app.color.white'))
        .textAlign(TextAlign.Center)
        .margin({top:20})
      Row(){
        Image($r('app.media.phoneLine'))
          .width(30)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
        Divider()
          .vertical(true)
          .strokeWidth(1)
          .width(10)
          .height(20)
          .color($r('app.color.white'))
          .margin({left:10})
        TextInput({placeholder:'请输入手机号'})
          .type(InputType.Email)
          .onChange((value:string)=>{
            this.phoneNum = value
          })
          .width('90%')
          .fontFamily('queen')
          .placeholderColor($r('app.color.white'))
          .placeholderFont({family:'queen',size:18})
          .fontSize(18)
          .fontColor($r('app.color.white'))
          .cancelButton({
            style:CancelButtonStyle.CONSTANT,
            icon:{
              src:$r('app.media.clear'),
              color:$r('app.color.text_secondary'),
              size:20
            }
          })
          .height(40)
      }

      .border({width:1,color:$r('app.color.white')})
      .width('90%')
      .height(50)
      .padding(20)
      .margin({top:20})

      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .onChange((value: string) => {
            this.verifyCode = value
            if(value.length == 6){
              this.isEnable = true
            }else{
              this.isEnable = false
            }
          })
          .height(40)
          .width('60%')
          .fontFamily('queen')
          .placeholderColor($r('app.color.white'))
          .placeholderFont({family:'queen',size:18})
          .fontColor($r('app.color.white'))
        Text('获取验证码')
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontColor($r('app.color.white'))
          .fontFamily('queen')
          .onClick(() => {
            this.userInstance.getPhoneVerifyCode(this.isEnable, this.phoneNum)
          })
          .height(40)
          .width('40%')
          .backgroundColor(this.isEnable?$r('app.color.primary'):$r('app.color.text_secondary'))
      }
      .border({width:1,color:$r('app.color.white')})
      .width('90%')
      .height(50)
      .padding(20)
      .margin({top:20})

      Button('登录')
        .fontSize(20)
        .fontColor($r('app.color.white'))
        .onClick(() => {
          this.phoneLoginAction()
        })
        .margin({top: 20})

    }
    .backgroundImage($r('app.media.fengjing1'))
    .backgroundImageSize(ImageSize.Auto)
    .width('100%')
  }
}