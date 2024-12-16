
import cloud, { Database, DatabaseCollection } from '@hw-agconnect/cloud'
import schema from '../../resources/rawfile/My_Gradute_Project_3_cn.json'
import { userInfo_01 as UserInfo } from '../enity/userInfo'

class UserModel{
  private zoneName:string = 'Graduation'  // 数据库所在区域名称
  private database:Database | null = null // 数据库对象
  private collection:DatabaseCollection<UserInfo> | null = null // 用户信息集合对象

  constructor() {
    this.database = cloud.database({
      objectTypeInfo: schema,
      zoneName: this.zoneName
    })
    this.collection = this.database.collection<UserInfo>(UserInfo)  // 实例化用户信息集合对象
  }

/*  // 获取用户所有信息内容
  async getUserInfo(uid:string){
    let user = await this.collection!.query().equalTo('uid', uid).get()
    return user[0]
  }*/



}

// type paramsType = number | string | Date;