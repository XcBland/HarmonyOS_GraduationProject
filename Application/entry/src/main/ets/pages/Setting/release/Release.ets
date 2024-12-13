/**
 * @Auhtor DLY
 *
 */
import { HmCard, HmCardItem, HmNavBar } from '../../../components'

@Entry
@Component
struct Release {
  // TODO: 页面数据
  build() {
    Column() {
      HmNavBar({title:'关于我们'})
      Column(){
        Image($r('app.media.leto'))
          .width(150)
          .aspectRatio(2)
          .margin({top: 20})
        Text('乐途')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({top: 20})

        Text('版本：1.0.0')
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .margin({top: 20})

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .margin({top: 20})

      HmCard(){
        HmCardItem({leftTitle:"隐私协议",showRightIcon:true,onRightClick:()=>{}})
        HmCardItem({leftTitle:"用户协议",showRightIcon:true,onRightClick:()=>{}})
      }
      Blank()
      Column(){
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

    
  }
}