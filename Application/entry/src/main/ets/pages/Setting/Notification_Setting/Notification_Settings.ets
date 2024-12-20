/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmNavBar, HmToggle } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct Notification_Settings {
  @State isOn: boolean = true
  @State isOn2: boolean = true

  build() {
    Column() {
      HmNavBar({ title: '通知设置' })
      HmCard() {
        HmToggle({
          leftTitle: '是否开启消息通知',
          showRightIcon: true,
          showBorder: true,
          isOn: (this.isOn),
          onRightClick: () => {
            this.isOn = !this.isOn
          }
        })
        HmToggle({
          leftTitle: '精选内容推荐',
          showRightIcon: true,
          showBorder: false,
          isOn: this.isOn2,
          onRightClick: () => {
            this.isOn2 = !this.isOn2
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
    .backgroundImage($r('app.media.fengjing7'))
  }
}