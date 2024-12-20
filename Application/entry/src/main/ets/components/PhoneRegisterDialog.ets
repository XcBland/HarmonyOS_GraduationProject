import cloud, { AuthUser, VerifyCodeAction } from '@hw-agconnect/cloud'
import { HmNavBar } from '.'
import UserModel from '../models/UserModel'
import { promptAction, router } from '@kit.ArkUI'
import { AgUser } from '../enity'

@CustomDialog
@Component
export struct PhoneRegisterDialog {
  // 自定义弹窗控制器
  phRegisterDialog: CustomDialogController
  // 实例化UserModel
  userInstance: UserModel = UserModel.getInstance()
  // 状态变量
  @State phoneNum: string = ''  // 手机号
  @State verifyCode: string = ''  // 验证码
  @StorageLink('user') currentUser:AgUser | undefined =
   undefined // 当前登录用户信息

  // 方法


  /**
   * 提取登陆成功之后AUthUser对象信息，封装成AgUser对象返回
   * @param user   登录成功的AuthUser对象
   * @returns AgUser对象
   */
  async getAgUser(user: AuthUser) {
    let userExtra = await user.getUserExtra()
    let agUser = new AgUser(user.getUid(),
      user.getPhone(), userExtra.getCreateTime(),
      userExtra.getLastSignInTime())
    return agUser
  }
  // 手机号注册
  async phoneRegister(){
    try{
      cloud.auth().createUser({
        kind: 'phone',
        countryCode: '86',
        phoneNumber: this.phoneNum,
        verifyCode: this.verifyCode
      })
        .then(async (result)=>{
        let user = result.getUser()
        let agUser = await this.getAgUser(user)
        AppStorage.setOrCreate<AgUser>('uesr',agUser)
        promptAction.showToast({message:'注册成功'})
      })
    }catch(e){
      console.log("手机号注册：错误"+JSON.stringify(e))
    }
  }



  build() {
    Column({ space: 20 }) {
      HmNavBar({ title: '手机号注册', showBackIcon: false })
      TextInput({ placeholder: '请输入手机号' })
        .onChange((value) => {
          this.phoneNum = value
        })
        .width('90%')
        .height(50)
        .margin({ top: 20 })
        .backgroundColor($r('app.color.white'))
        .borderWidth(1)
      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .width('60%')
          .onChange((value) => {
            this.verifyCode = value
          })
          .backgroundColor($r('app.color.white'))
          .borderWidth({ top: 1, left: 1, bottom: 1 })
          .borderRadius({ topLeft: 20, bottomLeft: 20 })
          .height(50)
        Button('获取验证码')
          .width('40%')
          .onClick(() => {
            this.userInstance.getPhoneVerifyCode(true,this.phoneNum)
          })
          .height(50)
          .borderWidth({ top: 1, right: 1, bottom: 1 })
          .type(ButtonType.Normal)
          .borderRadius({ topRight: 20, bottomRight: 20 })
          .backgroundColor($r('app.color.primary'))
      }
      .borderRadius(20)
      .margin({ top: 20 })
      .width('90%')
      .height(50)

      Button('注册')
        .onClick(async () => {
          console.log(this.phoneNum, this.verifyCode)
          await this.phoneRegister()
          setTimeout(async () => {
            await this.phRegisterDialog.close()
            router.replaceUrl({ url: 'pages/Login/LoginIndex' })
          },3000)


        })
        .type(ButtonType.Normal)
        .width('50%')
        .height(50)
        .margin(20)
        .borderRadius(20)

    }
    .borderRadius(20)
    .width('90%')
    .backgroundColor($r('app.color.background_page'))
  }
}