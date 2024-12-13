@Component
struct HmCard {
  @BuilderParam
  HmCardFn: () => void

  build() {
    Column() {
      Column() {
        if (this.HmCardFn) {
          this.HmCardFn()
        }
      }
      .width('100%')
      .backgroundColor($r('app.color.white'))
      .borderRadius(10)
      .padding({ left: 15, right: 15 })
    }
    .width('100%')
    .padding(15)
  }
}

export { HmCard };