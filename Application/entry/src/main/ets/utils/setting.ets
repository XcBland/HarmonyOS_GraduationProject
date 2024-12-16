import { preferences } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { TOKEN_KEY, USER_SETTING, USER_SETTING_AD } from '../constants'
import { AdvertClass } from '../models'

//默认广告
const defaultAd: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r("app.media.fengjing9")  //默认启动页广告图片(得换)
}


export class UserSettingClass {
  //功能1：实现广告数据的存储
  //功能2：实现用户身份的存储： 令牌 token   jwt

  context: Context

  constructor(context: Context) {
    this.context = context
  }

  //1.获取首选项对象
  getStore() {
    return preferences.getPreferences(this.context, USER_SETTING)
  }

  //2.读取广告首选项
  async getUserAd() {
    const adStore = await this.getStore()
    const adString = await adStore.get(USER_SETTING_AD, JSON.stringify(defaultAd)) as string
    return JSON.parse(adString) as AdvertClass
  }

  //3.存储广告首选项
  async setUserAd(ad: AdvertClass) {
    const adStore = await this.getStore()
    await adStore.put(USER_SETTING_AD, JSON.stringify(ad))
    await adStore.flush()
  }

  //存储用户身份
  async setUserToken(token: string) {
    const adStore = await this.getStore()
    await adStore.put(TOKEN_KEY, token)
    await adStore.flush()
  }

  //读取用户身份
  async getUserToken(): Promise<string> {
    const adStore = await this.getStore()
    return await adStore.get(TOKEN_KEY, "") as string
  }
}