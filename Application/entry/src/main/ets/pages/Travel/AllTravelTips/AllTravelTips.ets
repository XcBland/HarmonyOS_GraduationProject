/**
 * @Auhtor DLY
 *
 */
import { HmNavBar,TravelTips  } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct AllTravelTips {
  // @StorageLink('travelTips') travelTips: AllTravelTips[] = []
  build() {
    List() {
      HmNavBar({title: '旅游攻略'})
      ListItem(){
        TravelTips()
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT),
    })
    .backgroundImage($r('app.media.fengjing16'))

  }
}