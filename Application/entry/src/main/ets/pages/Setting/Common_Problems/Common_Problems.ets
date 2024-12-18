/**
 * @Auhtor DLY
 *
 */
import { promptAction, router } from '@kit.ArkUI'

import { util } from '@kit.ArkTS'

import HttpRequest from '../../../utils/HttpRequest'
import http from '@ohos.net.http'
import { MessageModel } from '../../../models/MessageModel'
import { MessageItem } from '../../../enity/MessageItem'
import cloud, { AuthUser } from '@hw-agconnect/cloud'
import MessageComp from '../../../components/MessageComp'
import { HmNavBar } from '../../../components'

@Entry
@Component
struct RobotTalking {
  //状态
  @State content: string = '' //发送的消息
  @State sending: boolean = false //是否正在发送
  //属性
  private messageModel: MessageModel = new MessageModel() //消息模型
  private scrollerController: Scroller = new Scroller() //滚动控制器
  @State user:AuthUser|null = null //当前用户信息
  //状态//监听
  @Watch('save') @State messageList: MessageItem[] = [] //消息列表

  save() {
    //将内容记录到首选项
    this.messageModel.savePreMessage(this.messageList)
  }

  //生命周期
  async aboutToAppear() {
    //调方法获取消息列表
    this.messageList = await this.messageModel.getMessageList()

    //追加:客服回复消息
    this.messageList.push({
      id: util.generateRandomUUID(), //自动生成一个唯一的标识:字母和数字的组合
      avatar: $r('app.media.user_dark'),
      userName: '机器人小艾',
      content: '您好,我是机器人小艾,很高兴为您服务,请问有什么可以帮助您？',
      timestamp: Date.now(),
      self: false
    })
    //选中最后一个消息
    this.scrollerController.scrollToIndex(this.messageList.length - 1)
  }

  //发送消息
  async sendMsg() {
    this.sending = true
    //创建数据对象
    setTimeout(async()=>{
      const selfMsg: MessageItem = {
        id: util.generateRandomUUID(), //自动生成一个唯一的标识:字母和数字的组合
        avatar: this.user?.getPhotoUrl(),
        userName: '我',
        content: this.content,
        timestamp: Date.now(),
        self: true
      } as MessageItem
      //清空输入框
      this.content = ''
      //追加到消息列表
      this.messageList.push(selfMsg)
      //发送消息到服务器
      const res = await HttpRequest.req(
        '/api.php',
        http.RequestMethod.GET,
        'key=free&appid=0&msg=' + selfMsg.content,
      )
      console.log('hmlog--> res:' + JSON.stringify(res))
      //提取
      //   NEXT必须要类型约束,这里是没有类型定义的
      //   先把得到的json格式对象转成字符传,再转json对象,变成object类型
      const str: string = JSON.parse(res!.result.toString()).content
      //追加:机器人回复消息
      this.messageList.push({
        id: util.generateRandomUUID(), //自动生成一个唯一的标识:字母和数字的组合
        avatar: $r('app.media.user_dark'),
        userName: '机器人小艾',
        content: str,
        timestamp: Date.now(),
        self: false
      })
      //停止发送状态
      this.sending = false
      //选中最后一个消息
      this.scrollerController.scrollToIndex(this.messageList.length - 1)
    },1000)
  }

  //构建
  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      //消息区域
      Column() {
        //标题
        HmNavBar({title: '常见问题咨询',showBackIcon:true})

        List({
          space: 20, //列表项间距
          scroller: this.scrollerController, //滚动控制器
          initialIndex: this.messageList.length - 1        //初始显示最后一条消息
        }) {
          ForEach(this.messageList, (item: MessageItem, index: number) => {
            ListItem() {
              //内容显示出来:消息组件
              MessageComp({ item })
            }
          })
        }
        .height('85%')
        .backgroundImage($r('app.media.fengjing14'))
        .backgroundImageSize(ImageSize.Cover)

      }
      .height('100%')


      //发送
      Row() {
        TextInput({text:this.content})
          .backgroundColor('#fff')
          .width('85%')
          .padding(10)
          .onChange((value: string) => {
            this.content = value
          })
        Button() {
          if (this.sending) {
            LoadingProgress().color('#fff')
          } else {
            Text('发送').fontColor('#fff')
          }
        }
        .width('15%')
        .height(40)
        .onClick(() => {
          this.content
            ? this.sendMsg()
            : promptAction.showToast({ message: '请输入消息内容' })
        })
        .enabled(!this.sending)
      }
      .width('100%')
      .padding(10)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f2f3')

  }
}