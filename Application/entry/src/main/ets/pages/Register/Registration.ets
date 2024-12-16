import UserModel from '../../models/UserModel'
import { UserInfo } from '@hw-agconnect/auth-ohos/src/main/ets/entity/UserInfo'
import cloud, { AuthUser, Database, DatabaseCollection, Storage } from '@hw-agconnect/cloud'
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { promptAction, router } from '@kit.ArkUI'
import { AgUser } from '../../enity'
import { HmNavBar } from '../../components'
import { PhoneRegisterDialog } from '../../components/PhoneRegisterDialog'
import { userInfo_01 as userInfo } from '../../enity/userInfo'
import { TOKEN_KEY } from '../../constants'
import { BusinessError } from '@kit.BasicServicesKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'


/**
 * @Auhtor DLY
 *
 */
@Entry
@Component
struct Registration {
  userModel: UserModel = UserModel.getInstance()
  // 状态变量
  @State userName: string = ''
  @State password: string = ''
  @State confirmPassword: string = ''
  @State email: string = ''
  @State phoneNum: string = ''
  @State verificationCode: string = ''
  @State photoUrl: string = ''; // 用户头像;
  @State isEnable: boolean = false; // 是否发送了验证码，默认是没有发送，发送的过程中isEnable为false
  @State uploadingText: string = ''; //上传图片时过程中的进度文本显示
  @StorageLink('user') currentUser: AgUser | null = null; // 当前登录的用户信息
  storage: Storage = cloud.storage()
  cloudPath: string | undefined = '';
  authUser: AuthUser | null = null;
  userInfo: UserInfo | null = new UserInfo(); // 用户信息
  cloudDataBase: DatabaseCollection<userInfo> | undefined = undefined
  @State resultArray: userInfo[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';

  async aboutToAppear() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB?.collection<userInfo>(userInfo)
  }

  phoneRegisterDialog: CustomDialogController = new CustomDialogController({
    builder: PhoneRegisterDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: true
  })

  async getAgUser(user: AuthUser) {
    let userExtra = await user.getUserExtra()
    let agUser = new AgUser(user.getUid(), user.getPhotoUrl(), user.getEmail(), user.getDisplayName(),
      userExtra.getCreateTime(), userExtra.getLastSignInTime())
    return agUser
  }

  /**
   * 选择图片上传
   * @returns
   */
  async selectPhoto() {
    const options = new photoAccessHelper.PhotoSelectOptions(); // 创建PhotoSelectOptions对象
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 设置选择图片类型
    options.maxSelectNumber = 1;
    const result = await new photoAccessHelper.PhotoViewPicker().select(options) // 调用PhotoViewPicker的select方法选择图片
    return result.photoUris[0]; // 返回选择的图片的路径文件
  }

  /**
   * 上传图片到云存储
   */
  async uploadIamgeToAGC(){
    try {
      let extName = this.photoUrl!.split('.').pop();
      let fileName = `${Date.now()}.${extName}`;
      this.cloudPath = `myProjectImage/myAvcator/${fileName}`
      let result = await this.storage.upload({
        localPath: this.photoUrl,
        cloudPath:this.cloudPath
      })
      if(result.bytesTransferred===result.totalByteCount){
        promptAction.showToast({ message: '图片上传成功！' })
        return true;
      }else{
        promptAction.showToast({ message: '图片上传失败！' })
        return false;
      }
    }catch (e){
      console.error('hmlog-->', 'uploadImageToAGC Failed. Err:', JSON.stringify(e))
      promptAction.showToast({ message: '上传图片异常' })
      return false
    }
  }


  /**
   * 获取云存储文件路径
   */
  async getAGCFileUri(){
    let imgUri = await this.storage.getDownloadURL(this.cloudPath)
    this.photoUrl = imgUri
    promptAction.showToast({ message: '获取图片路径成功！' })
    return imgUri
  }

  /*邮箱注册*/
  async emailRegister() {
    try {
      let signInResult = await cloud.auth().createUser({
        kind: 'email',
        email: this.email,
        password: this.password,
        verifyCode: this.verificationCode
      })
      let user = signInResult.getUser()
      cloud.auth().getCurrentUser().then(async (user) => {
        if (user){
          this.authUser = user
          await user.getToken(false)
          await this.addUser(this.authUser) // 云数据库存储用户信息
          await this.uploadIamgeToAGC()     // 上传图片到云存储
        }
      })
      user.updateProfile({
        displayName: this.userName,
        photoUrl: this.photoUrl
      })
      let agUser = await this.getAgUser(user)
      AppStorage.setOrCreate('user', agUser)

      promptAction.showToast({ message: '注册成功' })
      router.pushUrl({ url: 'pages/home/Index' })

    } catch (e) {
      console.error('hmlog-->', 'emailRegister Failed. Err:', JSON.stringify(e))
      promptAction.showToast({ message: '注册失败' })
    }
  }

  // 添加用户
  async addUser(user: AuthUser | null) {
    try {
      let addUser = new userInfo()
      addUser.id = user?.getUid()
      addUser.displayName = this.userName
      addUser.photoUrl = this.photoUrl
      addUser.phoneNum = user?.getPhone()
      addUser.email = this.email
      let newUser = await this.cloudDataBase?.upsert(addUser)
      if (newUser !== null) {
        AlertDialog.show({ message: '注册成功' })
      } else {
        promptAction.showToast({ message: '注册失败' })
      }
    } catch (e) {
      console.error('hmlog-->', 'addUser Failed. Err:', JSON.stringify(e))
    }
  }

  // 邮箱登录
  /*async emailLogin() {
    await cloud.auth().signOut()
    await cloud.auth().signIn({
      autoCreateUser: true,
      credentialInfo: {
        kind: 'email',
        email: this.email,
        password: this.password
      }
    }).then(user => {
      AppStorage.set(TOKEN_KEY, user.getUser().getToken(true))
      router.replaceUrl({ url: 'pages/home/Index' })
    }).catch((error: BusinessError) => {
      console.error('login28-->' + JSON.stringify(error))
    })
  }*/

  build() {
    Column() {
      HmNavBar({ title: '注册', showBackIcon: true })
      Stack({ alignContent: Alignment.Bottom }) {
        Column({ space: 20 }) {
          Image(this.photoUrl)
            .width(100)
            .height(100)
            .margin({ top: 10 })
            .onClick(async () => {
              this.photoUrl = await this.selectPhoto()
              console.log('hmlog-->', 'this.photoUrl:' + this.photoUrl)
            })
            .alt($r('app.media.layered_image'))
            .borderRadius(10)
            .borderWidth(1)
            .borderColor('#ccc')
            .backgroundColor($r('app.color.background_page'))

          TextInput({ placeholder: '请输入用户名' })
            .width('90%')
            .height(40)
            .borderRadius(10)
            .borderWidth(1)
            .borderColor('#ccc')
            .onChange((value: string) => {
              this.userName = value
            })
            .backgroundColor($r('app.color.background_page'))


          TextInput({ placeholder: '请输入密码' })
            .width('90%')
            .height(40)
            .borderRadius(10)
            .borderWidth(1)
            .borderColor('#ccc')
            .onChange((value: string) => {
              this.password = value
            })
            .type(InputType.Password)
            .backgroundColor($r('app.color.background_page'))

          TextInput({ placeholder: '请确认密码' })
            .width('90%')
            .height(40)
            .borderRadius(10)
            .borderWidth(1)
            .borderColor('#ccc')
            .onChange((value: string) => {
              this.confirmPassword = value
            })
            .type(InputType.Password)
            .backgroundColor($r('app.color.background_page'))

          TextInput({ placeholder: '请输入邮箱' })
            .width('90%')
            .height(40)
            .borderRadius(10)
            .borderWidth(1)
            .borderColor('#ccc')
            .onChange((value: string) => {
              this.email = value
              this.isEnable = true
            })
            .backgroundColor($r('app.color.background_page'))


          Row() {
            TextInput({ placeholder: '请输入验证码' })
              .width('50%')
              .height(40)
              .borderRadius({ topLeft: 10, bottomLeft: 10 })
              .border({
                width: {
                  left: 1,
                  top: 1,
                  bottom: 1,
                  right: 0
                }
              })
              .borderColor('#ccc')
              .onChange((value: string) => {
                this.verificationCode = value
              })
              .type(InputType.Number)
              .borderColor('#ccc')
            Button('获取验证码')
              .onClick(() => {
                this.userModel.getEmailVerifyCode(this.isEnable, this.email)
                setTimeout(() => {
                  this.isEnable = false
                }, 60 * 1000)
              })
              .width('40%')
              .height(40)
              .borderRadius({ topRight: 10, bottomRight: 10 })
              .border({
                width: {
                  left: 0,
                  top: 1,
                  bottom: 1,
                  right: 1
                }
              })
              .borderColor('#ccc')
              .backgroundColor(this.email.length > 0 ? $r('app.color.primary') :
              $r('app.color.disabled_button_background'))// .enabled(this.email.length > 0&&!this.isEnable)
              .type(ButtonType.Normal)
              .borderRadius(10)
          }
          .borderRadius(10)
          .backgroundColor($r('app.color.background_page'))

          Row() {
            Radio({ value: 'radio', group: "radioGroup" })
              .checked(false)
              .radioStyle({ checkedBackgroundColor: "#007AFF" })
              .width(20)
              .height(20)
              .onChange(() => {
              })
            Text('我已阅读并同意《用户注册协议》')
              .fontSize(12)
              .fontColor('#007AFF')

          }
          .width('90%')
          .height(20)


          Row() {
            Radio({ value: 'radio2', group: "radioGroup2" })
              .checked(false)
              .radioStyle({ checkedBackgroundColor: "#007AFF" })
              .width(20)
              .height(20)
              .onChange(() => {
              })
            Text('我已阅读并同意《用户隐私协议》')
              .fontSize(12)
              .fontColor('#007AFF')
          }
          .width('90%')
          .height(20)

          Button('注册')
            .onClick(async () => {
              if (this.userName.length === 0) {
                promptAction.showToast({ message: '请输入用户名' })
                return
              }
              if (this.password.length === 0) {
                promptAction.showToast({ message: '请输入密码' })
                return
              }
              if (this.email.length === 0) {
                promptAction.showToast({ message: '请输入邮箱' })
                return
              }
              if (this.password !== this.confirmPassword) {
                promptAction.showToast({ message: '两次输入的密码不一致' })
                return
              }
              if (this.password.length < 6) {
                promptAction.showToast({ message: '密码长度不能少于6位' })
                return
              }
              if (this.verificationCode.length !== 6) {
                promptAction.showToast({ message: '验证码长度必须为6位' })
                return
              }
              if (this.photoUrl.length === 0) {
                promptAction.showToast({ message: '请选择头像' })
                return
              }


              await this.emailRegister()
              // 邮箱注册


            })

          Row() {
            Text("手机号注册")
              .fontSize(14)
              .fontColor('#007AFF')
              .onClick(() => {
                this.phoneRegisterDialog.open()
              })
          }
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.End)

        }
        .width('90%')
        .height('100%')
        .padding(20)
        .borderRadius(10)

      }
    }
    .backgroundImage($r('app.media.snowBac'))
    .backgroundImageSize(ImageSize.Auto)
    .width('100%')
    .height('100%')

  }
}