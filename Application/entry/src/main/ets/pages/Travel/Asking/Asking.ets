/**
 * @Auhtor DLY
 *
 */
import { HmNavBar } from '../../../components'
import { Label } from '../../../enity'
import { promptAction, router } from '@kit.ArkUI'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import { question_list } from '../../../enity/question_list'
import dayjs from '@hview/dayjs'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'

@Entry
@Component
struct Asking {
  @State content: string = ''
  @State labelList: Label[] = [] // 标签列表
  @State label: string = '' // 标签输入框内容
  @State title: string = '' // 问题标题
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase: DatabaseCollection<question_list> | null = null

  aboutToAppear() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone
    })
    this.cloudDataBase = this.cloudDB.collection<question_list>(question_list) // 获取云数据库的集合
  }

  // 上传疑问
  async uploadQuestion(title: string, content: string, label: Label[]) {
    try {
      const user = await cloud.auth().getCurrentUser()
      const question = new question_list()
      question.setUid(dayjs(new Date().getTime()).format('YYYYMMDDHHmmss') + user?.getUid())
      question.setTitle(title)
      question.setContent(content)
      question.setLabel(JSON.stringify(label))
      question.setPublishTime(dayjs(new Date().getTime()).format('YYYY-MM-DD HH:mm:ss'))
      question.setUser_photoUrl(user?.getPhotoUrl())
      question.setUser_displayName(user?.getDisplayName())
      if (this.cloudDataBase) {
        await this.cloudDataBase.upsert(question)
        router.back()
      }
    } catch (e) {
      console.error('uploadQuestion error:' + e.message)
    }
  }

  @Builder
  addLabel() {
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
  }

  build() {
    Column({ space: 20 }) {
      HmNavBar({ title: '提问' })
      TextInput({ placeholder: '好的攻略标题才能让人眼前一亮' })
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
        TextArea({ placeholder: '让更多的旅游达人看到你的疑问啵~' })
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

      this.addLabel()

      Row() {
        Button('发布')
          .type(ButtonType.Normal)
          .width('50%')
          .borderRadius(5)
          .onClick(() => {
            if (this.title === '') {
              promptAction.showToast({ message: '请输入问题标题' })
              return
            }
            if (this.content === '') {
              promptAction.showToast({ message: '请输入问题内容' })
              return
            }
            if (this.labelList.length === 0) {
              promptAction.showToast({ message: '请选择话题标签' })
              return
            }
            this.uploadQuestion(this.title, this.content, this.labelList)
          })

      }
      .margin({ top: 100 })
      .justifyContent(FlexAlign.Center)
      .width('95%')
    }
    .width('100%')
    .height('100%')
    .padding({ top: AppStorage.get<number>(APP_TOP_HEIGHT), bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT) })

  }
}