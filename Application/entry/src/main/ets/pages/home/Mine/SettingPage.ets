/**
 * @Auhtor DLY
 *
 */
import { RecommendDialog, HmCard, HmCardItem, HmConfirm, HmNavBar } from '../../../components'
import { router } from '@kit.ArkUI'
import cloud from '@hw-agconnect/cloud'
import { BusinessError } from '@kit.BasicServicesKit'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT, TOKEN_KEY } from '../../../constants'
import { UserSettingClass } from '../../../utils'

@Entry
@Component
struct SettingPage {

  // 推荐好友弹窗
  recommendFriends:CustomDialogController = new CustomDialogController({
    builder:RecommendDialog(),
    autoCancel:true,
    customStyle:true,
    alignment:DialogAlignment.Bottom
  })

  // 退出弹窗
  confimDialog: CustomDialogController = new CustomDialogController({
    builder: HmConfirm({
      message: '确定要退出吗？',
      buttonList: [
        { title: "取消", fontColor: $r('app.color.text_secondary') },
        {
          title: "确定", fontColor: $r('app.color.primary'), action: () => {
          //   实现退出功能
          this.logout()
        }
        }
      ]
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: false
  })

  // 退出功能
  async logout() {
    await cloud.auth().signOut()
      .then(() => {
        // 清空Token
        AppStorage.set<string>(TOKEN_KEY, '')
        new UserSettingClass(getContext(this)).setUserToken('')
        // 跳转页面
        router.replaceUrl({ url: 'pages/Login/LoginIndex' })
      })
      .catch((error: BusinessError) => {
        console.error('SettingPage44:' + error.message)
      })
  }

  build() {
    Column() {
      HmNavBar({ title: '设置' })
      HmCard() {
        HmCardItem({
          leftTitle: '账号管理',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/Account_Management/Account_Management' })
          }
        })
        HmCardItem({
          leftTitle: '通知设置',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/Notification_Setting/Notification_Settings' })
          }
        })
        HmCardItem({
          leftTitle: '隐私设置',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/Privacy_Settings/Privacy_Settings' })
          },
          showBorder: false
        })
      }

      HmCard() {
        HmCardItem({
          leftTitle: '常见问题',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/Common_Problems/Common_Problems' })
          }
        })
        HmCardItem({
          leftTitle: '清理缓存',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/ClearCache/ClearCache' })
          },
          showBorder: false
        })
      }

      HmCard() {
        HmCardItem({
          leftTitle: '推荐好友',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            this.recommendFriends.open()
          }
        })
        HmCardItem({
          leftTitle: '版本信息',
          rightContent: '',
          showRightIcon: true,
          onRightClick: () => {
            router.pushUrl({ url: 'pages/Setting/release/Release' })
          },
          showBorder: false
        })
      }

      Row() {
        Button('退出', { type: ButtonType.Normal })
          .backgroundColor($r('app.color.white'))
          .borderRadius(10)
          .margin({ top: 20 })
          .onClick(() => {
            this.confimDialog.open()
          })
          .fontColor($r('app.color.text_primary'))
          .width('90%')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }

    .backgroundImage($r('app.media.fengjing7'))
    .width('100%')
    .height('100%')
    .padding({
      top:AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom:AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}