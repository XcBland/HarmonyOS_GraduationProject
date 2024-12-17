import cloud, { AuthUser, Database, DatabaseCollection, Storage } from '@hw-agconnect/cloud';
import { HmNavBar } from '../../../components'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { userInfo_01 as userInfo } from '../../../enity/userInfo';
import {AgUser } from '../../../enity/AgUser'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import dayjs from '@hview/dayjs';


@Entry
@Component
struct MoreMine {
  @State photoUrl: string = ''; // 用户头像;
  @State uploadingText: string = ''; //上传图片时过程中的进度文本显示
  @State uploading:boolean=false //标记上传图片是否开始
  @State isAvatorTitle:boolean=true //是否显示图片
  @State isLoaded: boolean = false; //标记页面是否加载完成
  @State displayName: string = ''; //用户昵称
  @StorageLink('user') currentUser: AgUser | undefined = AppStorage.get<AgUser>('user')
  @StorageLink('local_userInfo') userInfo: userInfo = new userInfo()

  @State resultArray: userInfo[]=[]
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';

  cloudDataBase:DatabaseCollection<userInfo>|undefined = undefined
  authUser:AuthUser|null =null
  storage: Storage = cloud.storage()
  cloudPath: string | undefined = '';

  async aboutToAppear(){
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase = this.cloudDB?.collection<userInfo>(userInfo)
    await this.query()
  }
  // 上传头像
  async selectAndUploadAvator(){
    //1.相册中选择图片
    let selectOptions =new photoAccessHelper.PhotoSelectOptions()
    selectOptions.MIMEType =photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    selectOptions.maxSelectNumber=1
    let photoViewPicker=await new photoAccessHelper.PhotoViewPicker().select(selectOptions)
    let localPath=photoViewPicker.photoUris[0]
    if(localPath==undefined){
      promptAction.showToast({message:'请选择要上传的图片'})
    }
    this.uploading=true
    this.isAvatorTitle=!this.uploading
    //2.上传图片到云存储
    let extName=localPath.split('.')[1]
    let cloudPath ='myProjectImage/myAvcator/'+this.authUser?.getUid()+'.'+extName
    let transResult=  await cloud.storage().upload({
      localPath:localPath,
      cloudPath:cloudPath,
      onUploadProgress:event=>{
        const  percent =Math.floor(100*event.loaded/event.total)
        this.uploadingText=`${percent}%`
      }
    })
    if(transResult.bytesTransferred!==transResult.totalByteCount){
      promptAction.showToast({message:'上传失败'})
    }

    //3.获取AGC云存储图片的网络地址
    let url=await cloud.storage().getDownloadURL(cloudPath)
    AppStorage.set('user',this.photoUrl)
    //防止缓存  通过刷新时间戳引动UI刷新
    this.photoUrl=`${url}&ts=${new Date().getTime()}`
    this.userInfo.setPhotoUrl(this.photoUrl)
    if(transResult.bytesTransferred===transResult.totalByteCount){
      await this.saveUser()
      promptAction.showToast({message:'上传成功'})

    }
  }

  //保存用户信息
  async saveUser(){
    try{
      await this.authUser!.updateProfile({
        displayName:this.userInfo.getDisplayName(),
        photoUrl:this.userInfo.getPhotoUrl(),
      })
    }catch(e){
      console.log("UpdatePersonal.65==>"+JSON.stringify((e)))
    }
  }

  //查询用户信息
  async query(){
    try{
      this.resultArray = await this.cloudDataBase!.query().get()
      promptAction.showToast({message:JSON.parse(JSON.stringify(this.resultArray))})
    }catch(err){
      console.log("UpdatePersonal.100==>"+JSON.stringify((err)))
    }
  }

  // 更新用户信息
  async updateUserInfo(userInfo:userInfo){
    try{
      await this.cloudDataBase?.upsert(userInfo)
    }catch(e){
      console.log("UpdatePersonal.110==>"+JSON.stringify((e)))
    }
  }

  async onPageShow(){
    await cloud.auth().getCurrentUser().then(async user=>{
      this.authUser=user
      this.displayName=user!.getDisplayName()
      this.photoUrl=user!.getPhotoUrl()
      // this.userInfo=await userModel.GetUserInfoByUid(user!.getUid())
      this.isLoaded=true
      // 测试
    })
  }

  build() {
    Column() {
      HmNavBar({title:'编辑资料'})
      Column(){
        Row({space:20}){
          Text('头 像')
            .fontSize(16)
            .fontColor($r('app.color.white'))
            .fontFamily('single')
            .margin({left:10})
          Image(this.userInfo.getPhotoUrl()===''? $r('app.media.user_dark'):this.userInfo.getPhotoUrl())
            .width(100)
            .height(100)
            .borderRadius(70)
            .alt( $r('app.media.user_dark'))
            .margin({left:80})
            .padding(10)
            .onClick(async ()=>{
              try{
                await this.selectAndUploadAvator(); //选择并上传头像
                this.uploading=false
                this.isAvatorTitle=!this.uploading

              } catch (e) {
                this.uploading=false
                this.isAvatorTitle=!this.uploading
                console.log("UpdatePersonal.131==>"+JSON.stringify((e)))
              }
            })
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .borderWidth({bottom:1})

        Row({space:10}){
          Text('用户名:')
            .fontColor($r('app.color.white')).fontFamily('single')
            .margin({left:10})

          TextInput({text:this.userInfo.getDisplayName()})
            .width('60%')
            .onChange((value)=>{
              this.userInfo.setDisplayName(value)
            })
            .fontColor($r('app.color.white'))
            .fontFamily('single')
        }.width('100%')

        Row(){
          Text(this.userInfo.getEmail() ? `邮箱：${this.userInfo.getEmail()}`:'邮箱尚未绑定')
            .fontColor($r('app.color.white')).fontFamily('single')
            .margin({left:10})
        }.width('100%').margin({top:10})
        Row(){
          Text(this.userInfo.getPhoneNum() ? `手机号：${this.userInfo.getPhoneNum()}`:'手机号尚未绑定')
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.white')).fontFamily('single')
            .margin({left:10})
        }
        .margin({top:20})
        .width('100%')
        //Text(Number(this.userInfo.getGender()) === 0 ? `性别：女`:'性别：男')
        Row({space:10}){
          Text('性 别:')
            .fontColor($r('app.color.white')).fontFamily('single')
            .margin({left:10})
          TextInput({text:this.userInfo.getGender()})
            .width('60%')
            .onChange((value:string)=>{
              this.userInfo.setGender(value)
            })
            .fontColor($r('app.color.white'))
            .fontFamily('single')
        }.width('100%').margin({top:10})
        //Text(`生日：${this.userInfo.getBirthday()}`)
        Row({space:10}){
          Text('生 日:')
            .fontColor($r('app.color.white')).fontFamily('single')
            .margin({left:10})
          // TextInput({text:this.userInfo.getBirthday()})
          //   .width('60%')
          //   .onChange((value)=>{
          //     this.userInfo.setBirthday(value)
          //   })
          //   .fontColor($r('app.color.white'))
          //   .fontFamily('single')
          Text(this.userInfo.getBirthday())
            .fontColor($r('app.color.white'))
            .fontFamily('single')
            .margin({left:10})
            .width('60%')
            .onClick(()=>{
              DatePickerDialog.show({
                showTime: true, //是否显示时间
                useMilitaryTime: true,   //是否24小时制
                alignment:DialogAlignment.Bottom, //对齐方式
                onDateAccept: (date:Date)=>{
                  this.userInfo.setBirthday(dayjs(date).format('YYYY-MM-DD'))
                }, //日期选择回调
                dateTimeOptions:{
                  year: new Date().getFullYear().toString(),
                  month: (new Date().getMonth() + 1).toString().padStart(2),
                  day: new Date().getDate().toString().padStart(2)
                }
              })
            })

        }.width('100%').margin({top:20})
        //Text(this.userInfo.getSignature() ? `个性签名：${this.userInfo.getSignature()}`:'未设置个性签名')
        Column({space:10}){
          Text('个性签名:')
            .fontColor($r('app.color.white')).fontFamily('single')
            .margin({left:20})
            .textAlign(TextAlign.Start)
            .width('100%')
          TextArea({text:this.userInfo.getSignature()})
            .maxLength(100)
            .width('80%')
            .onChange((value)=>{
              this.userInfo.setSignature(value)
            })
            .border({width:1,color:'#f5f5f5'})
            .height(80)
            .fontColor($r('app.color.white'))
            .fontFamily('single')
            // .backgroundColor('#f5f5f5')

        }.width('100%').margin({top:20})

        Button('保存')
          .onClick(async ()=>{
            // await this.query()
            await this.updateUserInfo(this.userInfo)
            promptAction.showToast({message:'保存成功'})
            router.back()
          })
          .type(ButtonType.Normal)
          .backgroundColor($r('app.color.white'))
          .fontColor($r('app.color.black'))
          .width('50%')
          .borderRadius(100)
          .margin({top: 100, bottom: 20})

/*        Button('查询')
          .onClick(async ()=>{
            await this.query()
          })*/
      }
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.fengjing8'))
    .backgroundImageSize(ImageSize.Cover)


  }
}