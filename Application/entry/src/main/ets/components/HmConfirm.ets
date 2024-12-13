import { APP_TOP_HEIGHT } from "../constants"

@Preview
@CustomDialog
export struct HmConfirm {
  customController: CustomDialogController = new CustomDialogController({
    builder: ''
  })
  message: string = "弹框的提示内容"
  buttonList: HmConfirmButton[] = [
    { title: "确定", fontSize: 14, fontColor: $r('app.color.text_primary') }
  ] // 按钮列表

  build() {
    Row() {
      Column() {

        Row() {
          Text(this.message)
        }
        .width('100%')
        .height(88)
        .justifyContent(FlexAlign.Center)
        .border({ width: { bottom: 1 }, color: $r('app.color.background_divider') })

        Row() {
          ForEach(this.buttonList, (item: HmConfirmButton, index) => {
            Text(item.title)
              .fontSize(item.fontSize)
              .fontColor(item.fontColor || $r('app.color.text_secondary'))
              .textAlign(TextAlign.Center)
              .height("100%")
              .onClick(() => {
                if (item.action) {
                  item.action()
                }
                this.customController.close()
              })
              .layoutWeight(1)
              .border({
                width: { right: (this.buttonList.length > 1 && index === this.buttonList.length - 1) ? 0 : 1 },
                color: $r('app.color.background_divider')
              })
          })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height(48)
      }
    }
    .width(300)
    .borderRadius(12)
    .backgroundColor($r('app.color.white'))
  }
}

// 表达按钮的信息(样式/文字)
class HmConfirmButton {
  title: string = "" // 按钮文字
  fontSize?: number = 14 // 按钮文字大小
  fontColor?: ResourceStr = $r('app.color.text_primary') // 按钮文字颜色
  action?: () => void = () => {
  } // 按钮点击事件
}