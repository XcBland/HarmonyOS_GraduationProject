import { TravelNotes, TravelTips } from "../../../components"
import { AskingComp } from "../../../components/AskingComp"
import { Searched } from "../../../components/Searched"
import { travel_tips } from "../../../enity/travel_tips"
import { TabIndexClass } from "../../../models"
import { router } from "@kit.ArkUI"

@Component
export struct Safari {
  @State tabs: TabIndexClass[] = [
    { name: '攻略' },
    { name: '游记' },
    { name: '问答' }
  ]
  searchController: CustomDialogController = new CustomDialogController({
    builder: Searched(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.TopStart,
  })

  @Builder
  Title() {
    Row() {
      Search()
        .width('100%')
        .onClick(() => {
          // TODO: 搜索功能
          this.searchController.open()
        })
        .height(40)
    }
    .width('90%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.white'))
    .borderRadius(20)
    .height(40)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      List() {
        ListItem() {
          this.Title()
        }
        .width('100%')
        .margin({ top: 10 })

        ListItem() {
          Tabs() {
            ForEach(this.tabs, (item: TabIndexClass, index) => {
              TabContent() {
                if (index === 0) {
                  TravelTips()
                } else if (index === 1) {
                  TravelNotes()
                } else {
                  AskingComp()
                }
              }.tabBar(item.name)
            })
          }
          .backgroundColor($r('app.color.white'))
          .borderRadius({ topLeft: 10, topRight: 10 })
          .width('100%')
          .height('100%')
          .barHeight(40)
        }.width('100%')
        .margin({ top: 10 })
      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.fengjing20'))
      .sticky(StickyStyle.Header)

      Image($r('app.media.servicer'))
        .width(30)
        .height(30)
        .position({ bottom: 30, right: 10 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Setting/Common_Problems/Common_Problems' })
        })


    }
  }
}