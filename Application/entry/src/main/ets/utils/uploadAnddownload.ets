// 文件上传示例
/*
  方式一：request.uploadFile
  * pages/xxx/ets
*/
import { common } from '@kit.AbilityKit'
import fs from '@ohos.file.fs'
import { BusinessError, request } from '@kit.BasicServicesKit'
import { BASE_URL } from '../constants'
import { buffer } from '@kit.ArkTS'

export function uploadFile_01() {
  // 获取应用文件路径
  let context = getContext() as common.UIAbilityContext // 获取UIAbilityContext对象
  let cacheDir = context.cacheDir // 获取缓存目录

  // 新建一个本地应用文件
  let localFile = fs.openSync(`${cacheDir}/test.txt`,
    fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE) // 打开或创建文件
  fs.writeSync(localFile.fd, 'upload file test') // 写入内容
  fs.closeSync(localFile) // 关闭文件

  // 上传任务配置项
  let header = new Map<Object, string>()
  header.set('Content-Type', 'application/json')
  header.set('Authorization', 'Bearer ' + 'your token')
  let files: Array<request.File> = [
  //   uri 前缀internal://cache 对应cacheDir目录
    {
      filename: 'test.txt',
      name: 'text.txt',
      uri: 'internal://cache/test.txt',
      type: '.txt'
    }
  ]
  //  请求参数
  let data: Array<request.RequestData> = [{
    name: 'name', value: 'value'
  }]
  // 上传文件
  let uploadConfig: request.UploadConfig = {
    url: BASE_URL + '/upload',
    header: header,
    method: 'POST',
    files: files,
    data: data
  }

  // 将本地应用文件上传至网络服务器
  try {
    request.uploadFile(context, uploadConfig)
      .then((uploadTask: request.UploadTask) => {
        uploadTask.on('complete', (taskStates: Array<request.TaskState>) => {
          for (let i = 0; i < taskStates.length; i++) {
            console.log('upload task complete:' + taskStates[i])
          }
        })
      })
      .catch((err: BusinessError) => {
        console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`)
      })
  } catch (e) {
    let err: BusinessError = e as BusinessError
    console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`)
  }

}

/*
 * 方式二：request.agent (推荐)
 * pages/xxx.ets
 * 将网络资源文件下载到应用文件目录并读取一段内容
*/

export function uploadFile_02() {
  // 获取应用文件路径
  let context = getContext() as common.UIAbilityContext
  let cacheDir = context.cacheDir

  //   新建一个本地应用文件
  let file = fs.openSync(`${cacheDir}/test.txt`, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
  fs.writeSync(file.fd, 'upload file test')
  fs.closeSync(file)
  let attachments: Array<request.agent.FormItem> = [
    {
      name: 'test',
      value: [{
        filename: 'test.txt',
        path: "./test.txt"
      },]
    }
  ]
  let config: request.agent.Config = {
    action: request.agent.Action.UPLOAD, // 上传文件
    url: BASE_URL + '/upload', // 上传地址
    mode: request.agent.Mode.FOREGROUND, // 上传模式
    overwrite: true, // 是否覆盖已存在文件
    method: 'POST', // 请求方法
    data: attachments, // 请求参数
    saveas: "./"  // 保存路径
  }
  request.agent.create(getContext(), config).then((task: request.agent.Task) => {
    task.start((err: BusinessError) => {
      if (err) {
        console.log(`Failed to start the upload task,Code:${err.code},Message:${err.message}`)
        return
      }
    })
    task.on('progress', async (progress) => {
      console.warn(`Upload progress:${progress}`)
    })
    task.on('completed', async () => {
      console.warn(`/Request upload completed`)
    })
  }).catch((err: BusinessError) => {
    console.error(`Failed to create the upload task,Code:${err.code},Message:${err.message}`)
  })

}

//=======================================================================================================
/*下载文件示例
方式一:request.downloadFile
pages/xxx/ets
将网络资源文件下载到应用文件目录并读取一段内容
*/

export function downloadFile_01() {
  // 获取应用文件路径
  let context = getContext() as common.UIAbilityContext
  let filesDir = context.filesDir

  try {
    request.downloadFile(context, {
      url: BASE_URL + '/download',
      filePath: filesDir + '/test.txt',
    }).then((downloadTask: request.DownloadTask) => {
      console.log('download completed')
      let file = fs.openSync(filesDir + '/test.txt', fs.OpenMode.READ_WRITE)
      let arrayBuffer = new ArrayBuffer(1024)
      let readLen = fs.readSync(file.fd, arrayBuffer)
      let buf = buffer.from(arrayBuffer, 0, readLen)
      console.log('download content:' + buf.toString())
      fs.closeSync(file)
    }).catch((err: BusinessError) => {
      console.error(`Invoke downloadFile failed, code is ${err.code}, message is ${err.message}`)
    })
  } catch (e) {
    let err: BusinessError = e as BusinessError
    console.error(`Invoke downloadFile failed, code is ${err.code}, message is ${err.message}`)

  }
}

/*
 *  方式二:request.agent (推荐)
 * pages/xxx.ets
 * 将网络资源文件下载到应用文件目录并读取一段内容
*/
export function downloadFile_02() {
  let config: request.agent.Config = {
    action: request.agent.Action.DOWNLOAD, // 下载文件
    url: BASE_URL + '/download', // 下载地址
    gauge: true, // 是否显示进度条
    overwrite: true, // 是否覆盖已存在文件
    network: request.agent.Network.ANY, // 网络类型
  }
  request.agent.create(getContext(), config)
    .then((task: request.agent.Task) => {
      task.start((err: BusinessError) => {
        if (err) {
          console.error(`Failed to start the download task,Code:${err.code},Message:${err.message}`)
          return
        }
      })
      task.on('progress', async (progress) => {
        console.warn(`Download progress:${progress}`)
      })
      task.on('completed', async () => {
        console.warn(`Download completed`)
      })
    }).catch((err: BusinessError) => {
    console.error(`Failed to create the download task,Code:${err.code},Message:${err.message}`)
  })
}
