import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud';
import { userInfo_01 as userInfo } from '../enity/userInfo';
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json';
import UserModel from '../models/UserModel';
import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@CustomDialog
export struct PhoneUpdateDialog {
  phoneUpdateDialog: CustomDialogController
  @State phoneNumber: string = ''
  @State verifyCode: string = ''
  @StorageLink('local_userInfo') userInfo: userInfo = new userInfo()
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<userInfo> | undefined = undefined

  async aboutToAppear() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB?.collection<userInfo>(userInfo)
  }

  userInstance: UserModel = UserModel.getInstance()

  // 修改手机号
  async updatePhone(userInfo:userInfo,phone:string,verifyCode:string) {
    try {
      await cloud.auth().getCurrentUser().then((user) => {
        user?.updatePhone({
          countryCode: '86',
          phoneNumber: phone,
          verifyCode: verifyCode,
          lang: "zh_CN"
        })
      }).catch((e: BusinessError) => {
        console.error('updatePhone41 error:' + e.message)
      })
      this.userInfo.setPhoneNum(this.phoneNumber)
      await this.cloudDataBase?.upsert(userInfo)
      promptAction.showToast({ message: '修改手机号成功,请重新登录' })

      this.phoneUpdateDialog.close()
    } catch (e) {
      console.error('updatePhone44 error:' + e.message)
      this.phoneUpdateDialog.close()
      promptAction.showToast({ message: '修改手机号失败,请重新尝试' })
    } finally {
      this.phoneUpdateDialog.close()
    }
  }

  build() {
    Column() {
      Row() {
        Text('修改手机号')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.width('100%').justifyContent(FlexAlign.Center).margin({top:30})
      Row(){
        TextInput({placeholder:'请输入新的手机号'})
          .onChange((value) => {
            this.phoneNumber = value
          })
          .width('70%')
          .backgroundColor($r('app.color.white')).height(40)
      }.width('70%').height(40)
      .margin(10)
      .borderRadius(0)
      .borderWidth(1)
      Row() {
        TextInput({placeholder: '请输入验证码'})
         .width('70%')
         .backgroundColor($r('app.color.white'))
          .onChange((value) => {
            this.verifyCode = value
          })
          .height(40)
        Text('获取验证码')
          .fontSize(12)
          .onClick(()=>{
            this.userInstance.getPhoneVerifyCode(true,this.phoneNumber)
          }).borderWidth({left:1})
          .width('30%')
          .padding(5)
          .height(40)
      }.width('70%').margin(10).borderWidth(1)
      Button('修改手机号')
        .width('50%')
        .margin(10)
        .type(ButtonType.Normal)
        .backgroundColor($r('app.color.white'))
        .borderRadius(10)
        .borderWidth(1)
        .onClick(async ()=>{
          await this.updatePhone(this.userInfo,this.phoneNumber,this.verifyCode)
          this.userInstance.logOut()
          router.replaceUrl({url:'pages/Login/LoginIndex'})
        })
        .fontColor($r('app.color.text_primary'))
        .align(Alignment.Center)
    }
    .width('90%')
    .borderRadius(20)
    .backgroundColor($r('app.color.white'))
  }
}