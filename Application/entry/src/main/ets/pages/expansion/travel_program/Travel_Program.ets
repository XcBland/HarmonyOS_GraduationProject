/**
 * @Auhtor DLY
 *
 */
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct TravelProgram {
  build() {
    Column() {
    }
    .width('100%')
    .height('100%')
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}