/**
 * @Auhtor DLY
 *
 */
import { HmNavBar } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct Favorite {
  build() {
    Column() {
      HmNavBar({ title: '我的收藏' })
    }
    .width('100%')
    .height('100%')
    .padding({ top: AppStorage.get<number>(APP_TOP_HEIGHT), bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT) })
    .backgroundImage($r('app.media.fengjing7'))

  }
}