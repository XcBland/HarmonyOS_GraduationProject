/**
 * @Auhtor DLY
 *
 */
import cloud, { AuthUser, Database, DatabaseCollection } from '@hw-agconnect/cloud'
import { HmNavBar } from '../../../components'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { travel_tips as travelLog } from '../../../enity/travel_tips'
import { ImageList, Label } from '../../../enity'
import { promptAction, router } from '@kit.ArkUI'
import dayjs from '@hview/dayjs'
import { photoAccessHelper } from '@kit.MediaLibraryKit'


@Entry
@Component
struct UpdateTravelLog {
  // @State traveLog: travelLog = {} as travelLog // 旅游日志
  @State imageList: ImageList[] = [] // 图片列表
  @State cloudImgList: ImageList[] = [] // 云存储图片列表
  @State labelList: Label[] = [] // 标签列表
  @State label: string = '' // 标签输入框内容
  @State title: string = '' // 标题输入框内容
  @State content: string = '' // 内容输入框内容
  @State photoUrl: string = '' // 图片路径
  @State cloudPath: string = '' // 云存储路径
  storage = cloud.storage() // 云存储实例
  user: AuthUser | null = null
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<travelLog> | null = null

  async aboutToAppear() {
    this.user = await cloud.auth()?.getCurrentUser()
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone
    })
    this.cloudDataBase = this.cloudDB.collection<travelLog>(travelLog) // 获取云数据库的集合
  }

  // 上传旅游日志
  async uploadTravelLog(title: string, content: string
    , labelList: Label[], subTitle: string
    , imageList: ImageList[]) {
    try {
      const traveLog = new travelLog()
      traveLog.title = title
      traveLog.content = content
      traveLog.label = JSON.stringify(labelList)
      traveLog.subtitle = subTitle
      traveLog.photoUrl = JSON.stringify(imageList)
      traveLog.publishTime = dayjs(new Date()).format('YYYY-MM-DD HH:mm:ss')
      traveLog.userId = this.user?.getUid()
      await this.cloudDataBase?.upsert(traveLog)
      this.labelList = []
      this.imageList = []
      this.cloudImgList = []
      this.title = ''
      this.content = ''
      this.label = ''
      this.photoUrl = ''
      router.replaceUrl({url:'pages/home/Index'})
    } catch (e) {
      console.error('uploadTravelLog error:' + e.message)
    }
  }

  /**
   * 选择图片上传
   * @returns
   */
  async selectPhoto() {
    const options = new photoAccessHelper.PhotoSelectOptions(); // 创建PhotoSelectOptions对象
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 设置选择图片类型
    options.maxSelectNumber = 1;
    const result = await new photoAccessHelper.PhotoViewPicker().select(options) // 调用PhotoViewPicker的select方法选择图片
    return result.photoUris[0]; // 返回选择的图片的路径文件
  }

  /**
   * 上传图片到云存储
   */
  async uploadIamgeToAGC() {
    try {
      let extName = this.photoUrl!.split('.').pop();
      let fileName = `${Date.now()}.${extName}`;
      this.cloudPath = `myProjectImage/myAvcator/${fileName}`
      let result = await this.storage.upload({
        localPath: this.photoUrl,
        cloudPath: this.cloudPath
      })
      if (result.bytesTransferred === result.totalByteCount) {
        // promptAction.showToast({ message: '图片上传成功！' })
        return true;
      } else {
        promptAction.showToast({ message: '图片上传失败！' })
        return false;
      }
    } catch (e) {
      console.error('hmlog-->', 'uploadImageToAGC Failed. Err:', JSON.stringify(e))
      promptAction.showToast({ message: '上传图片异常' })
      return false
    }
  }

  /**
   * 获取云存储文件路径
   */
  async getAGCFileUri(){
    let imgUri = await this.storage.getDownloadURL(this.cloudPath)
    this.photoUrl = imgUri
    return imgUri
  }

  build() {
    Column({ space: 20 }) {
      HmNavBar({ title: '发布攻略' })
      TextInput({ placeholder: '好的标题能够吸引更多的驴友哦~' })
        .onChange((value) => {
          this.title = value
        })
        .width('95%')
        .align(Alignment.Center)
        .padding(10)
        .backgroundColor($r('app.color.white'))
        .borderWidth({ bottom: 1 })
        .borderRadius(5)
      Column() {
        TextArea({ placeholder: '写下你的游记吧~' })
          .onChange((value) => {
            this.content = value
          })
          .backgroundColor($r('app.color.white'))
      }
      .borderWidth({ bottom: 1 })
      .borderRadius(5)
      .backgroundColor($r('app.color.white'))
      .width('95%')
      .height(300)

      Row({ space: 5 }) {
        Image($r('app.media.label'))
          .width(14)
          .aspectRatio(1)
        Text('添加话题')
          .fontSize(16)
        Blank()
        Text('>')
          .fontSize(16)
      }
      .borderRadius(5)
      .alignItems(VerticalAlign.Center)
      .width('95%')
      .backgroundColor($r('app.color.white'))
      .padding(10)

      Column() {
        Row() {
          ForEach(this.labelList, (item: Label, index: number) => {
            Row() {
              Text(item.labels)
                .fontSize(14)
                .fontColor('#ff00c4ff')
                .border({ width: 1, color: '#ff00c4ff' })
                .padding({
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 5
                })
                .borderRadius(10)
                .onClick(() => {
                  this.labelList.splice(index, 1) // 删除标签
                })
            }
          })
          Row({ space: 10 }) {
            TextInput({ placeholder: '添加话题', text: this.label })
              .width('auto')
              .backgroundColor($r('app.color.white'))
              .onChange((value) => {
                this.label = value
              })
            Text('+')
              .fontSize(20)
              .backgroundColor($r('app.color.white'))
              .width(20)
              .height(20)
              .borderWidth(1)
              .textAlign(TextAlign.Center)
              .borderRadius(50)
              .onClick(() => {
                if (this.label === '') {
                  promptAction.showToast({ message: '请输入话题标签' })
                  return
                }
                // 如果话题标签内没有'#',则不允许添加
                if (this.label.indexOf('#') === -1) {
                  promptAction.showToast({ message: '话题标签必须以#开头' })
                  this.label = ''
                  return
                }
                // 如果话题标签内已经存在该标签，则不允许添加
                this.labelList.forEach((item: Label) => {
                  if (item.labels === this.label) {
                    promptAction.showToast({ message: '话题标签已存在,请勿重复添加' })
                    this.label = ''
                    return
                  }
                })
                if (this.label !== '') {
                  this.labelList.push({ labels: this.label })
                }
                this.label = ''
              })
          }
          .margin({ left: 10 })
          .alignItems(VerticalAlign.Center)


        }.width('100%')
        .padding({ left: 10, right: 10 })
      }

      Row({ space: 5 }) {
        Text('添加图片')
          .fontSize(16)
        Text('>')
          .fontSize(16)
      }
      .borderRadius(5)
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('app.color.white'))
      .alignItems(VerticalAlign.Center)
      .width('95%')
      .padding(10)

      Column() {
        Row() {
          ForEach(this.imageList, (item: ImageList, index: number) => {
            Image(item.url)
              .width(100)
              .height(100)
              .borderRadius(10)
              .border({ width: 1, color: '#ff00c4ff' })
              .onClick(() => {
                this.imageList.splice(index, 1) // 删除图片
              })
          })

          Text('+')
            .backgroundColor($r('app.color.white'))
            .fontSize(20)
            .width(100)
            .height(100)
            .borderRadius(10)
            .borderWidth(1)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              this.selectPhoto()
                .then((url) => {
                  this.photoUrl = url
                  this.imageList.push({ url: this.photoUrl })
                  this.uploadIamgeToAGC()
                    .then(async () => {
                      await this.getAGCFileUri()
                      this.cloudImgList.push({ url:this.photoUrl })
                    })
                })
            })
        }
        .width('100%')



      }
      .margin({ left: 10 })
      Button('发布')
        .onClick(() => {
          this.uploadTravelLog(this.title, this.content, this.labelList, '', this.cloudImgList)
          promptAction.showToast({ message: '发布成功' })
        })
        .type(ButtonType.Normal)
        .width('80%')
        .alignSelf(ItemAlign.Center)
        .borderRadius(10)
        .backgroundColor($r('app.color.primary'))
        .fontColor($r('app.color.white'))
      Row().width('100%').height(30)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.fengjing12'))

  }
}

