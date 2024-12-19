import cloud, { AuthUser, Database, DatabaseCollection } from '@hw-agconnect/cloud'
import { promptAction, router } from '@kit.ArkUI'
import { travel_tips } from '../../../enity/travel_tips'
import { userInfo_01 as userInfo } from '../../../enity/userInfo'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { ImageList } from '../../../enity/ImageList'
import { travel_notes } from '../../../enity/travel_notes'

@Preview
@Component
export struct Mine {
  user: AuthUser | null = null
  @State phone: string = ''
  @State photoUrl: string = ''
  @State displayName: string = ''
  // @StorageLink('user') currentUser: AgUser | undefined = AppStorage.get<AgUser>('user')
  @StorageLink('local_userInfo') data: userInfo = new userInfo()
  @StorageLink('travelLogue') travelLogue: travel_tips[] = []
  @StorageLink('travelNotes') travelNotes: travel_notes[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase1: DatabaseCollection<travel_tips> | null = null
  cloudDataBase2: DatabaseCollection<travel_notes> | null = null

  async aboutToAppear() {
    this.user = await cloud.auth().getCurrentUser() // 获取当前用户信息
    if (this.user?.getEmail()) {
      this.displayName = this.user.getDisplayName()
      this.phone = this.user.getEmail()
      this.photoUrl = this.user.getPhotoUrl()
    }
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase1 = this.cloudDB.collection<travel_tips>(travel_tips) // 获取云数据库的集合
    this.cloudDataBase2 = this.cloudDB.collection<travel_notes>(travel_notes) // 获取云数据库的集合
    await this.queryAllTravelLogue() // 查询数据库
  }

  //TODO: 待实现(再次调取数据库）

  // 查询数据库
  async queryAllTravelLogue() {
    try {
      this.travelLogue = await this.cloudDataBase1!.query().get()
      this.travelNotes = await this.cloudDataBase2!.query().get()
    } catch (e) {
      promptAction.showToast({ message: e.message })
    }
  }

  // 获取旅游攻略数据
  @Builder
  getTravelTips() {
    Row() {
      ForEach(this.travelLogue, (item: travel_tips, index: number) => {
        Row() {
          Image((JSON.parse(item.getPhotoUrl()) as ImageList[])[0].url
            ||
          $r('app.media.fengjing2'))
            .height(130)
            .borderRadius(10)
            .aspectRatio(1)
            .margin(10)
          Column({ space: 5 }) {
            Text(item.getTitle())
              .fontSize(14)
              .fontColor($r('app.color.text_primary'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
            Blank()
            Text(item.getContent())
              .fontSize(12)
              .fontColor($r('app.color.text_secondary'))
              .maxLines(4)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('40%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        }.onClick(() => {
          router.pushUrl({ url: 'pages/Travel/TravelLogue', params: { id: item.getId() } })
        })
      })
    }
  }

  // 获取旅游手记数据
  @Builder
  getTravelNotes() {
    Row() {
      ForEach(this.travelNotes, (item: travel_notes, index: number) => {
        Row() {
          Image((JSON.parse(item.getPhotoUrl()) as ImageList[])[0].url
            ||
          $r('app.media.fengjing2'))
            .height(130)
            .borderRadius(10)
            .aspectRatio(1)
            .margin(10)
        }.onClick(() => {
          // router.pushUrl({ url: 'pages/Travel/TravelLogue', params: { id: item.getId() } })
          //TODO: 待实现
        })

      })
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
            .onClick(() => {
              router.pushUrl({ url: 'pages/home/Mine/expansionBar' })
            })

          Image($r("app.media.setting_filling"))
            .width(30)
            .aspectRatio(1)
            .fillColor($r('app.color.white'))
            .margin(10)
            .onClick(() => {
              router.pushUrl({ url: 'pages/home/Mine/SettingPage' })
            })
        }
        .margin({ top: 20 })
        .width('100%')
        .height(40)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(20)

        Column({ space: 20 }) {
          Image(this.data.getPhotoUrl() || $r('app.media.user_dark'))
            .width(100)
            .aspectRatio(1)


          Text(this.data.getDisplayName() ? this.data.getDisplayName() : '未登录')
            .fontSize(18)
            .fontFamily('single')
            .fontColor($r('app.color.text_primary'))

          Text(this.data.getSignature() || '这个人很懒，什么都没留下')
            .fontSize(16)
            .fontFamily('single')
            .fontColor($r('app.color.text_secondary'))
            .margin({ bottom: 20 })

        }
        .width('100%')
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          router.pushUrl({ url: 'pages/home/Mine/MoreMine' })
        })

        Flex({ direction: FlexDirection.Column }) {
          Row() {
            // TODO: 待实现小组件
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
                  // TODO: queryAllTravelLogue
                })
            }
            .width('90%')
            .margin(10)
            .justifyContent(FlexAlign.SpaceBetween)

            // 获取旅游攻略数据
            Scroll() {
              this.getTravelTips()
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
                  // TODO: queryAllTravelLogue
                })
            }
            .width('90%')
            .margin(10)
            .justifyContent(FlexAlign.SpaceBetween)

            Scroll() {
              this.getTravelNotes()
            }
            .scrollable(ScrollDirection.Horizontal) // 滚动方向:  水平

          }

          // 我的问答
          Column() {
            Text('我的问答')
              .fontSize(18)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 20 })

            Row() {
              Image($r('app.media.app_icon'))
                .width(30)
                .aspectRatio(1)
                .position({ top: 5 })
              Column({ space: 10 }) {
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
                  .padding({
                    left: 15,
                    right: 15,
                    top: 5,
                    bottom: 5
                  })
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
            .margin({ top: 20 })
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