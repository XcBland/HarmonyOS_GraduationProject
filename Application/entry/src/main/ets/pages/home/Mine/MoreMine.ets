import cloud, { AuthUser, Database, DatabaseCollection, Storage } from '@hw-agconnect/cloud';
import { HmNavBar } from '../../../components'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { promptAction, router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { userInfo } from '../../../enity/userInfo';
import { AgUser } from '../../../enity';
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { userTestParams, userTestParamsModel } from '../../../TextModel/userTestModel';


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
  // 员工列表
  @State user: userInfo = new userInfo();
  @State resultArray: userInfo[]=[]
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';

  cloudDataBase:DatabaseCollection<userInfo>|undefined = undefined
  authUser:AuthUser|null =null
  storage: Storage = cloud.storage()
  cloudPath: string | undefined = '';
/*  userTestModel:userTestParamsModel = new userTestParamsModel({

  })*/
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
    if(transResult.bytesTransferred===transResult.totalByteCount){
      await this.saveUser()
      promptAction.showToast({message:'上传成功'})

    }
  }

  //保存用户信息
  async saveUser(){
    try{
      await this.authUser!.updateProfile({
        displayName:'1',
        photoUrl:this.photoUrl
      })
    }catch(e){
      console.log("UpdatePersonal.65==>"+JSON.stringify((e)))
    }
  }

  async query(){
    try{
      this.resultArray = await this.cloudDataBase!.query().get()
      // promptAction.showToast({message:JSON.parse(JSON.stringify(this.resultArray))})
    }catch(err){
      console.log("UpdatePersonal.100==>"+JSON.stringify((err)))
    }
  }


  onPageShow(): void {
    cloud.auth().getCurrentUser().then(async user=>{
      this.authUser=user
      this.displayName=user!.getDisplayName()
      this.photoUrl=user!.getPhotoUrl()
      // this.userInfo=await userModel.GetUserInfoByUid(user!.getUid())
      this.isLoaded=true
    })
  }

  build() {
    Column() {
      HmNavBar({title:'编辑资料'})
      Column(){
        Row({space:20}){
          Text('头像')
            .fontSize(16)
          Image(this.photoUrl===''? $r('app.media.user_dark'):this.photoUrl)
            .width(20)
            .height(20)
            .borderRadius(70)
            .alt( $r('app.media.user_dark'))
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
          Text(this.currentUser?.email)

        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .borderWidth({bottom:1})

        ForEach(this.resultArray, (item:userInfo, index) => {
          Text(item.displayName)
          Text(item.email)
          Text(item.phoneNum)
          Text(item.birthday)
          Text(item.gender?'女':'男')
          Text(item.sign)
        })
        Button('查询')
          .onClick(async ()=>{
            await this.query()
          })
      }
    }
    .width('100%')
    .height('100%')

    
  }
}