import { abilityAccessCtrl, AbilityConstant, PermissionRequestResult, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { font, window } from '@kit.ArkUI';
import { initialize } from '@hw-agconnect/hmcore';
import json from '../../resources/rawfile/app-schema.json';
import cloud from '@hw-agconnect/cloud';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../constants';
import { UserSettingClass } from '../utils';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {

    try {
      initialize(this.context, json);
      console.info('hmlog-->','AGConnectSuccessed!')
    } catch (e) {
      console.error('hmlog-->','AGConnectError', JSON.stringify(e))
    }
    let AtManager = abilityAccessCtrl.createAtManager();
    AtManager.requestPermissionsFromUser(this.context, ['ohos.permission.READ_MEDIA', 'ohos.permission.MEDIA_LOCATION'])
      .then((data: PermissionRequestResult) => {
        hilog.info(0x0000, 'testTag', '%{public}s', 'request permissions from user success' + data);
      })
      .catch((err: Object) => {
        hilog.error(0x0000, 'testTag', 'Failed to request permissions from user. Cause: %{public}s',
          JSON.stringify(err) ?? '');
      });
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    // 实现全屏效果
    windowStage.getMainWindowSync().setWindowLayoutFullScreen(true)
    // 获取头部高度
    const topHeight =
      px2vp(windowStage.getMainWindowSync().getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
    // 获取底部高度
    const bottomHeight =
      px2vp(windowStage.getMainWindowSync().getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)
    AppStorage.setOrCreate<number>(APP_TOP_HEIGHT, topHeight)
    AppStorage.setOrCreate<number>(APP_BOTTOM_HEIGHT, bottomHeight)
    //2.存储首选项
    const userSetting = new UserSettingClass(this.context)
    const result = await userSetting.getUserAd()
    if(result.showAd){
      windowStage.loadContent('pages/Start/StartAd');
    }else{
      const token = await cloud.auth().getCurrentUser().then((user) => {
        return user?.getToken(true)
      })
      if(token){
        windowStage.loadContent('pages/home/Index');
      }else{
        windowStage.loadContent('pages/Login/LoginIndex');
      }
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
