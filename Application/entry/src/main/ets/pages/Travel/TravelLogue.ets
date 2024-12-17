import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
/**
 * @Auhtor DLY
 *
 */
import { HmDetailNav } from '../../components/DetailNav'
import { travel_tips } from '../../enity/travel_tips'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct TravelLogue {
  @StorageLink('travelLogue') travelLogue: travel_tips[] = []
  @State params:string = ''
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<travel_tips> | null = null

  async onPageShow() {

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
      this.params = router.getParams() as string
      this.travelLogue= await this.cloudDataBase!.query().equalTo('id',this.params).get()
    } catch (e) {
      promptAction.showToast({ message: e.message })
      console.error("TravelLogue query error: " + JSON.stringify(e))
    }
  }

  build() {
    Column(){
      HmDetailNav({ title: '帖子详情', showBackIcon: true })
      List() {
        ForEach(this.travelLogue, (item:travel_tips, index) => {
          ListItem(){
            Column(){

              Text(item.title)
                .fontSize(28).fontWeight(FontWeight.Bold)
              Text(item.content)
                .fontSize(24)
            }
            .width('100%')
            .height('100%')
            .backgroundImage(item.photoUrl)
            .backgroundImageSize(ImageSize.Cover)

          }
          .height('100%')
        })


      }

      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }
    .height('100%')

  }
}