/**
 * @Auhtor DLY
 *
 */
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud';
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json';
import { HmNavBar } from '../../components';
import { travel_tips } from '../../enity/travel_tips';
import { travel_notes } from '../../enity/travel_notes';
import { hotel } from '../../enity/hotel';
import { question_list } from '../../enity/question_list';
import { router } from '@kit.ArkUI';
import { CommonRouterParams } from '../../models';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';
import { ImageList } from '../../enity';

@Entry
@Component
struct LabelPage {
  @State travelTips: travel_tips[] = []
  @State travelNotes: travel_notes[] = []
  @State questions: question_list[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase1: DatabaseCollection<travel_tips> | null = null
  cloudDataBase2: DatabaseCollection<travel_notes> | null = null
  cloudDataBase4: DatabaseCollection<question_list> | null = null

  async onPageShow() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase1 = this.cloudDB.collection<travel_tips>(travel_tips) // 获取云数据库的集合
    this.cloudDataBase2 = this.cloudDB.collection<travel_notes>(travel_notes) // 获取云数据库的集合
    this.cloudDataBase4 = this.cloudDB.collection<question_list>(question_list) // 获取云数据库的集合
    await this.getAllLabels()
  }

  /* 查询所有标签 */
  async getAllLabels() {
    const params = router.getParams() as CommonRouterParams
    this.travelTips = await this.cloudDataBase1!.query()
      .contains('label', params.keyword)
      .get()
    this.travelNotes = await this.cloudDataBase2!.query()
      .contains('label', params.keyword)
      .get()
    this.questions = await this.cloudDataBase4!.query()
      .contains('label', params.keyword)
      .get()
  }

  // 渲染标签详情页面
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
                Column() {
                  Text(item.title)

                }
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
                Column() {
                  Text(item.title)

                }
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Travel/TravelNote', params: { id: index + 1 } })
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
                Column() {
                  Text(item.title)
                  Text(item.content)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                    .margin({ top: 10, left: 10 })
                }
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
      HmNavBar({ title: '标签详情', showBackIcon: false })
      this.getList()
      Blank()
      Text("返回首页")
        .onClick(() => {
          router.replaceUrl({ url: 'pages/home/Index' })
          router.clear()
        })
    }
    .width('100%')
    .height('100%')
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}