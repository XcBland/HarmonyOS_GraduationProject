import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud';
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json';
/**
 * @Auhtor DLY
 *
 */
import { hotel } from '../../enity/hotel';
import { travel_notes } from '../../enity/travel_notes';
import { travel_tips } from '../../enity/travel_tips';
import { router } from '@kit.ArkUI';
import { CommonRouterParams } from '../../models';
import { HmNavBar } from '../../components';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';
import { question_list } from '../../enity/question_list';

@Entry
@Component
struct SearchPage {
  @State travelTips: travel_tips[] = []
  @State travelNotes: travel_notes[] = []
  @State hotels: hotel[] = []
  @State questions: question_list[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase1: DatabaseCollection<travel_tips> | null = null
  cloudDataBase2: DatabaseCollection<travel_notes> | null = null
  cloudDataBase3: DatabaseCollection<hotel> | null = null
  cloudDataBase4: DatabaseCollection<question_list> | null = null

  async onPageShow() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase1 = this.cloudDB.collection<travel_tips>(travel_tips) // 获取云数据库的集合
    this.cloudDataBase2 = this.cloudDB.collection<travel_notes>(travel_notes) // 获取云数据库的集合
    this.cloudDataBase3 = this.cloudDB.collection<hotel>(hotel) // 获取云数据库的集合
    this.cloudDataBase4 = this.cloudDB.collection<question_list>(question_list) // 获取云数据库的集合
    await this.queryTips()
    await this.queryNotes()
    await this.queryHotels()
    await this.queryQuestions()
  }

  // 查询游记数据
  async queryNotes() {
    try {
      const params = router.getParams() as CommonRouterParams
      this.travelNotes = await this.cloudDataBase2!.query()
        .contains('title', params.keyword)
        .or()
        .contains('subtitle', params.keyword)
        .or()
        .contains('content', params.keyword)
        .or()
        .contains('label', params.keyword)
        .get()
    } catch (e) {
      console.log('queryNotes error:' + e.message)
    }
  }

  // 查询酒店数据
  async queryHotels() {
    try {
      const params = router.getParams() as CommonRouterParams
      this.hotels = await this.cloudDataBase3!.query()
        .contains('hotelName', params.keyword)
        .or()
        .contains('address', params.keyword)
        .or()
        .contains('synopsis', params.keyword)
        .get()
    } catch (e) {
      console.log('queryHotels error:' + e.message)
    }
  }

  // 查询攻略数据
  async queryTips() {
    try {

      const params = router.getParams() as CommonRouterParams
      this.travelTips = await this.cloudDataBase1!.query()
        .contains('title', params.keyword)
        .or()
        .contains('subtitle', params.keyword)
        .or()
        .contains('content', params.keyword)
        .or()
        .contains('label', params.keyword)
        .get()
    } catch (e) {
      console.log('queryNotes error:' + e.message)
    }


  }

  // 查询问答数据
  async queryQuestions() {
    try {
      const params = router.getParams() as CommonRouterParams
      this.questions = await this.cloudDataBase4!.query()
        .contains('title', params.keyword)
        .or()
        .contains('content', params.keyword)
        .or()
        .contains('label', params.keyword)
        .get()
    } catch (e) {
      console.log('queryQuestions error:' + e.message)
    }
  }

  // 获取结果列表
  @Builder
  getList() {
    List() {
      if (this.travelTips.length > 0) {
        ListItemGroup() {
          ListItem() {
            Column() {
              Text('旅游攻略')
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 10 })
              ForEach(this.travelTips, (item: travel_tips, index) => {
                Text(item.title)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Travel/TravelLogue', params: { id: index + 1 } })
                  })
              })
            }
          }
        }
      }
      if (this.travelNotes.length > 0) {
        ListItemGroup() {
          ListItem() {
            Column() {
              Text('旅游游记')
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 10 })
              ForEach(this.travelNotes, (item: travel_notes, index) => {

                Text(item.title)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Travel/TravelNote', params: { id: index + 1 } })
                  })

              })
            }
          }
        }
      }
      if (this.hotels.length > 0) {
        ListItemGroup() {
          ListItem() {
            Column() {
              Text('酒店')
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 10 })
              ForEach(this.hotels, (item: hotel, index) => {
                Text(item.hotelName)
                  .onClick(() => {
                    //TODO: 跳转到酒店详情页面
                    router.pushUrl({ url: 'pages/home/Hotel/HotelDetail/HotelDetail', params: { id: index + 1 } })
                  })

              })
            }
          }
        }
      }
      if (this.questions.length > 0) {
        ListItemGroup() {
          ListItem() {
            Column() {
              Text('问答')
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 10 })
              ForEach(this.questions, (item: question_list, index) => {
                Text(item.title)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/Travel/Asking/AskingDetail', params: { id: index + 1 } }) // 跳转到问答详情页面
                  })
              })
            }
          }
        }
      }
    }
  }

  build() {
    Column() {
      HmNavBar({ title: '搜索详情' })
      this.getList()
    }
    .height('100%')
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}