export interface ImageList{
  url: string
}
export class ImageListModel implements ImageList {
  url: string = ""

  constructor(model: ImageList) {
    this.url = model.url
  }
}