import { router } from '@kit.ArkUI'

@Component
export struct Add {
  build() {
    Column() {
      Text('发布专区')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.text_primary'))
        .margin({top:20})
      Column({ space: 30 }) {
        Row() {
          Button("发布攻略")
            .onClick(() => {
              router.pushUrl({ url: 'pages/Travel/UpdateTravelLog/UpdateTravelLog' })
            })
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.primary'))
            .borderRadius(10)

          Button("发布咨询")
            .type(ButtonType.Normal)
            .backgroundColor('#FFC107')
            .borderRadius(10)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Travel/Asking/Asking' })
            })
        }
        .width('80%')
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(VerticalAlign.Center)

        Row() {
          Button("发布游记")
            .type(ButtonType.Normal)
            .backgroundColor('#4CAF50')
            .borderRadius(10)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Travel/UploadTravelNote/UploadTravelNote' })
            })
        }
        .width('80%')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
      }
      .margin({top: 10})
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundImage($r('app.media.fengjing13'))
      .width('100%')
      .height('100%')
    }

    .width('100%')
    .height('100%')
  }
}