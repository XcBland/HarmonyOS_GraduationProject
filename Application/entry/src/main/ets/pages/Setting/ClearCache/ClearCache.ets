
import { fileIo as fs } from "@kit.CoreFileKit"
import { HmNavBar } from '../../../components'
import { APP_TOP_HEIGHT } from '../../../constants'


@Entry
@Component
struct ClearCache {
  @State
  files: string[] = []

  onPageShow(): void {
    // 获取沙箱缓存
    const cacheDir = getContext().cacheDir
    this.files = [...this.files, ...this.getFilePath(cacheDir) || []]
    const filesDir = getContext().filesDir
    this.files = [...this.files, ...this.getFilePath(filesDir) || []]
    const preferencesDir = getContext().preferencesDir
    this.files = [...this.files, ...this.getFilePath(preferencesDir) || []]

    // 应用下的
    const application = getContext().getApplicationContext()
    const cacheDirApp = application.cacheDir
    this.files = [...this.files, ...this.getFilePath(cacheDirApp) || []]
    const filesDirApp = application.filesDir
    this.files = [...this.files, ...this.getFilePath(filesDirApp) || []]
    const preferencesDirApp = application.preferencesDir
    this.files = [...this.files, ...this.getFilePath(preferencesDirApp) || []]
  }

  // 递归问价:
  getFilePath(path: string): string[] {
    let files: string [] = []
    fs.listFileSync(path, { recursion: true }).forEach((item: string) => {

      if (fs.accessSync(path + item)) {
        // 判断是否为文件夹
        if (fs.statSync(path + item).isDirectory()) {
          this.getFilePath(path + item)
        } else {
          files.push(path + item)
        }
      }
    })
    return files
  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r("app.color.white"))
      HmNavBar({ title: '清理缓存' })
      Scroll() {
        Column({ space: 10 }) {
          ForEach(this.files, (str: string) => {
            Text(str)
              .width('100%')
              .textAlign(TextAlign.End)
              .fontColor($r('app.color.text_secondary'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .ellipsisMode(EllipsisMode.START)
          })
        }
        .padding({ left: 10, right: 10 })
      }
      .height('100%')
      .margin({ bottom: 120 })
      .backgroundColor($r('app.color.white'))

      Button('清理缓存')
        .width('50%')
        .backgroundColor($r('app.color.primary'))
        .position({ y: '100%', x: '25%' })
        .translate({ y: -50 })
        .onClick(() => {
          this.files.forEach((item: string) => {
            fs.unlinkSync(item)
          })
          this.files = []
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.white'))
  }
}