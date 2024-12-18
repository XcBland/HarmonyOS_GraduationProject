import { MessageItem } from "../enity/MessageItem"
import PreHelper from "../utils/PreHelper"


/**
 * 消息功能模块
 */
export class MessageModel {
  //属性
  private preHelper: PreHelper = PreHelper.getInstance('Talking')

  /**
   * 获取消息记录-首选项
   * @returns Promise<MessageItem[]>
   */
  async getMessageList(): Promise<MessageItem[]> {
    //查询首选项
    const str: string = await this.preHelper.get('msg')
    //返回
    return str
      ? JSON.parse(str) as MessageItem[]
      : []
  }

  /**
   * 记录首选项
   * @param list 消息列表
   */
  savePreMessage(list: MessageItem[]) {
    this.preHelper.set('msg', JSON.stringify(list))
  }

  /**
   * 清除首选项
   */
  clearPreMessage() {
    this.preHelper.remove('msg')
  }
}