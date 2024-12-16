import cloud, { VerifyCodeAction } from "@hw-agconnect/cloud";
import { promptAction } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { TOKEN_KEY } from "../constants";

export default class UserModel {
//   懒汉模式
  private static instance: UserModel;
  private constructor() {}

  static getInstance(): UserModel {
    if (!UserModel.instance) {
      UserModel.instance = new UserModel();
    }
    return UserModel.instance;
  }


  /**
   * 获取手机验证码
   */
  getPhoneVerifyCode(isEnable:boolean,mobile:string) {
    isEnable = false;
    cloud.auth().requestVerifyCode({
      action: VerifyCodeAction.REGISTER_LOGIN,
      lang: 'zh_CN',
      sendInterval: 60,
      verifyCodeType: {
        phoneNumber: mobile,
        countryCode: '86',
        kind: "phone"
      }
    }).then(verifyCodeResult => {
      //验证码申请成功
      console.log('hmlog-->', '验证码的失效时间：' + verifyCodeResult.getValidityPeriod())
      let timeout = Math.round(Number(verifyCodeResult.getValidityPeriod()) / 60);
      promptAction.showToast({ message: `已经成功接收到了验证码，请在${timeout}分钟这内输入！` });
      isEnable = true;
    }).catch((err: BusinessError) => {
      //验证码申请失败
      promptAction.showToast({ message: '获取验证码失败！' });
      console.error('hmlog-->', 'get VerifyCode Failed.Err:' + JSON.stringify(err));
      isEnable = true;
    });
  }

  /*获取邮箱验证码*/
  getEmailVerifyCode(isEnable:boolean,email:string) {
    isEnable = false
    cloud.auth().requestVerifyCode({
      action:VerifyCodeAction.REGISTER_LOGIN,
      lang: 'zh_CN',
      sendInterval: 60,
      verifyCodeType:{
        email: email,
        kind: "email"
      }
    }).then(verifyCodeResult => {
      //验证码申请成功
      console.log('hmlog-->', '验证码的失效时间：' + verifyCodeResult.getValidityPeriod())
      let timeout = Math.round(Number(verifyCodeResult.getValidityPeriod()) / 60);
      promptAction.showToast({ message: `已经成功接收到了验证码，请在${timeout}分钟这内输入！` });
      isEnable = true;
    }).catch((err: BusinessError) => {
      //验证码申请失败
      promptAction.showToast({ message: '获取验证码失败！' });
      console.error('hmlog-->', 'get VerifyCode Failed.Err:' + JSON.stringify(err));
      isEnable = true;
    })
  }

  /*注册用户(邮箱+密码+验证码)*/

  /*登录用户(邮箱+密码)*/

  /*登录用户(手机+验证码)*/


  /* 修改密码 */
  getUpdatePasswordEmailVerifyCode(email:string) {
    cloud.auth().requestVerifyCode({
      action:VerifyCodeAction.RESET_PASSWORD,
      lang: 'zh_CN',
      sendInterval: 60,
      verifyCodeType:{
        email: email,
        kind: "email"
      }
    }).then(verifyCodeResult => {
      //验证码申请成功
      console.log('hmlog-->', '验证码的失效时间：' + verifyCodeResult.getValidityPeriod())
      let timeout = Math.round(Number(verifyCodeResult.getValidityPeriod()) / 60);
      promptAction.showToast({ message: `已经成功接收到了验证码，请在${timeout}分钟这内输入！` });

    }).catch((err: BusinessError) => {
      //验证码申请失败
      promptAction.showToast({ message: '获取验证码失败！' });
      console.error('hmlog-->', 'get VerifyCode Failed.Err:' + JSON.stringify(err));

    })
  }
  /*
   * 退出登录
   * */
  logOut(){
    cloud.auth().signOut().then(()=>{
      AppStorage.set(TOKEN_KEY,'')
    })
  }

  /*
   * 账号重认证
   *
   * */
  reAuth(password:string,email:string,verifyCode:string){
    cloud.auth().getCurrentUser().then(user=>{
      if(!user){
        return
      }
      user.userReauthenticate({
        credentialInfo:{
          kind:"email",
          password:password,
          email:email,
          verifyCode:verifyCode
        }
      }).then(()=>{
        AppStorage.set(TOKEN_KEY,user.getToken(true))
        promptAction.showToast({ message: '账号重认证成功！' })
      })
    })
  }
}


