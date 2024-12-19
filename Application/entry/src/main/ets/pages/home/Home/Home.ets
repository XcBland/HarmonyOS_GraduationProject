import { ImageList, ImageListEntity } from '../../../enity'
import { font } from '@kit.ArkUI'
import { TabIndexClass } from '../../../models'
import { travel_tips } from '../../../enity/travel_tips'

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
  @StorageLink('travelLogue') travelLogue: travel_tips[] = []

  aboutToAppear(): void {
    font.registerFont({
      familyName: 'single',
      familySrc: $rawfile('font/single.TTF')
    })
  }

  @Builder
  getTravelTips() {
    Column() {
      Text('旅行攻略')
    }
  }

  build() {
    Column() {
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
              Text(item.title)
                .fontSize(12)
            }
          })
        }.width('100%')
        .justifyContent(FlexAlign.SpaceAround)

      }.width('100%').margin({ top: 20 })


      Swiper() {
        ForEach(this.imgArr, (item: ImageList, index) => {
          Row() {
            Image(item.url)
              .width(250)
              .aspectRatio(1.5)
              .borderRadius(10)
              .onClick(() => {
                // TODO: 跳转到详情页(三个全部)
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

      Tabs() {
        ForEach(this.tabs, (item: TabIndexClass, index) => {
          TabContent() {
            // 全部用一个组件
          }
          .backgroundColor($r('app.color.white'))
          .tabBar(item.name)
        })
      }
      .width('100%')
      .height('100%')
      .barHeight(40)

    }
    .backgroundImage($r('app.media.fengjing17'))
    .backgroundImageSize(ImageSize.Auto)
    .width('100%')
  }
}

interface SelectedItem {
  img: ResourceStr
  title: string
}

