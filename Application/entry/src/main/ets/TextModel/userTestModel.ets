// 用户测试模型
export interface userTestParams{
  uid: number               // 用户id
  displayName: string        // 用户名
  email: string              // 邮箱
  password: string           // 密码
  phoneNumber: string        // 手机号
  gender: number             // 性别
  birthday: string          // 生日
  signature: string          // 个性签名
}
// 定义用户测试模型类
export class userTestParamsModel implements userTestParams{
  uid: number = 0
  displayName: string = ''
  email: string = ''
  password: string = ''
  phoneNumber: string = ''
  gender: number = 0
  birthday: string = ''
  signature: string = ''
  constructor(params: userTestParams) {
    this.uid = params.uid
    this.displayName = params.displayName
    this.email = params.email
    this.password = params.password
    this.phoneNumber = params.phoneNumber
    this.gender = params.gender
    this.birthday = params.birthday
    this.signature = params.signature
  }
}



