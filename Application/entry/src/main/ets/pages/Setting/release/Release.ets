/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmCardItem, HmNavBar } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct Release {
  build() {
    Column() {
      HmNavBar({ title: '关于我们' })
      Column() {
        Image($r('app.media.LeTo'))
          .width(300)
          .height(150)
          .margin({ top: 20 })
        Text('乐途')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20 })

        Text('版本号：1.0.25')
          .fontSize(18)
          .fontColor($r('app.color.primary'))
          .margin({ top: 20 })

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .margin({ top: 20 })

      HmCard() {
        HmCardItem({
          leftTitle: "隐私协议", showRightIcon: true, onRightClick: () => {
          }
        })
        HmCardItem({
          leftTitle: "用户协议", showRightIcon: true, onRightClick: () => {
          }
        })
      }

      Blank()
      Column() {
        Text('发布日期：2024-12-20')
        Text('联系方式：13810100000')
        Text('公司地址：天津市和平区')
        Text('邮编：000000')
        Text('Copyright © 2024 乐途科技有限公司')
        Text('乐途科技有限公司')
        Text('乐途是一款基于HarmonyOS的智能出行应用，由乐途科技有限公司开发。')
      }
      .margin(30)

    }
    .backgroundColor($r('app.color.white'))
    .width('100%')
    .height('100%')
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
    .backgroundImage($r('app.media.fengjing7'))

  }
}