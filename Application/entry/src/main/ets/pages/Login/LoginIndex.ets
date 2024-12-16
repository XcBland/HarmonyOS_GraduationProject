import { APP_TOP_HEIGHT, TOKEN_KEY } from '../../constants'
import { font, router } from '@kit.ArkUI'
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import { BusinessError } from '@kit.BasicServicesKit'
import { PhoneLoginDialog } from '../../components/PhoneLoginDialog'
import { userInfo_01 as userInfo } from '../../enity/userInfo';
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
/**
 * @Auhtor DLY
 *
 */
PersistentStorage.persistProp(TOKEN_KEY, "")

@Entry
@Component
struct LoginIndex {
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  // 状态变量
  @State email: string = ''
  @State password: string = ''
  @StorageLink('local_userInfo')data:userInfo = new userInfo()

  cloudDataBase:DatabaseCollection<userInfo>|undefined = undefined
  // 手机登录弹窗
  phoneLoginTo:CustomDialogController = new CustomDialogController({
    builder:PhoneLoginDialog(),
    customStyle: true,
    autoCancel: true,
    alignment: DialogAlignment.Center,
  })
  // 页面初始化
  init(){
    this.email = ''
    this.password = ''
    this.logOut()
  }

  // 登出
  async logOut(){
    await cloud.auth().signOut()
  }

  // 邮箱登录
  async emailLogin(){
    await cloud.auth().signIn({
      autoCreateUser: true,
      credentialInfo:{
        kind:'email',
        email:this.email,
        password:this.password
      }
    }).then(user => {
      AppStorage.set(TOKEN_KEY, user.getUser().getToken(true))
      router.replaceUrl({url:'pages/home/Index'})
    }).catch((error:BusinessError) => {
      console.error('login28-->'+JSON.stringify(error))
    })
  }

  // 获取Auth的Uid，根据Uid对应判断数据库里的内容
  async getUid(){
    const uid = await cloud.auth().getCurrentUser().then(user => {
      return user?.getUid()
    })
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB?.collection<userInfo>(userInfo)
    const data = await this.cloudDataBase?.query().equalTo('id',uid).get()
    if(data.length > 0){
      this.data = data[0]
    }
  }


  // 生命周期函数
  aboutToAppear(){
    // this.init()
    font.registerFont({
      familyName:'JiaoDai',
      familySrc:$rawfile('font/JiaoDai.TTF')
    })
    font.registerFont({
      familyName:'queen',
      familySrc:$rawfile('font/queen.TTF')
    })
    font.registerFont({
      familyName:'single',
      familySrc:$rawfile('font/single.TTF')
    })

  }
  build() {
    Column() {
      Row().width('100%').height(AppStorage.get<number>(APP_TOP_HEIGHT))
      Text('LeTo')
        .margin({top:100})
        .fontSize(50)
        .fontFamily('JiaoDai')
        .fontWeight(500)

      Row(){
        Image($r('app.media.single'))
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
        TextInput({placeholder:'请输入邮箱'})
          .type(InputType.Email)
          .onChange((value:string)=>{
            this.email = value
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

      Row(){
        Image($r('app.media.lock'))
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
        TextInput({placeholder:'请输入登陆密码'})
          .onChange((value)=>{
            this.password = value
          })
          .type(InputType.Password)
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

      Button('登录')
        .type(ButtonType.Normal)
        .width('90%')
        .height(40)
        .margin({top:20})
        .backgroundColor('#00BFFF')
        .fontFamily('single')
        .borderRadius(5)
        .fontSize(24)
        .fontWeight(500)
        .onClick(()=>{
          this.emailLogin()
        })

      Row(){
        Text('游客登录')
          .fontSize(18)
          .fontColor($r('app.color.white'))
          .fontFamily('queen')

        Text('账号注册')
          .fontSize(18)
          .fontColor($r('app.color.white'))
          .fontFamily('queen')
          .onClick(()=>{
            router.pushUrl({url:'pages/Register/Registration'})
          })
        Text('忘记密码?')
          .fontSize(14)
          .fontColor($r('app.color.white'))
          .fontFamily('queen')
      }
      .margin({top:20})
      .justifyContent(FlexAlign.SpaceAround)
      .width('90%')
      .height(40)


      Row(){
        Image($r('app.media.line'))
          .width(50)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
        Text('或通过以下方式进行登录')
          .fontSize(14)
          .fontColor('#ffaf09ec')
          .fontFamily('queen')

        Image($r('app.media.line'))
          .width(50)
          .aspectRatio(1)
          .fillColor($r('app.color.white'))
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width('90%')
      .height(40)
      .margin({top:120})

      Row(){
        Image($r('app.media.phone'))
          .width(50)
          .aspectRatio(1)
          .onClick(()=>{
            this.phoneLoginTo.open()
          })

        Image($r('app.media.wechat'))
          .width(40)
          .aspectRatio(1)
          .fillColor('#ff03ff1d')

        Image($r('app.media.QQ'))
          .width(40)
          .aspectRatio(1)

        Image($r('app.media.weibo'))
          .width(40)
          .aspectRatio(1)
          .fillColor('#ffe70519')


      }
      .width('60%')
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
      .margin({top:20})

      Row(){
        Text('登录或注册代表您同意《用户服务协议》')
          .fontSize(12)
          .fontColor($r('app.color.white'))
          .fontFamily('queen')
      }
      .margin({top:50})
      .width('60%')
      .justifyContent(FlexAlign.Center)

    }
    .backgroundImage($r('app.media.fengjing1'))
    .backgroundImageSize(ImageSize.Cover)
    .width('100%')
    .height('100%')

  }
}