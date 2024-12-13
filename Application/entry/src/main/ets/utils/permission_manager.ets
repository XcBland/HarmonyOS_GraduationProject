import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit'

class PermissionManager {
  //检查是否有权限
  checkPermissions(permissions: Permissions[]) {
    const manager = abilityAccessCtrl.createAtManager()
    //获取应用信息
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const tokenId = appInfo.appInfo.accessTokenId
    //校验每个权限,并返回校验的类型
    const authResults = permissions.map((per) => {
      return manager.checkAccessTokenSync(tokenId, per)
    })
    //处理授权结果
    return authResults.every(status => status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
  }

  //动态申请权限
  async requestPermissions(permissions: Permissions[]): Promise<boolean> {
    const manager = abilityAccessCtrl.createAtManager()
    const result = await manager.requestPermissionsFromUser(getContext(), permissions)
    const isAuth = result.authResults.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    //Promise.resolve() 成功的返回
    //Promise.reject() 失败的返回，await后续的代码，不会执行，会被catch捕获
    return isAuth === true ? Promise.resolve(true) : Promise.reject(false)
  }

  //打开系统管理页让用户自己去设置
  openPermissionSettingsPage() {
    //用户不同意:跳转到一个能够设置权限的应用中
    const context = getContext() as common.UIAbilityContext
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    context.startAbility({
      bundleName: "com.huawei.hmos.settings", //设置也的包名
      abilityName: "com.huawei.hmos.settings.MainAbility",
      uri: "application_info_entry", //参数名
      parameters: {
        pushParams: appInfo.name
      }
    })
  }
}

export const permissionManager = new PermissionManager()

