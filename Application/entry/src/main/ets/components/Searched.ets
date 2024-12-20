import cloud, { Database } from '@hw-agconnect/cloud'
import { DatabaseCollection } from '@hw-agconnect/cloud/src/main/ets/database/DatabaseCollection'
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { router } from '@kit.ArkUI'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../constants'
import { search_history } from '../enity/search_history'
import dayjs from '@hview/dayjs'

@CustomDialog
@Component
export struct Searched {
  search: CustomDialogController // 弹窗控制器
  @State keyword: string = '' // 搜索关键词
  @State searchList: search_history[] = [] // 搜索历史列表
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<search_history> | null = null

  async aboutToAppear() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB.collection<search_history>(search_history) // 获取云数据库的集合

    await this.query()
  }

  // 查询云数据库
  async query() {
    try {
      this.searchList = await this.cloudDataBase!.query().get()
    } catch (e) {
      console.log("query search history failed: " + e)
    }
  }

  // 新增搜索记录
  async addSearchHistory(keyword: string) {
    let searchHistory = new search_history()
    const user = await cloud.auth().getCurrentUser()
    searchHistory.setId(dayjs(new Date()).format('YYYYMMDDHHmmss') + user?.getUid())
    searchHistory.setSearchinfo(keyword)
    await this.cloudDataBase?.upsert(searchHistory)
    await this.query()
  }

  // 清空搜索记录
  async clearSearchHistory() {
    await this.cloudDataBase?.delete(this.searchList)
    this.searchList = []
  }

  // 搜索历史列表
  @Builder
  searchHistoryList() {
    Grid() {
      ForEach(this.searchList, (item: search_history, index) => {
        GridItem() {
          Row() {
            Text(item.searchinfo)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .onClick(() => {
                router.pushUrl({ url: 'pages/Search/SearchPage', params: { keyword: item.searchinfo } })
                this.search.close()
              })
          }.width(50)

        }.width('auto')
        .margin({
          left: 10,
          right: 10,
        })
      })
    }.width('100%')
    .columnsGap(10)
    .rowsGap(10)
  }

  build() {
    Column() {
      Row() {
        Row() {
          Search({ placeholder: "请输入关键词搜索" })
            .borderRadius({ topLeft: 20, bottomLeft: 20 })
            .onChange((value) => {
              this.keyword = value
            })
            .width('85%')
            .backgroundColor($r('sys.color.comp_background_focus'))
          Divider()
            .vertical(true)// 垂直分割线
            .height(1) // 设置高度为1px


          Text('搜索')
            .fontSize(16)
            .fontColor($r('app.color.text_primary'))
            .onClick(() => {
              if (this.keyword.trim() === '') {
                return
              }
              this.addSearchHistory(this.keyword)
              router.pushUrl({ url: 'pages/Search/SearchPage', params: { keyword: this.keyword } })
              this.search.close()
            })
        }
        .height(40)
        .borderRadius(20)
        .width('85%')
        .backgroundColor($r('sys.color.comp_background_focus'))

        Text('取消')
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .onClick(() => {
            this.search.close()
          })
      }

      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding(10)

      Column() {
        Row() {
          Text('搜索记录')
          if (this.searchList.length !== 0) {
            Image($r('app.media.trash'))
              .fillColor($r('app.color.text_secondary'))
              .width(20)
              .height(20)
              .onClick(() => {
                this.clearSearchHistory()
              })
          }
        }.width('100%')
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)

        if (this.searchList.length > 0) {
          this.searchHistoryList()
        } else {
          Text('暂无搜索记录')
        }


      }.width('100%').height('100%')
    }
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
    .width('100%')
    .backgroundColor($r('app.color.white'))
  }
}