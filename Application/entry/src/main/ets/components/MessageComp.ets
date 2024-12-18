import { MessageItem } from "../enity/MessageItem"


@Component
export default struct MessageComp {

  @Prop item:MessageItem
  build() {
    Row() {
      //头像
      Image(this.item.avatar)
        .height(40)
        .margin({right:10,left:10,top:5})
      Row(){
        Text(this.item.content)
      }
      .width('auto')
      .opacity(0.8)
      .backgroundColor('#f5f5f5')
      .margin(this.item.self?{left:30}:{right:30})
      .padding(10)
      .borderRadius(10)
      .justifyContent(this.item.self?FlexAlign.End:FlexAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .direction(this.item.self?Direction.Rtl:Direction.Ltr)


  }
}