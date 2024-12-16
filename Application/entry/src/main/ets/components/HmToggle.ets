@Component
struct HmToggle {
  leftTitle: string = "" //左边显示的内容
  @Prop
  rightContent: string = "" //右边显示的内容
  showRightIcon: boolean = true //右边是否显示图片
  showBorder: boolean = true //是否显示底部的线条
  onRightClick: () => void = () => {
  } //执行的事件
  @Prop isOn: boolean = false //右边的开关是否打开

  build() {
    Row() {
      Text(this.leftTitle)
        .fontWeight(400)
        .fontColor($r("app.color.text_primary"))
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .maxLines(1)
        .layoutWeight(1)

      Row() {
        if (this.rightContent) {
          Text(this.rightContent)
            .fontColor($r("app.color.text_secondary"))
            .fontWeight(400)
            .fontSize(14)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .constraintSize({ maxWidth: 150, maxHeight: 20 }) //设置右边内容的最大宽度和高度
        }
        if (this.showRightIcon) {
          Toggle({type:ToggleType.Switch,isOn:this.isOn})
            .selectedColor('#007DFF')
            .switchPointColor('#FFFFFF')
            .onChange((isOn: boolean) => {
              this.isOn = isOn
            })


          // TODO: 权限控制
        }
      }.onClick(() => {
        this.onRightClick()
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(60)
    .border({
      width: {
        bottom: this.showBorder ? 1 : 0
      },
      color: $r("app.color.background_divider")
    })
  }
}

export { HmToggle }