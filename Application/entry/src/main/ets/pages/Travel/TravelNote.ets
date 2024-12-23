import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
/**
 * @Auhtor DLY
 * TravelLogue.ets: 旅游日志
 */
import { HmDetailNav } from '../../components/DetailNav'
import { travel_notes } from '../../enity/travel_notes'
import { font, promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../models'
import { Label } from '../../enity/labelArray'
import { ImageList } from '../../enity/ImageList'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants'

@Entry
@Component
struct TravelNote {
  @State travelNote: travel_notes[] = []
  // @State imgList: ImageList[] = []
  @State selectIndex: number = 0 // 选中的图片索引
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<travel_notes> | null = null

  async onPageShow() {
    font.getFontByName('queen')
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<travel_notes>(travel_notes) // 获取云数据库的集合

    await this.query()
  }

  // 查询
  async query() {
    try {
      const params = router.getParams() as CommonRouterParams
      this.travelNote = await this.cloudDataBase!.query().equalTo('id', params.id).get()
      console.log("TravelLogue query success: " + JSON.stringify(this.travelNote))
    } catch (e) {
      promptAction.showToast({ message: e.message })
      console.error("TravelLogue query error: " + JSON.stringify(e))
    }
  }

  // 删除
  async deleteById() {
    try {
      let tip: travel_notes = new travel_notes()
      tip.id = this.travelNote[0].id
      let result = await this.cloudDataBase!.delete(tip)
      promptAction.showToast({ message: '删除成功' })


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
        ForEach(this.travelNote, (item: travel_notes, index) => {
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
              .scrollBar(BarState.Off)
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
                    .onClick(() => {
                      router.replaceUrl({ url: 'pages/LabelPage/LabelPage', params: { keyword: item.labels } })
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
            .backgroundImage((JSON.parse(item.getPhotoUrl()) as ImageList[])[1].url)
            .backgroundImageSize(ImageSize.FILL)
            .width('100%')

          }
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')



    }
    .height('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}