/**
 * @Auhtor DLY
 *
 */
import { HmNavBar,TravelNotes } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'
import { travel_notes } from '../../../enity/travel_notes'

@Entry
@Component
struct AllTravelNotes {
  // @StorageLink('travelNotes') travelNotes: travel_notes[] = []
  build() {
    List() {
      HmNavBar({title: '旅游游记'})
      ListItem(){
        TravelNotes()
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT),
    })
    .backgroundImage($r('app.media.fengjing18'))

  }
}