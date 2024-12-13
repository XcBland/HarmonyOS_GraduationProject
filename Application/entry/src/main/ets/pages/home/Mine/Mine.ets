import cloud, { AuthUser } from "@hw-agconnect/cloud"
import { router } from "@kit.ArkUI"
import { AgUser } from "../../../enity"

@Preview
@Component
export struct Mine {
  user:AuthUser|null = null
  @State phone: string = ''
  @State photoUrl: string = ''
  @StorageLink('user') currentUser:AgUser|undefined = AppStorage.get<AgUser>('user')

  async aboutToAppear(){
    this.user = await cloud.auth().getCurrentUser()
    if (this.user?.getPhone()){
      this.phone = this.user.getPhone()
      this.photoUrl = this.user.getPhotoUrl()
    }
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Image($r('app.media.expansionBar'))
            .width(30)
            .aspectRatio(1)
            .fillColor($r('app.color.white'))
            .margin(10)
            .onClick(()=>{
              router.pushUrl({url:'pages/home/Mine/expansionBar'})
            })

          Image($r("app.media.setting_filling"))
            .width(30)
            .aspectRatio(1)
            .fillColor($r('app.color.white'))
            .margin(10)
            .onClick(()=>{
              router.pushUrl({url:'pages/home/Mine/SettingPage'})
            })
        }
        .margin({ top: 20 })
        .width('100%')
        .height(40)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(20)

        Column({ space: 20 }) {
          Image($r('app.media.app_icon'))
            .width(100)
            .aspectRatio(1)
            .onClick(()=>{
              router.pushUrl({url:'pages/home/Mine/MoreMine'})
            })

          Text('用户名')
            .fontSize(18)
            .fontFamily('single')
            .fontColor($r('app.color.text_primary'))
          Text('个性签名')
            .fontSize(16)
            .fontFamily('single')
            .fontColor($r('app.color.text_secondary'))
        }
        .width('100%')
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)


        Flex({ direction: FlexDirection.Column }) {
          Row() {
            Column() {
              Text('321K')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
              Text('关注')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            }

            Column() {
              Text('298')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
              Text('粉丝')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            }

            Column() {
              Text('438')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
              Text('经验值')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            }

            Button('我的订单')
              .onClick(() => {
              })
              .type(ButtonType.Normal)
              .width(100)
              .backgroundColor('#c9a4b0ff')
              .borderRadius(10)
              .fontColor('#ff00c4ff')
          }
          .margin({ top: 20 })
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)

          Divider()
            .color($r('app.color.background_divider'))
            .strokeWidth(1)
            .margin({ top: 20 })

          // TODO: 待实现(组件）
          // 旅游攻略
          Column() {
            Row() {
              Text('旅游攻略')
                .fontSize(18)
              Text('查看全部')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .onClick(() => {
                })
            }
            .width('90%')
            .margin(10)
            .justifyContent(FlexAlign.SpaceBetween)

            Scroll() {
              Row() {
                Row() {
                  Image($r('app.media.fengjing2'))
                    .height(150)
                    .borderRadius(10)
                    .aspectRatio(1)
                    .margin(10)
                    .onClick(() => {
                    })
                  Column() {
                    Text('济州岛|去不会腻的神仙地方')
                      .fontSize(16)
                      .fontColor($r('app.color.text_primary'))
                    Text('aasdadadasdasdasdasd')
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                  }
                }

                Row() {
                  Image($r('app.media.fengjing2'))
                    .height(150)
                    .borderRadius(10)
                    .aspectRatio(1)
                    .margin(10)
                    .onClick(() => {
                    })
                  Column() {
                    Text('济州岛|去不会腻的神仙地方')
                      .fontSize(16)
                      .fontColor($r('app.color.text_primary'))
                    Text('aasdadadasdasdasdasd')
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                  }
                }
              }
            }
            .scrollable(ScrollDirection.Horizontal) // 滚动方向:  水平

          }

          // 旅游手记
          Column() {
            Row() {
              Text('旅游手记')
                .fontSize(18)
              Text('查看全部')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .onClick(() => {
                })
            }
            .width('90%')
            .margin(10)
            .justifyContent(FlexAlign.SpaceBetween)

            Scroll() {
              Row() {
                Row() {
                  Image($r('app.media.fengjing2'))
                    .height(150)
                    .borderRadius(10)
                    .aspectRatio(1)
                    .margin(10)
                    .onClick(() => {
                    })
                  Column() {
                    Text('济州岛|去不会腻的神仙地方')
                      .fontSize(16)
                      .fontColor($r('app.color.text_primary'))
                    Text('aasdadadasdasdasdasd')
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                  }
                }

                Row() {
                  Image($r('app.media.fengjing2'))
                    .height(150)
                    .borderRadius(10)
                    .aspectRatio(1)
                    .margin(10)
                    .onClick(() => {
                    })
                  Column() {
                    Text('济州岛|去不会腻的神仙地方')
                      .fontSize(16)
                      .fontColor($r('app.color.text_primary'))
                    Text('aasdadadasdasdasdasd')
                      .fontSize(14)
                      .fontColor($r('app.color.text_secondary'))
                  }
                }
              }
            }
            .scrollable(ScrollDirection.Horizontal) // 滚动方向:  水平

          }

          // 我的问答
          Column(){
            Text('我的问答')
              .fontSize(18)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 20 })

            Row() {
              Image($r('app.media.app_icon'))
                .width(30)
                .aspectRatio(1)
                .position({top:5})
              Column({space: 10}) {
                Text('用户名')
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                  .margin({ top: 10 })
                Text('问题')
                  .fontSize(20)
                  .fontColor($r('app.color.text_primary'))
                Text('标签')
                  .fontSize(12)
                  .fontColor('#ff00c4ff')
                  .border({ width: 1, color: '#ff00c4ff' })
                  .padding({ left: 15, right: 15 ,top: 5, bottom: 5 })
                  .borderRadius(10)
                Row() {
                  Text('2024.12.12')
                    .fontSize(12)
                    .fontColor($r('app.color.text_secondary'))
                  Blank()
                  Image($r('app.media.app_icon'))
                    .width(15)
                    .fillColor($r('app.color.text_secondary'))
                  Text('2')
                    .margin({ left: 5 })
                    .fontSize(12)
                    .fontColor($r('app.color.text_secondary'))
                }
                .width('100%')

              }
              .margin({ left: 50 })
              .width('80%')
              .justifyContent(FlexAlign.Start)
              .alignItems(HorizontalAlign.Start)
            }
            .width('90%')
            .margin({top: 20})
          }

        }
        .width('95%')
        .height('100%')
        .backgroundColor($r('app.color.white'))
        .borderRadius(10)
        .padding({ left: 20, right: 20 })

      }

      .width('100%')
    }
    .backgroundImage($r('app.media.fengjing3'))
    .backgroundImageSize(ImageSize.Auto)
    .width('100%')
    .height('100%')

  }
}