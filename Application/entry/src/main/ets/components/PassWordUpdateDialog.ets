import cloud from '@hw-agconnect/cloud'
import { userInfo_01 as userInfo } from '../enity/userInfo'
import UserModel from '../models/UserModel'
import { promptAction, router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'

// 更新密码弹窗
@CustomDialog
export struct passwordUpdateDialog {
  passwordUpdate: CustomDialogController
  userInstance: UserModel = UserModel.getInstance()
  @StorageLink('local_userInfo') userInfo: userInfo = new userInfo()
  @State password: string = ''
  @State confirmPassword: string = ''
  @State verifyCode: string = ''

  // 修改密码
  updatePassword(password: string, verifyCode: string) {
    cloud.auth().getCurrentUser().then((user) => {
      user?.updatePassword({
        password: password,
        providerType: 'email',
        verifyCode: verifyCode,
      })
        .then(() => {
          promptAction.showToast({ message: '密码修改成功' })
          this.passwordUpdate.close()
          this.userInstance.logOut()
          router.replaceUrl({ url: 'pages/Login/LoginIndex' })
        })
        .catch((error: BusinessError) => {
          promptAction.showToast({ message: error.message })
          console.error("update password error33: " + error.message)
        })
    }).finally(() => {
      this.passwordUpdate.close()
    })
  }

  build() {
    Column() {
      Row() {
        Text('修改密码')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.width('100%').justifyContent(FlexAlign.Center).margin({ top: 30 })

      Row() {
        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)
          .onChange((value) => {
            this.password = value
          })
          .width('100%')
          .backgroundColor($r('app.color.white'))
          .height(40)
      }.margin({ top: 20 }).width('90%').borderWidth(1)

      Row() {
        TextInput({ placeholder: '请再次输入密码' })
          .type(InputType.Password)
          .onChange((value) => {
            this.confirmPassword = value
          })
          .width('100%')
          .backgroundColor($r('app.color.white'))
          .height(40)
      }.margin({ top: 20 }).width('90%').borderWidth(1)

      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .width('70%')
          .backgroundColor($r('app.color.white'))
          .onChange((value) => {
            this.verifyCode = value
          })
          .height(40)
        Text('获取验证码')
          .fontSize(12)
          .onClick(() => {
            this.userInstance.getUpdatePasswordEmailVerifyCode(this.userInfo.getEmail())
          })
          .borderWidth({ left: 1 })
          .width('30%')
          .padding(5)
          .height(40)
      }.width('90%').margin(10).borderWidth(1)

      Button('修改密码')
        .onClick(() => {
          if (this.password !== this.confirmPassword) {
            promptAction.showToast({ message: '两次输入的密码不一致' })
            return
          }
          if (this.verifyCode.length !== 6) {
            promptAction.showToast({ message: '验证码错误' })
            return
          }
          this.updatePassword(this.password, this.verifyCode)

        })
    }.width('90%').margin({ top: 20 }).backgroundColor($r('app.color.white'))
  }
}

//重认证弹窗
@CustomDialog
@Component
export struct PassWordUpdateDialog {
  passwordController?: CustomDialogController
  passwordUpdateDialog: CustomDialogController | null = new CustomDialogController({
    builder: passwordUpdateDialog(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  userInstance: UserModel = UserModel.getInstance()
  @StorageLink('local_userInfo') userInfo: userInfo = new userInfo()
  @State phoneNumber: string = ''
  @State verifyCode: string = ''
  @State password: string = ''

  @Builder
  userReAuth() {
    Column() {
      Row() {
        Text('账号重认证')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.width('100%').justifyContent(FlexAlign.Center).margin({ top: 30 })

      Row() {
        Text('邮 箱  ' + this.userInfo.getEmail())
          .width('90%')
          .backgroundColor($r('app.color.white')).height(40).margin({ left: 15 })
      }
      .width('90%')
      .height(40)
      .margin(10)
      .borderRadius(0)
      .borderWidth(1)

      Row() {
        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)
          .onChange((value) => {
            this.password = value
          })
          .width('100%')
          .backgroundColor($r('app.color.white'))
          .height(40)
      }
      .width('90%')
      .height(40)
      .margin(10)
      .borderRadius(0)
      .borderWidth(1)

      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .width('70%')
          .backgroundColor($r('app.color.white'))
          .onChange((value) => {
            this.verifyCode = value
          })
          .height(40)
        Text('获取验证码')
          .fontSize(12)
          .onClick(() => {
            this.userInstance.getEmailVerifyCode(true, this.userInfo.getEmail())
          })
          .borderWidth({ left: 1 })
          .width('30%')
          .height(40)
          .textAlign(TextAlign.Center)
      }.width('90%').margin(10).borderWidth(1)

      Button('重认证')
        .width('50%')
        .margin(10)
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.white'))
        .borderRadius(10)
        .borderWidth(1)
        .onClick(async () => {
          this.userInstance.reAuth(this.password, this.userInfo.getEmail(), this.verifyCode)
          if (this.passwordController !== undefined) {
            this.passwordController.close()
          }

          this.passwordUpdateDialog!.open()
        })
        .fontColor($r('app.color.text_primary'))
        .align(Alignment.Center)
    }
    .width('90%')
    .borderRadius(20)
    .backgroundColor($r('app.color.white'))
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text('修改密码')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }.width('100%').justifyContent(FlexAlign.Center).margin({ top: 30 })
      }

      this.userReAuth()

    }.width('90%').margin({ top: 20 }).borderRadius(20).backgroundColor($r('app.color.white'))
  }
}
