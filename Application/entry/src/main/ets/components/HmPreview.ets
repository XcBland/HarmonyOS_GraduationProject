@CustomDialog
@Component
export struct HmPreview {
  urls: string[] = [] // 图片预览列表
  controller: CustomDialogController
  selectIndex: number = -1 // 选中的图片索引

  build() {
    Column() {
      Row(){
        Swiper(){
          ForEach(this.urls, (url:string, index:number) => {
            Row(){
              Image(url)
                .width('100%')
                .objectFit(ImageFit.Cover)
            }
            .height('100%')
          })
        }
        .indicator(false)
        .loop(false)
        .index(this.selectIndex)
      }
      .backgroundColor($r('app.color.black'))
      .onClick(()=>{
        this.controller.close()
      })
    }
    .height('100%')
  }
}