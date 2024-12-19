export interface ImageList{
  url: string
}
export class ImageListModel implements ImageList {
  url: string = ""

  constructor(model: ImageList) {
    this.url = model.url
  }
}

export const ImageListEntity: ImageList[] = [
  new ImageListModel({url:"https://k.sinaimg.cn/n/sinakd20118/752/w690h862/20241117/4c5c-ca9978906b162f84ee6e8a84f9125d24.jpg/w700d1q75cms.jpg"}),
  new ImageListModel({url:"https://i0.hdslb.com/bfs/archive/cf52d9f0a428dc7edd20948182085012dbab7d1d.jpg"}),
  new ImageListModel({url:"https://i0.hdslb.com/bfs/archive/683db6f3610d76828cb7196f591595e784749f0b.jpg"}),
  new ImageListModel({url:"https://img0.baidu.com/it/u=3858626726,2517609960&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"}),
  new ImageListModel({url:"https://img1.baidu.com/it/u=2620568365,3859697128&fm=253&fmt=auto&app=138&f=JPEG?w=704&h=500"}),
  new ImageListModel({url:"https://img0.baidu.com/it/u=3932659156,1427731500&fm=253&fmt=auto&app=138&f=JPEG?w=480&h=270"})
]