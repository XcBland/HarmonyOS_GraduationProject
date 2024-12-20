/**
 * @Auhtor DLY
 *
 */
import { HotelComp } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct AllHotels {
  build() {
    List() {
      ListItem(){
        HotelComp()
      }
    }
    .width('100%')
    .height('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
    .backgroundImage($r('app.media.fengjing19'))
    .backgroundImageSize(ImageSize.Auto)

  }
}