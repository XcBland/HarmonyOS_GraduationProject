import cloud, { Database, DatabaseCollection } from "@hw-agconnect/cloud";
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { answer_list } from "../enity/answer_list";
import { question_list } from "../enity/question_list";
import { promptAction, router } from "@kit.ArkUI";
import { Label } from "../enity";

@Component
export struct AskingComp {
  @StorageLink('questionList') questionList: question_list[] = []
  @StorageLink('answerList') answerList: answer_list[] = []
  // @State answerCount: number[] = []
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase_question: DatabaseCollection<question_list> | null = null
  cloudDataBase_answer: DatabaseCollection<answer_list> | null = null

  async aboutToAppear() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase_question = this.cloudDB.collection<question_list>(question_list)
    this.cloudDataBase_answer = this.cloudDB.collection<answer_list>(answer_list)
    await this.queryAllData()
  }

  // 获取所有数据
  async queryAllData() {
    try {
      this.questionList = await this.cloudDataBase_question!.query().get()
      this.answerList =
        await this.cloudDataBase_answer!.query().equalTo('uid_question', this.questionList[0].getTitle()).get()
      // this.answerCount = this.getAnswerCount()
    } catch (e) {
      promptAction.showToast({ message: e.message })
    }
  }

  // 获取问题回答数量
  // getAnswerCount() {
  //   this.answerList.forEach((item) => {
  //     if (item.getUid_question() === this.questionList[0].getTitle()) {
  //       this.answerCount.push(1)
  //     }
  //   })
  //   return this.answerCount
  // }

  @Builder
  getQuestionList() {
    List() {
      ForEach(this.questionList, (item: question_list, index: number) => {
        ListItem() {
          Row() {
            Image(item.user_photoUrl)
              .width(30)
              .aspectRatio(1)
              .position({ top: 5 })
            Column({ space: 10 }) {
              Text(item.user_displayName)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
                .margin({ top: 10 })
              Text(item.getTitle())
                .fontSize(20)
                .fontColor($r('app.color.text_primary'))
              Text((JSON.parse(item.getLabel()) as Label[])[0].labels)
                .fontSize(12)
                .fontColor('#ff00c4ff')
                .border({ width: 1, color: '#ff00c4ff' })
                .padding({
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 5
                })
                .borderRadius(10)
              Row() {
                Text(item.getPublishTime())
                  .fontSize(12)
                  .fontColor($r('app.color.text_secondary'))
                Blank()
                Image($r('app.media.answer'))
                  .width(15)
                  .fillColor($r('app.color.text_secondary'))
                // 回复数量
                Text(this.answerList.length+'')


              }
              .width('100%')
            }
            .margin({ left: 50 })
            .width('80%')
            .justifyContent(FlexAlign.Start)
            .alignItems(HorizontalAlign.Start)
          }
          .onClick(() => {
            router.pushUrl({ url: 'pages/Travel/Asking/AskingDetail', params: { id: index + 1 } })
          })
          .width('100%')
        }
      })
    }
    .width('90%')
    .margin({ top: 20 })
  }

  build() {
    Column() {
      this.getQuestionList()
    }
    .width('100%')
  }
}