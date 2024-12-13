/**
 * @Auhtor DLY
 *
 */
import { HmNavBar } from '../../../components'
import { HmCard } from '../../../components/HmCard'
import { HmCardItem } from '../../../components/HmCardItem'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct ExpansionBar {
  build() {
    Column() {
      HmNavBar({title:'拓展内容'})
      HmCard(){
        HmCardItem({leftTitle:'我的订单', rightContent:'',showRightIcon:true,onRightClick:()=>{
          router.pushUrl({url:'pages/expansion/order/Order'})
        }})
        HmCardItem({leftTitle:'我的收藏', rightContent:'',showRightIcon:true,onRightClick:()=>{
          router.pushUrl({url:'pages/expansion/favorite/Favorite'})
        }})
        HmCardItem({leftTitle:'我的旅游计划', rightContent:'',showRightIcon:true,onRightClick:()=>{
          router.pushUrl({url:'pages/expansion/travel_program/Travel_Program'})
        }})
        HmCardItem({leftTitle:'红包卡券', rightContent:'',showRightIcon:true,onRightClick:()=>{
          router.pushUrl({url:'pages/expansion/card_coupon/Card_Coupon'})
        }})
        HmCardItem({leftTitle:'浏览记录', rightContent:'',showRightIcon:true,onRightClick:()=>{
          router.pushUrl({url:'pages/expansion/browsing_history/Browsing_History'})
        },showBorder:false})
      }
    }
    .backgroundImage($r('app.media.fengjing7'))
    .width('100%')
    .height('100%')


  }
}