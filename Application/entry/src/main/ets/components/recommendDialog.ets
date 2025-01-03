import { promptAction } from "@kit.ArkUI"

@Preview
@CustomDialog
@Component
export struct RecommendDialog {
  recommend: CustomDialogController
  @State recommendWay: recommendWay[] = [
    { img: $r('app.media.wechat'), text: '微信' },
    { img: $r('app.media.QQ'), text: 'QQ' },
    { img: $r('app.media.weibo'), text: '微博' },
    { img: $r('app.media.link'), text: '复制链接' }
  ]

  build() {
    Column() {
      Row() {
        Text('立即分享给好友')
      }.width('100%').margin(30)
      .justifyContent(FlexAlign.Center)

      Row() {
        ForEach(this.recommendWay, (item: recommendWay, index: number) => {
          Column({ space: 5 }) {
            Image(item.img)
              .width(50)
              .aspectRatio(1)
            Text(item.text)
              .fontSize(12)
              .textAlign(TextAlign.Center)
          }
          .onClick(() => {
            if (index === 3) {
              promptAction.showToast({ message: '复制链接成功，请在微信、QQ、微博中打开并分享' })
              this.recommend.close()
            } else {
              promptAction.showToast({ message: '尚未绑定，请先绑定对应的平台' })
              this.recommend.close()
            }
          })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('80%')
      .justifyContent(FlexAlign.SpaceAround)


      Button('取消')
        .width('100%')
        .type(ButtonType.Normal)
        .fontColor($r('app.color.text_primary'))
        .borderWidth(0)
        .onClick(() => {
          this.recommend.close()
        })
        .margin({ top: 20, bottom: 30 })
        .backgroundColor($r('app.color.white'))
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .borderRadius(10)
  }
}

// 分享方式
interface recommendWay {
  img: ResourceStr
  text: string
}