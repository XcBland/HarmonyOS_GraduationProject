/**
 * @Auhtor DLY
 *
 */
import { HmNavBar } from '../../../components'

@Entry
@Component
struct Order {
  build() {
    Column() {
      HmNavBar({title:'酒店订单'})
    }
    .width('100%')
    .height('100%')


  }
}