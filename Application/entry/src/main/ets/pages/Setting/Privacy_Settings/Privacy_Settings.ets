/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmNavBar, HmToggle } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct Privacy_Settings {
  @State isOn: boolean = true
  build() {
    Column() {
      HmNavBar({title:'隐私设置'})
      HmCard(){
        HmToggle({leftTitle:'允许获取位置信息',showRightIcon:true,isOn:this.isOn})
        HmToggle({leftTitle:'允许访问相册',showRightIcon:true,isOn:this.isOn})
        HmToggle({leftTitle:'允许访问麦克风',showRightIcon:true,isOn:this.isOn})
        HmToggle({leftTitle:'允许用手机号搜索到我',showRightIcon:true,showBorder:false,isOn:this.isOn})
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