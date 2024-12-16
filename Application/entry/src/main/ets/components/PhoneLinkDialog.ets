import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud';
import { userInfo_01 as userInfo } from '../enity/userInfo';
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json';
import UserModel from '../models/UserModel';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


@CustomDialog
export struct PhoneLinkDialog {
  controller: CustomDialogController
  @State phone: string = ''
  @State password: string = ''
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

  // 绑定手机号
  async updateUserInfoPhone(userInfo: userInfo, phone: string, verifyCode: string) {
    try {
      await cloud.auth().getCurrentUser().then(user => {
        user?.link({
          kind: 'phone',
          phoneNumber: phone,
          countryCode: '86',
          verifyCode: verifyCode,
        }).catch((e: BusinessError) => {
          console.log("UpdatePersonal.39==>" + JSON.stringify((e)))
        })
      })
      this.userInfo.setPhoneNum(this.phone)
      await this.cloudDataBase?.upsert(userInfo)
    } catch (e) {
      console.log("UpdatePersonal.110==>" + JSON.stringify((e)))
    }
  }

  build() {
    Column() {
      Row() {
        Text('绑定手机号').font({ weight: 'bold', size: 20 }).fontColor($r('app.color.text_primary'))
      }.width('100%').justifyContent(FlexAlign.Center)

      Row() {
        TextInput({ placeholder: '请输入手机号' })
          .onChange((value: string) => {
            this.phone = value

          })
      }.width('100%')
      .margin({ top: 10 })

      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .onChange((value: string) => {
            this.verifyCode = value
          })
          .width('50%')
        Button("获取验证码")
          .onClick(() => {
            this.userInstance.getPhoneVerifyCode(true, this.phone)
          })
          .width('30%')
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10 })

      Button("绑定")
        .onClick(async () => {
          if (this.phone.length === 0) {
            promptAction.showToast({ message: '请输入手机号' })
            return
          }
          if (this.verifyCode.length === 0) {
            promptAction.showToast({ message: '请输入验证码' })
            return
          }
          await this.updateUserInfoPhone(this.userInfo, this.phone, this.verifyCode)
          this.controller.close()
        })

    }
    .width('90%')
    .backgroundColor($r('app.color.background_page'))
  }
}