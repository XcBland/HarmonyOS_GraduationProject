import cloud, { AuthUser } from '@hw-agconnect/cloud'
/**
 * @Auhtor DLY
 *
 */
import { AgUser } from '../../../enity'
import { HmCard, HmNavBar } from '../../../components'

@Entry
@Component
struct Account_Management {
  @StorageLink('user') currentUser:AgUser | undefined =
    AppStorage.get('user')
  user: AuthUser | null = null
  @State phone: string = ''
  @State content: Content[] = [
    {img:$r('app.media.QQ'),title:'QQ',text:'绑定'},
    {img:$r('app.media.wechat'),title:'微信',text:'绑定'},
    {img:$r('app.media.weibo'),title:'微博',text:'绑定'}
  ]
  async aboutToAppear(){
    this.user = await cloud.auth().getCurrentUser()
    if (this.user?.getPhone()){
      this.phone = this.user.getPhone()
    }
  }
  build() {
    Column() {
      HmNavBar({title: '账号管理'})
      Column(){
        Row(){
          Text('当前登陆账号')
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        Row(){
          Row({space:5}){
            Image($r('app.media.phoneLine'))
              .width(40)
              .aspectRatio(1)
              .margin({left:5})
            Text('手机号')
              .fontSize(20)
              .textAlign(TextAlign.Center)
          }
          .width('30%')
          Text(this.phone || '未绑定')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({left:20})

          Blank()

          Button(this.phone!==''? '修改' : '绑定')
            .margin({right:5})
            .type(ButtonType.Normal)
            .fontSize(14)
            .backgroundColor($r('app.color.white'))
            .height(30)
            .width(100)
            .onClick(() => {
              if(this.phone === ''){
                // TODO 绑定手机号
              }else{
                // TODO 修改手机号
              }
            })

        }
        .justifyContent(FlexAlign.Start)
        .backgroundColor($r('app.color.white'))
        .width('100%')
      }
      .width('100%')
      .height(80)
      Column(){
        Row(){
          Text('第三方账户绑定')
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        Column(){
          ForEach(this.content,(item:Content,index:number)=>{
            Row({space:5}){
              Row({space:5}){
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
      }.width('100%').margin({top:20})

      Column(){
        Row(){
          Text('登录安全')
            .fontSize(20)
            .fontColor($r('app.color.text_secondary'))
            .textAlign(TextAlign.Center)
        }.width('100%').justifyContent(FlexAlign.Start)
        Row(){
          Row({space:5}){
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
            })

        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(10)
        .backgroundColor($r('app.color.white'))
      }
      .margin({top:20})
    }
    .backgroundColor($r('app.color.background_page'))
    .width('100%')
    .height('100%')


  }
}

interface Content{
  img:ResourceStr
  title:string
  text:string
}