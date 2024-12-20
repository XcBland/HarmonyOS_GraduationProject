import { ImageList, ImageListEntity } from '../../../enity'
import { font, router } from '@kit.ArkUI'
import { TabIndexClass } from '../../../models'
import { travel_tips } from '../../../enity/travel_tips'
import { TravelTips } from '../../../components/TravelTips'
import { Searched } from '../../../components/Searched'

@Component
export struct Home {
  @State imgArr: ImageList[] = ImageListEntity
  @State selectedItem: SelectedItem[] = [
    { img: $r('app.media.travelBag'), title: '看游记' },
    { img: $r('app.media.hotel_02'), title: '找攻略' },
    { img: $r('app.media.tips'), title: '选酒店' }
  ]
  @State tabs: TabIndexClass[] = [
    { name: '推荐' },
    { name: '毕业季' },
    { name: '看海' },
    { name: '周边' }
  ]
  searchController: CustomDialogController = new CustomDialogController({
    builder: Searched(),
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.TopStart,
  })

  aboutToAppear(): void {
    font.registerFont({
      familyName: 'single',
      familySrc: $rawfile('font/single.TTF')
    })
  }

  // 首页头部
  @Builder
  getHomeTitle() {
    Column({ space: 10 }) {
      Column({ space: 5 }) {
        Text('乐途')
          .width('80%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .fontFamily('single')
        Text('-让旅程更快乐更简单')
          .width('80%')
          .textAlign(TextAlign.End)
          .fontSize(14)
          .fontColor($r('app.color.text_primary'))
          .fontFamily('single')
      }.width('100%')

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

      Row() {
        ForEach(this.selectedItem, (item: SelectedItem, index) => {
          Column({ space: 2 }) {
            Image(item.img)
              .width(30)
              .height(30)
              .onClick(() => {
                if (index === 0) {
                  router.pushUrl({ url: 'pages/Travel/AllTravelNotes/AllTravelNotes' })
                } else if (index === 1) {
                  router.pushUrl({ url: 'pages/Travel/AllTravelTips/AllTravelTips' })
                } else {
                  router.pushUrl({ url: 'pages/home/Hotel/AllHotels' })
                }
              })
            Text(item.title)
              .fontSize(12)
          }
        })
      }.width('100%')
      .justifyContent(FlexAlign.SpaceAround)

      Swiper() {
        ForEach(this.imgArr, (item: ImageList, index) => {
          Row() {
            Image(item.url)
              .width(250)
              .aspectRatio(1.5)
              .borderRadius(10)
              .onClick(() => {
                //router.pushUrl({url:'pages/home/TravelNoteDetail/TravelNoteDetail',params:{id:index+1}})
                router.pushUrl({ url: 'pages/Travel/AllTravelTips/AllTravelTips' })
              })

          }
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .height(200)
        })
      }
      .width('100%')
      .height(200)
      .autoPlay(true)
      .indicator(false) // 隐藏指示器
      .loop(true) // 循环播放
      .vertical(false) // 竖直方向
    }.width('100%').margin({ top: 20 })
  }

  build() {
    List() {
      ListItem() {
        this.getHomeTitle()
      }
      .width('100%')


      ListItem() {
        Tabs() {
          ForEach(this.tabs, (item: TabIndexClass, index) => {
            TabContent() {
              // 全部用一个组件
              TravelTips()
            }

            .tabBar(item.name)
          })
        }
        .backgroundColor($r('app.color.white'))
        .borderRadius({ topLeft: 10, topRight: 10 })
        .width('100%')
        .height('100%')
        .barHeight(40)
      }.width('100%')

    }
    .sticky(StickyStyle.Header)
    .backgroundImage($r('app.media.fengjing17'))
    .backgroundImageSize(ImageSize.Auto)
    .width('100%')
  }
}

interface SelectedItem {
  img: ResourceStr
  title: string
}

