//[首选项工具]
// 负责:购物车 和 聊天


import preferences from "@ohos.data.preferences";

export default class PreHelper {
  private static instance:PreHelper
  static getInstance(name:string):PreHelper{
    if(!PreHelper.instance){
      PreHelper.instance = new PreHelper(name)
    }
    return PreHelper.instance
  }
  // 设置存储对象名称
  private name:string
  private constructor(name:string) {
    this.name = name
  }
  /**
   * 获取存储对象
   * @returns           存储对象
   */
  private getStore(){
    return preferences.getPreferences(getContext(this),this.name)
  }

  /**
   * 设置或更新数据
   * @param key         键
   * @param data        数据
   * @returns           void
   */
  async set(key:string,data:string):Promise<void>{
    const store =await this.getStore()  // 获取存储对象
    await store.put(key,data) // 异步写入
    await store.flush() // 立即写入
  }

  /**
   * 获取数据
   * @param key         键
   * @returns           Promise<string>
   */
  async get(key:string):Promise<string>{
    const store =await this.getStore()  // 获取存储对象
    const res:preferences.ValueType = await store.get(key,'')             // 异步写入
    return res as string
  }


  /**
   * 删除数据
   * @param key         键
   * @returns           void
   */
  async remove(key:string):Promise<void>{
    const store =await this.getStore()  // 获取存储对象
    await store.delete(key)             // 异步写入
    await store.flush()                 // 立即写入到物理文件
  }


}