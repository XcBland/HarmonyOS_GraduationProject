/**
 * @Auhtor DLY
 *
 */
import { HmNavBar } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct Favorite {
  // TODO: 收藏列表
  @State favoriteList: string[] = []

  build() {
    Column() {
      HmNavBar({ title: '我的收藏' })
      if (this.favoriteList.length === 0) {
        Text('暂无收藏')
      } else {
        List() {
          ListItem() {
            Column() {
              ForEach(this.favoriteList, (item: string, index) => {
                Text(item)
              })
            }
          }
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding({ top: AppStorage.get<number>(APP_TOP_HEIGHT), bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT) })
    .backgroundImage($r('app.media.fengjing7'))

  }
}