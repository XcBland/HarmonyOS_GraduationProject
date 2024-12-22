/**
 * @Auhtor DLY
 *
 */
import { HmNavBar, HmConfirm } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { ImageList } from "../../../enity";
import { promptAction, router } from "@kit.ArkUI";
import { history_tips } from "../../../enity/history_tips";
import cloud, { Database, DatabaseCollection } from "@hw-agconnect/cloud";

@Entry
@Component
struct Browsing_History {
  @State historyList: history_tips[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<history_tips> | null = null

  async onPageShow() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<history_tips>(history_tips) // 获取云数据库的集合
    await this.queryAllHistoryByUid()
  }

  // 退出弹窗
  confimDialog: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定要全部删除吗？',
      buttonList: [
        { title: "取消", fontColor: $r('app.color.text_secondary') },
        {
          title: "确定", fontColor: $r('app.color.primary'), action: () => {
          //   实现删除
          this.deleteAllHistory()
        }
        }
      ]
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  // 查询所有的浏览记录
  async queryAllHistoryByUid() {
    try {
      const user = await cloud.auth().getCurrentUser()
      this.historyList = await this.cloudDataBase!.query().contains('id', user?.getUid()).get()
    } catch (e) {
      console.error(e)
    }
  }

  // 删除所有的浏览记录
  async deleteAllHistory() {
    try {
      await this.cloudDataBase!.delete(this.historyList)
      this.historyList = []
    } catch (e) {
      console.error("history delete error:" + e.message)
    }
  }

  @Builder
  getHistoryList() {
    Grid() {
      ForEach(this.historyList, (item: history_tips, index) => {
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
            router.pushUrl({ url: 'pages/Travel/TravelLogue', params: { id: parseInt(item.getId().split("_")[0]) } })
          })
        }
        .borderRadius(10)
        .borderWidth(1)

      })
      GridItem() {
        Row() {
          Button("清空浏览记录")
            .type(ButtonType.Normal)
            .width('50%')
            .borderRadius(10)
            .backgroundColor($r('app.color.primary'))
            .onClick(() => {
              this.confimDialog.open()
            })
        }.width('100%')
      }

    }
    .columnsTemplate('1fr 1fr') // 设置网格布局为2列
    .columnsGap(10) // 设置网格列间距
    .rowsGap(10) // 设置网格行间距
    .padding(10) // 设置网格内边距


  }

  build() {
    Column() {
      HmNavBar({ title: '浏览记录' })
      if (this.historyList.length === 0) {
        Text('暂无浏览记录')
      } else {
        Column() {
          this.getHistoryList()

        }
        .width('100%')
      }

    }
    .width('100%')
    .height('100%')
    .padding({ top: AppStorage.get<number>(APP_TOP_HEIGHT), bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT) })
    .backgroundImage($r('app.media.fengjing7'))

  }
}