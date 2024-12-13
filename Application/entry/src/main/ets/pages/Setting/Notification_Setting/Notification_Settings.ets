/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmNavBar, HmToggle } from '../../../components'

@Entry
@Component
struct Notification_Settings {
  build() {
    Column() {
      HmNavBar({title:'通知设置'})
      HmCard(){
        HmToggle({leftTitle:'是否开启消息通知',showRightIcon:true,showBorder:true})
        HmToggle({leftTitle:'精选内容推荐',showRightIcon:true,showBorder:false})
      }
    }
    .width('100%')
    .height('100%')

    
  }
}