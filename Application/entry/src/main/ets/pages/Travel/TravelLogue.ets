import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
/**
 * @Auhtor DLY
 * TravelLogue.ets: 旅游日志
 */
import { HmDetailNav } from '../../components/DetailNav'
import { travel_tips } from '../../enity/travel_tips'
import { App, font, promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../models'
import { Label } from '../../enity/labelArray'
import { ImageList } from '../../enity/ImageList'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants'
import { HmPreview, RecommendDialog } from '../../components'

@Entry
@Component
struct TravelLogue {
  @State travelNote: travel_tips[] = []
  @State selectIndex: number = 0 // 选中的图片索引
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<travel_tips> | null = null
  // 推荐好友弹窗
  recommendFriends: CustomDialogController = new CustomDialogController({
    builder: RecommendDialog(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })
  // 图片显示弹窗
  preview: CustomDialogController = new CustomDialogController({
    builder: HmPreview({
      urls: (JSON.parse(this.travelNote[0].photoUrl) as ImageList[]).map(item => item.url), // 图片数组
      selectIndex: this.selectIndex // 默认选中第一张图片
    }),
    customStyle: true, // 自定义样式
    alignment: DialogAlignment.Center, // 居中显示
    autoCancel: true                // 点击空白处自动关闭弹窗
  })

  async onPageShow() {
    // font.getFontByName('queen')
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
      this.travelNote = await this.cloudDataBase!.query()
        .equalTo('id', params.id)
        .get()
      console.log("TravelLogue query success: " + JSON.stringify(this.travelNote))
    } catch (e) {
      promptAction.showToast({ message: e.message })
      console.error("TravelLogue query error: " + JSON.stringify(e))
    }
  }

  // 删除
  async deleteById() {
    try {
      let tip: travel_tips = new travel_tips()
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
          this.recommendFriends.open()
        }
      })
      List() {
        ForEach(this.travelNote, (item: travel_tips, index) => {
          ListItem() {
            Column({ space: 20 }) {
              Text(item.title)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .width('100%')
                .textAlign(TextAlign.Center)
                .margin({ top: 20 })
              Text(item.subtitle)
                .fontSize(20)
                .fontColor($r('app.color.text_primary'))
                .fontFamily('queen')
                .lineHeight(25)
              List() {
                ForEach((JSON.parse(item.photoUrl) as ImageList[]), (item: ImageList, index: number) => {
                  ListItem() {
                    Image(item.url)
                      .width(150)
                      .height(150)
                      .borderRadius(10)
                      .onClick(() => {
                        this.selectIndex = index
                        this.preview.open()
                      })
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
                ForEach((JSON.parse(item.getLabel()) as Label[]), (item: Label, index: number) => {
                  Text(item.labels)
                    .fontSize(14)
                    .fontColor($r('app.color.text_primary'))
                    .fontFamily('queen')
                    .textAlign(TextAlign.Center)
                    .fontColor('#ff00bbff')
                    .lineHeight(25)
                    .padding({
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5
                    })
                    .borderRadius(10)
                    .margin({ top: 10, bottom: 10 })
                    .borderWidth(1)
                    .borderColor('#f0bf')
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
            .backgroundImage((JSON.parse(item.getPhotoUrl()) as ImageList[])[0].url)
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
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
  }
}