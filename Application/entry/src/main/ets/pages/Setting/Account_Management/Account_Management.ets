import cloud, { AuthUser, Database, DatabaseCollection } from '@hw-agconnect/cloud'
/**
 * @Auhtor DLY
 *
 */
import {  userInfo_01 as userInfo } from '../../../enity/userInfo'
import {AgUser } from '../../../enity/AgUser'
import { HmNavBar, PassWordUpdateDialog, PhoneLinkDialog, PhoneUpdateDialog } from '../../../components'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'


@Entry
@Component
struct Account_Management {
  @StorageLink('user') currentUser: AgUser | undefined =
    AppStorage.get('user')
  user: AuthUser | null = null
  @State phone: string = ''
  @State verifyCode: string = ''
  @State content: Content[] = [
    { img: $r('app.media.QQ'), title: 'QQ', text: '绑定' },
    { img: $r('app.media.wechat'), title: '微信', text: '绑定' },
    { img: $r('app.media.weibo'), title: '微博', text: '绑定' }
  ]
  @StorageLink('local_userInfo') userInfo: userInfo = new userInfo()
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<userInfo> | undefined = undefined
  // 绑定手机号弹窗
  phoneController: CustomDialogController = new CustomDialogController({
    builder: PhoneLinkDialog(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  // 修改手机号弹窗
  phoneUpdateController: CustomDialogController = new CustomDialogController({
    builder: PhoneUpdateDialog(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  // 修改密码弹窗
  passwordController: CustomDialogController = new CustomDialogController({
    builder: PassWordUpdateDialog(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async aboutToAppear() {
    this.user = await cloud.auth().getCurrentUser()
    if (this.user?.getPhone()) {
      this.phone = this.user.getPhone()
    }
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB?.collection<userInfo>(userInfo)
    this.userInfo.getPhoneNum()
  }

  build() {
    Column() {
      HmNavBar({ title: '账号管理' })
      Column() {
        Row() {
          Text('当前登陆账号')
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin({ top: 20 })

        Row() {
          Row({ space: 5 }) {
            Image($r('app.media.phoneLine'))
              .width(40)
              .aspectRatio(1)
              .margin({ left: 5 })
            Text('手机号')
              .fontSize(20)
              .textAlign(TextAlign.Center)
          }
          .width('30%')

          Text(this.userInfo.getPhoneNum() || '未绑定')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ left: 20 })

          Blank()


          Button(this.userInfo.getPhoneNum() !== '' ? '修改' : '绑定')
            .margin({ right: 5 })
            .type(ButtonType.Normal)
            .fontSize(14)
            .backgroundColor('#ff4174ff')
            .height(30)
            .width(60)
            .borderRadius(10)
            .onClick(() => {
              if (this.phone === '') {
                // TODO 绑定手机号
                this.phoneController.open()
              } else {
                // TODO 修改手机号
                this.phoneUpdateController.open()
              }
            })

        }
        .justifyContent(FlexAlign.Start)
        .backgroundColor($r('app.color.white'))
        .width('100%')
      }
      .width('100%')
      .height(80)

      Column() {
        Row() {
          Text('第三方账户绑定')
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
        }
        .width('100%')

        Column() {
          ForEach(this.content, (item: Content, index: number) => {
            Row({ space: 5 }) {
              Row({ space: 5 }) {
                Image(item.img)
                  .width(40)
                  .aspectRatio(1)
                Text(item.title)
                  .fontSize(20)
                  .textAlign(TextAlign.Center)

              }
              .width('30%')

              Button(item.text)
                .type(ButtonType.Normal)
                .fontSize(14)
                .backgroundColor('#ff4174ff')
                .height(30)
                .width(60)
                .borderRadius(10)
                .onClick(() => {
                  console.log(item.title)
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(10)
            .backgroundColor($r('app.color.white'))

            Divider()
              .strokeWidth(1)
              .color($r('app.color.text_secondary'))
          })
        }.width('100%')
      }.width('100%').margin({ top: 20 })

      Column() {
        Row() {
          Text('登录安全')
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
        }.width('100%').justifyContent(FlexAlign.Start)

        Row() {
          Row({ space: 5 }) {
            Image($r('app.media.lock'))
              .width(40)
              .aspectRatio(1)
            Text('修改密码')
              .fontSize(20)
              .textAlign(TextAlign.Center)
          }
          .width('30%')
          .alignItems(VerticalAlign.Center)

          Text('>')
            .fontSize(18)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
            .onClick(() => {
              // TODO 修改密码
              this.passwordController.open()
            })

        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(10)
        .backgroundColor($r('app.color.white'))
      }
      .margin({ top: 20 })
    }
    .backgroundColor($r('app.color.background_page'))
    .width('100%')
    .height('100%')

  }
}

interface Content {
  img: ResourceStr
  title: string
  text: string
}