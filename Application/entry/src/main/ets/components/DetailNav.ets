import { router } from '@kit.ArkUI'
import { HmConfirm } from '.'

@Preview
@Component
export struct HmDetailNav {
  @State title: string = "测试"
  showBackIcon: boolean = true

  build() {
    Stack({ alignContent: Alignment.TopStart }) {

      Row() {
        if (this.title) {
          Text(this.title)
            .fontColor($r('app.color.text_primary'))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .alignSelf(ItemAlign.Center)
            .align(Alignment.Center)
            .margin({left:150})
            .layoutWeight(1)
        }

        Row(){
          Image($r('app.media.trash'))
            .width(34)
            .height(34)
            .onClick(() => {
              AlertDialog.show({message:"确定删除吗？"})
            })
          Image($r('app.media.write'))
            .width(34)
            .height(34)
        }
      }

      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height("100%")



      if (this.showBackIcon === true) {
        Row() {
          Image($r('app.media.ic_btn_nav_back'))
            .width(44)
            .height(44)
        }
        .alignItems(VerticalAlign.Center)
        .width(44)
        .onClick(() => {
          router.back()
        })
      }


    }
    .backgroundColor($r('app.color.white'))
    .width('100%')
    .height(50)
    .padding(10)
  }
}