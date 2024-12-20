import cloud, { Database, DatabaseCollection } from "@hw-agconnect/cloud";
import { travel_notes } from "../enity/travel_notes";
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { ImageList } from "../enity";
import { promptAction, router } from "@kit.ArkUI";

@Component
export struct TravelNotes {
  @StorageLink('travelNotes') travelNotes: travel_notes[] = [];
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<travel_notes> | null = null

  async aboutToAppear() {

    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<travel_notes>(travel_notes) // 获取云数据库的集合
    await this.queryAllTravelNotes()
  }

  // 获取云数据库数据
  async queryAllTravelNotes() {
    try {
      this.travelNotes = await this.cloudDataBase!.query().get()
    } catch (e) {
      promptAction.showToast({ message: e.message })
    }
  }

  build() {
    Grid() {
      ForEach(this.travelNotes, (item: travel_notes, index) => {
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