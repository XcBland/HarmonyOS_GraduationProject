// 旅游手记模型
export default class TravelLogueModel {
  private static instance: TravelLogueModel;
  private constructor() {}

  static getInstance(): TravelLogueModel {
    if (!TravelLogueModel.instance) {
      TravelLogueModel.instance = new TravelLogueModel();
    }
    return TravelLogueModel.instance;
  }

  // TODO: Implement TravelLogueModel
}