
//[消息条目]
export class MessageItem {
  id:string = ''                //信息id
  avatar:ResourceStr = ''       //头像
  userName:string = ''          //用户名
  content:string = ''           //内容
  timestamp:number = 0          //时间戳
  self:boolean = false          //是否是自己发送的
}