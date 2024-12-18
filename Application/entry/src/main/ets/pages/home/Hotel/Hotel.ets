import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json';
import { hotel } from '../../../enity/hotel';
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud';
import { router } from '@kit.ArkUI';

@Component
export struct Hotel {
  @StorageProp('hotel') hotel: hotel[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<hotel> | null = null

  async aboutToAppear() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<hotel>(hotel) // 获取云数据库的集合
    await this.queryHotel()
  }

  // 查询云数据库
  async queryHotel() {
    try {
      this.hotel = await this.cloudDataBase!.query().limit(10).get() // 查询云数据库，限制10条数据
    } catch (error) {
      console.error('Failed to query hotel data from CloudDB-->25: ' + error.message)
    }
  }

  build() {
    Column() {
      Text('热门精选星级酒店')
        .fontSize(24)
        .fontWeight(700)
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ top: 20 })
      // TODO:@builder 代替下面代码
      List() {
        ForEach(this.hotel, (item: hotel, index) => {
          ListItem() {
            Row({ space: 5 }) {
              Image(item.hotelPhoto)
                .width(150)
                .aspectRatio(1)
                .margin({ right: 10 })
              Column({space:10}) {
                Text('酒店名称：' + item.hotelName)
                  .fontSize(20)
                  .textAlign(TextAlign.Start)
                Text("价格: " + item.prices + '/晚')
                  .fontSize(14)
                  .textAlign(TextAlign.Start)
                Text('地址：' + item.address)
                  .fontSize(14)
                  .textAlign(TextAlign.Start)
                  .padding({ right: 5 })
                Text('预定电话：' + item.schedulePhone)
                  .fontSize(14)
                  .textAlign(TextAlign.Start)
              }
              .width('60%')
              .justifyContent(FlexAlign.SpaceAround)
              .alignItems(HorizontalAlign.Start)
            }
            .onClick(() => {
              router.pushUrl({url:'pages/home/Hotel/HotelDetail/HotelDetail',params: {id: (index+1).toString()}})
            })

            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

          }

          .borderWidth(1)
          .shadow(ShadowStyle.OUTER_DEFAULT_MD)
          .borderRadius(10)
          .width('95%')
          .margin({ top: 10,left: '2.5%',right: '2.5%' })
        })
        ListItem() {
          Row().width('100%')
            .height(100)
        }
      }
      .backgroundImage($r('app.media.fengjing9'))
      .backgroundImageSize(ImageSize.Cover)
      .margin({ top: 20 })
      .width('100%')
    }
    .width('100%')
  }
}