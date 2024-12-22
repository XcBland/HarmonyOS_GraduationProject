/**
 * @Auhtor DLY
 *
 */
import { hotel } from '../../../../enity/hotel'
import { font, promptAction, router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../../../models'
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import { HmNavBar } from '../../../../components'
import schema from '../../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../../constants'

@Entry
@Component
struct HotelDetail {
  @State hotelList: hotel[] = []

  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<hotel> | null = null

  async aboutToAppear() {
    font.registerFont({
      familyName:'queen',
      familySrc:$rawfile('font/queen.TTF')
    })
  }
  async onPageShow() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<hotel>(hotel) // 获取云数据库的集合

    await this.query()
  }

  // 查询
  async query() {
    try {
      const params: CommonRouterParams = router.getParams() as CommonRouterParams
      this.hotelList = await this.cloudDataBase!.query().equalTo('id', parseInt(params.id)).get()
      console.log("TravelLogue query success: " + JSON.stringify(this.hotelList))
    } catch (e) {
      promptAction.showToast({ message: e.message })
      console.error("TravelLogue query error: " + JSON.stringify(e))
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '酒店详情', showBackIcon: true })
      List() {
        ForEach(this.hotelList, (item: hotel, index) => {
          ListItem() {
            Column({space:20}) {
              Text(item.hotelName)
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
                .fontFamily('queen')
                .fontColor($r('app.color.white'))
                .margin({top: 20, bottom: 10})
              Image(item.hotelPhoto)
                .width(300)
                // .aspectRatio(2)
                .borderWidth(1)
                .borderRadius(10)


              Column({space:10}){
                Text('酒店简介:')
                  .fontSize(24)
                  .fontColor($r('app.color.white'))
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .margin({left: 10})
                Text(item.synopsis)
                  .fontSize(22)
                  .fontColor($r('app.color.white'))
                  .width('100%')
                  .textAlign(TextAlign.Start)
              }
              .width('100%')
              Blank()
              Text('想要了解具体详情请是使用浏览器打开酒店官网 '+item.website)
                .fontSize(16)
                .fontColor($r('app.color.white'))
              Text('酒店地址: '+item.address)
                .fontSize(16)
                .fontColor($r('app.color.white'))
              Text("预定电话: "+item.schedulePhone)
                .fontSize(16)
                .fontColor($r('app.color.white'))
              Row().height(300)
                .width('100%')
            }.width('100%').padding(10)
          }
          .width('100%')
          .backgroundImage(item.hotelPhoto)
          .backgroundImageSize(ImageSize.FILL)
        })

      }
    }
    .width('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
  }
}