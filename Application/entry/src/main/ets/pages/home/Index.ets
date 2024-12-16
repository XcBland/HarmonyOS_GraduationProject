import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants'
import { TabIndexClass } from '../../models/tabIndex'
import { Add } from './Add/Add'
import { Home } from './Home/Home'
import { Hotel } from './Hotel/Hotel'
import { Mine } from './Mine/Mine'
import { Safari } from './Safari/Safari'
import { userInfo_01 as userInfo } from '../../enity/userInfo';
import schema from '../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'

/**
 * @Auhtor DLY
 *
 */
@Entry
@Component
struct Index {
  /*  // 登出
    async logOut(){
      await cloud.auth().signOut()
        .then(() => {
          AppStorage.set(TOKEN_KEY,'')
          router.replaceUrl({ url: 'pages/Login/LoginIndex' })
        })
    }*/
  @State tabsData: TabIndexClass[] = [
    { name: 'home', icon: $r('app.media.home_fill') },
    { name: 'safari', icon: $r('app.media.ie') },
    { name: 'add', icon: $r('app.media.jia') },
    { name: 'hotel', icon: $r('app.media.hotel') },
    { name: 'mine', icon: $r('app.media.Leftbar_mine_selected') }
  ]
  @State currentTab: string = 'home'
  @StorageLink('local_userInfo')data:userInfo = new userInfo()
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase:DatabaseCollection<userInfo>|undefined = undefined
  @Builder
  getTabBar(item:TabIndexClass){
    Column(){
      Image(item.icon)
        .width(30)
        .height(30)
        .margin({ top: 5, bottom: 5 })
        .borderRadius(12)
        .objectFit(ImageFit.Cover)
        .fillColor(item.name === this.currentTab ? "#ff4c3efd" : $r('app.color.text_secondary'))
    }
  }

  // 获取Auth的Uid，根据Uid对应判断数据库里的内容
  async getUid(){
    const uid = await cloud.auth().getCurrentUser().then(user => {
      return user?.getUid()
    })
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB?.collection<userInfo>(userInfo)
    const data = await this.cloudDataBase?.query().equalTo('id',uid).get()
    if(data.length > 0){
      this.data = data[0]
    }
  }

  aboutToAppear(){
    this.getUid()
  }

  build() {
    Tabs({barPosition:BarPosition.End}){
      ForEach(this.tabsData,(item:TabIndexClass,index:number)=>{
        TabContent(){
          if(item.name === 'home'){
            Home()
          }else if(item.name === 'safari'){
            Safari()
          }else if(item.name === 'add'){
            Add()
          }else if(item.name ==='hotel'){
            Hotel()
          }else if(item.name === 'mine'){
            Mine()
          }
        }
        .tabBar(this.getTabBar(item))
      })
    }
    .onChange((index: number) => {
      this.currentTab = this.tabsData[index].name
    })
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })
    .width('100%')
    .height('100%')

  }
}