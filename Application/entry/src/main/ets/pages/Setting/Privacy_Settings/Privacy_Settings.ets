/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmNavBar, HmToggle } from '../../../components'

@Entry
@Component
struct Privacy_Settings {
  build() {
    Column() {
      HmNavBar({title:'隐私设置'})
      HmCard(){
        HmToggle({leftTitle:'允许获取位置信息',showRightIcon:true})
        HmToggle({leftTitle:'允许访问相册',showRightIcon:true})
        HmToggle({leftTitle:'允许访问麦克风',showRightIcon:true})
        HmToggle({leftTitle:'允许用手机号搜索到我',showRightIcon:true,showBorder:false})
      }
    }
    .width('100%')
    .height('100%')


  }
}