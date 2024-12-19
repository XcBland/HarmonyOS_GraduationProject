import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
/**
 * @Auhtor DLY
 * TravelLogue.ets: 旅游日志
 */
import { HmDetailNav } from '../../components/DetailNav'
import { travel_tips } from '../../enity/travel_tips'
import { font, promptAction, router } from '@kit.ArkUI'
import CommonRouterParams from '../../models/router'
import { Label } from '../../enity/labelArray'
import { ImageList } from '../../enity/ImageList'

@Entry
@Component
struct TravelLogue {
  @State travelLogue: travel_tips[] = []
  // @State imgList: ImageList[] = []
  @State selectIndex: number = 0 // 选中的图片索引
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<travel_tips> | null = null

  async onPageShow() {
    font.getFontByName('queen')
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<travel_tips>(travel_tips) // 获取云数据库的集合

    await this.query()
  }

  // 查询
  async query() {
    try {
      const params = router.getParams() as CommonRouterParams
      this.travelLogue = await this.cloudDataBase!.query().equalTo('id', params.id).get()
      console.log("TravelLogue query success: " + JSON.stringify(this.travelLogue))
    } catch (e) {
      promptAction.showToast({ message: e.message })
      console.error("TravelLogue query error: " + JSON.stringify(e))
    }
  }

  // 删除
  async deleteById() {
    try {
      let tip: travel_tips = new travel_tips()
      tip.id = this.travelLogue[0].id
      let result = await this.cloudDataBase!.delete(tip)
      promptAction.showToast({ message: '删除成功' })
      // TODO: 通信刷新

    } catch (e) {
      promptAction.showToast({ message: e.message })
    }
  }

  build() {
    Column() {
      HmDetailNav({
        title: '帖子详情',
        showBackIcon: true,
        onDeleteClick: async () => {
          await this.deleteById()
        },
        onRouterClick: () => {

        }
      })
      List() {
        ForEach(this.travelLogue, (item: travel_tips, index) => {
          ListItem() {
            Column({ space: 20 }) {
              Text(item.title)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .width('100%')
                .textAlign(TextAlign.Center)
                .margin({ top: 20 })
              List() {
                ForEach((JSON.parse(item.photoUrl) as ImageList[]), (item: ImageList, index: number) => {
                  ListItem() {
                    Image(item.url)
                      .width(150)
                      .height(150)
                      .borderRadius(10)
                  }
                })
              }
              .listDirection(Axis.Horizontal) // 列表方向: 水平
              Text(item.content)
                .fontSize(20)
                .fontColor($r('app.color.text_primary'))
                .fontFamily('queen')
                .lineHeight(25)


              Row({ space: 5 }) {
                ForEach((JSON.parse(item.label) as Label[]), (item: Label, index) => {
                  Text(item.labels)
                    .fontSize(16)
                    .backgroundColor('#ff6a7efd')
                    .fontColor($r('app.color.white'))
                    .borderRadius(10)
                    .width(90)
                    .textAlign(TextAlign.Center)
                    .padding({
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5
                    })
                })
              }
              .width('100%')

              Row() {
                Text('发布时间 :' + item.publishTime)
                  .fontSize(14)
                  .fontColor($r('app.color.text_primary'))
              }
              .width('100%')


              Row().height(500).opacity(0)
            }
            .padding(10)
            .backgroundImage((JSON.parse(item.getPhotoUrl()) as ImageList[])[0].url)
            .backgroundImageSize(ImageSize.FILL)
            .width('100%')

          }
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')


      /*      Scroll(){
              ForEach(this.travelLogue, (item:travel_tips, index) => {
                Column({space:20}){
                  Text(item.title)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .width('100%')
                    .textAlign(TextAlign.Center)
                  Text(item.content)
                    .fontSize(20)
                    .fontColor($r('app.color.white'))
                    .fontFamily('queen')
                  Row().height(10).opacity(0)
                }
                .width('100%')
                .height('100%')
                .backgroundImage(item.getPhotoUrl())
                .backgroundImageSize(ImageSize.Cover)
              })
            }
            .height('100%')*/

    }
    .height('100%')

  }
}