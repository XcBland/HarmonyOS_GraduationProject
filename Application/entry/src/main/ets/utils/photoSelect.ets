import cloud from '@hw-agconnect/cloud';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { promptAction } from '@kit.ArkUI';

export default class PhotoSelectUtils {
  private static instance: PhotoSelectUtils;

  private constructor() {
  }

  public static getInstance(): PhotoSelectUtils {
    if (!PhotoSelectUtils.instance) {
      PhotoSelectUtils.instance = new PhotoSelectUtils();
    }
    return PhotoSelectUtils.instance;
  }

  /**
   * 选择图片上传
   * @returns
   */
  async selectPhoto() {
    const options = new photoAccessHelper.PhotoSelectOptions(); // 创建PhotoSelectOptions对象
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 设置选择图片类型
    options.maxSelectNumber = 1;
    const result = await new photoAccessHelper.PhotoViewPicker().select(options) // 调用PhotoViewPicker的select方法选择图片
    return result.photoUris[0]; // 返回选择的图片的路径文件
  }


  /**
   * 上传图片到云存储
   */
  async uploadIamgeToAGC(photoUrl:string,cloudPath:string) {
    try {
      let extName = photoUrl!.split('.').pop();
      let fileName = `${Date.now()}.${extName}`;
      cloudPath = `myProjectImage/myAvcator/${fileName}`
      let result = await cloud.storage().upload({
        localPath: photoUrl,
        cloudPath: cloudPath
      })

      if (result.bytesTransferred === result.totalByteCount) {
        promptAction.showToast({ message: '图片上传成功！' })
        return cloudPath
      } else {
        promptAction.showToast({ message: '图片上传失败！' })
        return null
      }
    } catch (e) {
      console.error('hmlog-->', 'uploadImageToAGC Failed. Err:', JSON.stringify(e))
      promptAction.showToast({ message: '上传图片异常' })
      return null
    }

  }

  /**
   * 获取云存储文件路径
   */
  async getAGCFileUri(photoUrl:string,cloudPath:string|null) {
    photoUrl = await cloud.storage().getDownloadURL(cloudPath)
    promptAction.showToast({ message: '获取图片路径成功！' })
    return photoUrl
  }



}