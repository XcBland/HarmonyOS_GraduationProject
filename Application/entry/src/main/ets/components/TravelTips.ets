import cloud, { Database, DatabaseCollection } from "@hw-agconnect/cloud";
import { travel_tips } from "../enity/travel_tips";
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { ImageList } from "../enity";
import { promptAction, router } from "@kit.ArkUI";
import { history_tips } from "../enity/history_tips";
import dayjs from "@hview/dayjs";

@Component
export struct TravelTips {
  @StorageLink('travelTips') travelTips: travel_tips[] = [];
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase1: DatabaseCollection<travel_tips> | null = null
  cloudDataBase2: DatabaseCollection<history_tips> | null = null

  async aboutToAppear() {

    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase1 = this.cloudDB.collection<travel_tips>(travel_tips) // 获取云数据库的集合
    this.cloudDataBase2 = this.cloudDB.collection<history_tips>(history_tips) // 获取云数据库的集合
    await this.queryAllTravelTips()
  }

  // 获取云数据库数据
  async queryAllTravelTips() {
    try {
      this.travelTips = await this.cloudDataBase1!.query().get()
    } catch (e) {
      promptAction.showToast({ message: e.message })
    }
  }

  // 点击数据之后，上传到历史记录
  async upLoadTravelTipsToHistory(travelTip: travel_tips) {
    try {
      const user = await cloud.auth().getCurrentUser()
      const historyTip = new history_tips()
      historyTip.setId(travelTip.getId() + "_" + user!.getUid()) // 时间戳+uid
      historyTip.setTitle(travelTip.getTitle())
      historyTip.setSubtitle(travelTip.getSubtitle())
      historyTip.setContent(travelTip.getContent())
      historyTip.setPhotoUrl(travelTip.getPhotoUrl())
      historyTip.setLabel(travelTip.getLabel())
      historyTip.setScanTime(dayjs().format('YYYY-MM-DD HH:mm:ss'))
      await this.cloudDataBase2!.upsert(historyTip)
    } catch (e) {
      console.log("history upload failed " + e)
    }
  }

  build() {
    Grid() {
      ForEach(this.travelTips, (item: travel_tips, index) => {
        GridItem() {
          Column() {
            Image((JSON.parse(item.getPhotoUrl()) as ImageList[])[0].url
              ||
            $r('app.media.fengjing2'))
              .height(170)
              .aspectRatio(1)
              .borderRadius(10)
              .margin(10)
            Column({ space: 5 }) {
              Text(item.getTitle())
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text(item.getSubtitle())
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text(item.getContent())
                .fontSize(12)
                .fontColor($r('app.color.text_secondary'))
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            // .height(200)
            .justifyContent(FlexAlign.SpaceAround)
            .alignItems(HorizontalAlign.Center)
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/Travel/TravelLogue', params: { id: item.getId() } })
            this.upLoadTravelTipsToHistory(item)
          })
        }
        .borderRadius(10)
        .borderWidth(1)
      })
    }
    .columnsTemplate('1fr 1fr') // 设置网格布局为2列
    .columnsGap(10) // 设置网格列间距
    .rowsGap(10) // 设置网格行间距
    .padding(10) // 设置网格内边距

  }
}