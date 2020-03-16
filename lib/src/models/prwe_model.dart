import 'package:insightq/src/models/prwe_question_model.dart';

class PrweModel {
  PrweModel(this.subjectId);

  var questionList = [
    {"QuestionString": "Rate your pain - At rest", "SectionDescriptorKey": "Pain"},
    {"QuestionString": "Rate your pain - When doing a task with a repeated wrist/hand movement", "SectionDescriptorKey": "Pain"},
    {"QuestionString": "Rate your pain - When lifting a heavy object", "SectionDescriptorKey": "Pain"},
    {"QuestionString": "Rate your pain - When it is at its worst", "SectionDescriptorKey": "Pain"},
    {"QuestionString": "How often do you have pain?", "SectionDescriptorKey": "Pain"},
    {"QuestionString": "Turn a door knob using my affected hand", "SectionDescriptorKey": "Function - Specific Activities"},
    {"QuestionString": "Cut meat using a knife in my affected hand", "SectionDescriptorKey": "Function - Specific Activities"},
    {"QuestionString": "Fasten buttons on my shirt", "SectionDescriptorKey": "Function - Specific Activities"},
    {"QuestionString": "Use my affected hand to push up from a chair", "SectionDescriptorKey": "Function - Specific Activities"},
    {"QuestionString": "Carry a 10lb object in my affected hand", "SectionDescriptorKey": "Function - Specific Activities"},
    {"QuestionString": "Use bathroom tissue with my affected hand", "SectionDescriptorKey": "Function - Specific Activities"},
    {"QuestionString": "Personal care activities (dressing, washing)", "SectionDescriptorKey": "Function - Usual Activities"},
    {"QuestionString": "Household work (cleaning, maintenance)", "SectionDescriptorKey": "Function - Usual Activities"},
    {"QuestionString": "Work (your job or usual everyday work)", "SectionDescriptorKey": "Function - Usual Activities"},
    {"QuestionString": "Recreational activities", "SectionDescriptorKey": "Function - Usual Activities"},
    {"QuestionString": "Rate how dissatisfied you were with the appearance of your wrist/hand during the past week", "SectionDescriptorKey": "Appearance"}
  ];

  var sectionDescriptors = {
    "Pain": "The questions below will help us understand how much difficulty you have had with your wrist/hand in the past week. "
        "You will be describing your average wrist/hand symptoms over the past week on a scale of 0-10. Please provide an answer for ALL questions. "
        "If you did not perform an activity, please ESTIMATE the pain or difficulty you would expect. If you have never performed the activity, you may leave it blank. ",
    "Function - Specific Activities": "Rate the amount of difficulty you experienced performing each of the items listed in the following questions "
        "- over the past week, by selecting the number that describes your difficulty on a scale of 0-10. "
        "A zero (0) means you did not experience any difficulty and a ten (10) means it was so difficult "
        "you were unable to do it at all",
    "Function - Usual Activities": "Rate the amount of difficulty you experienced performing your usual activities in each "
        "of the following questions - over the past week, by selecting the number that best describes your "
        "difficulty on a scale of 0-10. By “usual activities”, we mean the activities you performed "
        "before you started having a problem with your wrist/hand. A zero (0) means that you did not "
        "experience any difficulty and a ten (10) means it was so difficult you were unable to do any of "
        "your usual activities.",
    "Appearance": "How important is the appearance of your hand?",
  };

  List<PrweQuestionModel> questions = new List<PrweQuestionModel>();
  double score;
  String subjectId;

  initializeQuestions() {
    int i = 1;
    questionList.forEach((element) {
      questions.add(PrweQuestionModel(i++, element["QuestionString"], element["SectionDescriptorKey"], sectionDescriptors[element["SectionDescriptorKey"]], 1.0, 0.0, 10.0, 1.0));
    });
  }

  double calculateScore() {
    // add first 5 answers together
    double painScore = 0;
    for (var i = 0; i < 5; i++) {
      painScore += questions[i].answerValue;
    }
    double functionScore = 0;
    // add next 10 -> divide by 2
    for (var i = 5; i < 15; i++) {
      functionScore += questions[i].answerValue;
    }
    return painScore + (functionScore / 2);
  }
}
