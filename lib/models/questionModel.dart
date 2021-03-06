import 'package:json_annotation/json_annotation.dart';
import 'package:climify/models/answerOption.dart';

part 'questionModel.g.dart';

@JsonSerializable(explicitToJson: true)
class Question {
  List<String> rooms;
  String value;
  List<AnswerOption> answerOptions;

  Question(
    this.rooms,
    this.value,
    this.answerOptions,
  );

  factory Question.fromJson(json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
