/**
 * @Auhtor DLY
 *
 */
import { question_list } from '../../../enity/question_list'
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import schema from '../../../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { answer_list } from '../../../enity/answer_list'
import { router } from '@kit.ArkUI'
import { CommonRouterParams } from '../../../models'
import { Label } from '../../../enity'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../../constants'
import { HmNavBar } from '../../../components'
import dayjs from '@hview/dayjs'

@Entry
@Component
struct AskingDetail {
  @State questionList: question_list[] = [] // 问题列表
  @StorageLink('answer_list') answerList: answer_list[] = [] // 回答列表
  @State answerList_temp: answer_list[] = [] // 回答列表临时
  @State answerCount: number = 0 // 回答数量
  // @State answerList_copy: answer_list[] = [] // 回答列表副本
  @State content: string = '' // 回答内容
  @State isRefreshing: boolean = false
  @State promptText: string = "Refreshing..."
  @State pageSize: number = 5 // 每页显示的数量
  @State pageIndex: number = 0 // 当前页数
  @State allPage: number = 1 // 总页数
  @State loading: boolean = false // 加载中
  // CloudDB API
  private cloudDB: Database | null = null;
  // 云数据库存储区
  private cloudDBZone = 'Graduation';
  cloudDataBase_question: DatabaseCollection<question_list> | null = null
  cloudDataBase_answer: DatabaseCollection<answer_list> | null = null

  async onPageShow() {
    this.cloudDB = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.cloudDBZone,
    })
    this.cloudDataBase_question = this.cloudDB.collection<question_list>(question_list) // 获取云数据库的集合
    this.cloudDataBase_answer = this.cloudDB.collection<answer_list>(answer_list) // 获取云数据库的集合
    await this.queryAll()
  }

  // 查询问题和回答列表所有数据
  async queryAll() {
    try {
      const params = router.getParams() as CommonRouterParams
      this.questionList = await this.cloudDataBase_question!.query().equalTo('id', params.id).get()
      this.answerList =
        await this.cloudDataBase_answer!.query()// .limit(this.pageSize, this.pageIndex * this.pageSize)// 分页查询: 每页显示2条数据，当前页数*2
          .orderByDesc('publishTime')// 按发布时间倒序排序
          .equalTo('uid_question', this.questionList[0].getTitle())
          .get()
      this.answerList_temp =
        await this.cloudDataBase_answer!.query().equalTo('uid_question', this.questionList[0].getTitle()).get()
      this.allPage = Math.ceil(this.answerList_temp.length / this.pageSize) // 计算总页数
      this.answerCount = this.answerList_temp.length // 回答数量
    } catch (e) {
      console.log("queryAll error: " + e.message)
    }
  }

  // 发表回答
  async uploadAnswer(content: string) {
    try {
      let answer = new answer_list()
      let user = await cloud.auth().getCurrentUser()
      answer.setUid_answer(dayjs(new Date()).format('YYYYMMDDHHmmss') + user?.getUid())
      answer.setUid_question(this.questionList[0].title)
      answer.setContent(content)
      answer.setUser_photoUrl(user?.getPhotoUrl())
      answer.setUser_displayName(user?.getDisplayName())
      answer.setPublishTime(dayjs(new Date()).format('YYYY-MM-DD HH:mm:ss'))
      await this.cloudDataBase_answer?.upsert(answer)
    } catch (e) {
      console.log("uploadAnswer error: " + e.message)
    }
  }

  // 渲染问题列表
  @Builder
  renderQuestionList() {
    Column({ space: 10 }) {
      ForEach(this.questionList, (item: question_list, index) => {
        Row({ space: 5 }) {
          Image($r('app.media.question'))
            .width(30)
            .height(30)
            .aspectRatio(1)
          Text(item.title)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Start)

        Row() {
          Text(item.content)
            .fontSize(20)
            .margin({ top: 10 })
            .fontColor($r('app.color.text_primary'))
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          ForEach((JSON.parse(item.label) as Label[]), (item: Label, index) => {
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
                router.pushUrl({ url: "pages/LabelPage/LabelPage", params: { keyword: item.labels } })
              })
          })

        }.width('100%')

        Row() {
          Image(item.user_photoUrl)
            .width(20)
            .aspectRatio(1)
            .borderRadius(20)
          Text(item.user_displayName)
            .fontSize(12)
            .fontColor($r('app.color.text_primary'))
            .margin({ left: 10 })
          Blank()
          Text("发布于" + item.publishTime.slice(0, 10))
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
            .margin({ right: 10 })
        }
        .width('100%')

      })
    }
    .width('90%')
    .margin({ top: 20 })
  }

  // 获取回答数量
  getAnswerCount() {
    return this.answerList_temp.length
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Scroll() {

        Column() {
          HmNavBar({ title: '问题详情' })
          List() {
            ListItem() {
              this.renderQuestionList()
            }.width('100%')

            ListItem() {
              Divider()
                .height(1)
                .margin({ top: 10, bottom: 10 })
                .width('90%')
            }.width('100%')

            ListItem() {
              Column() {
                Row() {
                  Text(`全部回答(${this.answerCount})`)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Start)
                    .margin({ left: 10 })
                }
                .width('90%')

                // 回答列表
                Refresh({ refreshing: $$this.isRefreshing, promptText: this.promptText }) {
                  List() {
                    ForEach(this.answerList, (item: answer_list, index) => {
                      ListItem() {
                        Column({ space: 10 }) {
                          Row({ space: 10 }) {

                            Image(item.user_photoUrl)
                              .width(16)
                              .aspectRatio(1)
                              .borderRadius(10)

                            Text(item.user_displayName)
                              .fontSize(16)
                              .fontColor($r('app.color.text_primary'))

                            Text(item.publishTime.slice(11, 16))
                              .fontSize(16)
                              .fontColor($r('app.color.text_secondary'))

                          }
                          .width('90%')

                          Row() {
                            Text(item.content)
                              .fontSize(16)
                              .fontColor($r('app.color.text_secondary'))
                              .margin({ top: 10 })
                          }
                          .width('90%')
                        }
                      }.margin(20)

                    })
                  }
                  .width('90%')
                  .margin({ top: 10 })
                  .scrollBar(BarState.Off)
                  .onReachEnd(async () => {
                    console.log('到底了')
                    // 如果到底了，则加载下一页数据
                    // if (this.pageIndex < this.allPage - 1) {
                    //   this.pageIndex += 1
                    //   this.isRefreshing = true
                    //   this.promptText = "Loading..."
                    //   await this.queryAll()
                    //     .then(() => {
                    //       this.answerList = [...this.answerList] // 刷新数据
                    //     })
                    //   this.isRefreshing = false

                    // }


                  })
                }
                .onRefreshing(() => {
                  setTimeout(() => {
                    this.isRefreshing = false
                    this.promptText = "Refreshing..."
                    this.queryAll()
                  }, 1000)
                })

              }

            }.width('100%')

            ListItem() {
              Row().width('100%').height(100)
            }
          }
          .height('100%')
          .width('100%')

        }
      }
      .width('100%')

      .scrollBar(BarState.Off)
      .layoutWeight(1)

      Row() {
        TextInput({ placeholder: "善语结善缘 恶语伤人心", text: this.content })
          .width('70%')
          .height(40)
          .onChange((content) => {
            this.content = content
          })
          .fontSize(14)
        Text('发送')
          .margin({ right: 30 })
          .fontSize(14)
          .onClick(() => {
            if (this.content.trim() === '') {
              return
            }
            this.uploadAnswer(this.content)
            this.content = ''
            this.queryAll()
            this.answerList_temp = [...this.answerList_temp] // 刷新数据
            this.answerCount = this.answerList_temp.length // 刷新回答数量


          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('90%')
      .margin({ top: 10 })
      .height(40)
      .zIndex(10)
      .backgroundColor('#f3f4f5')
      .borderRadius(20)

    }

    .width('100%')
    .padding({
      top: AppStorage.get<number>(APP_TOP_HEIGHT),
      bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT)
    })

  }
}