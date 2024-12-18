export interface Label {
  labels: string
}
export class LabelModel implements Label {
  labels: string;
  constructor(labels: string) {
    this.labels = labels;
  }
}