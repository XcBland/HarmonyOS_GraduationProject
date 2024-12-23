/**
 * @Auhtor DLY
 *
 */
import { HmNavBar } from '../../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'

@Entry
@Component
struct Order {
  // TODO:酒店订单
  @State orderList: string[] = []

  build() {
    Column() {
      HmNavBar({ title: '酒店订单' })
      if (this.orderList.length === 0) {
        Text('暂无订单')
          .textAlign(TextAlign.Center)
      } else {
        List() {
          ListItem() {
            Column() {
              ForEach(this.orderList, (item: string, index) => {
                Text(item)
              })
            }
          }
        }
      }

    }
    .width('100%')
    .height('100%')
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
    .backgroundImage($r('app.media.fengjing7'))

  }
}