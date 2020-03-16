class PrweQuestionModel {
  PrweQuestionModel(this.order, this.questionText, this.sectionDescriptorKey, this.sectionDescriptorValue, this.answerWeight, this.minAnswerScale, this.maxAnswerScale, this.scaleStep);

  String questionText;
  String sectionDescriptorKey;
  String sectionDescriptorValue;
  double answerWeight;
  double minAnswerScale;
  double maxAnswerScale;
  double scaleStep;
  int order;
  double answerValue = 0;
}
