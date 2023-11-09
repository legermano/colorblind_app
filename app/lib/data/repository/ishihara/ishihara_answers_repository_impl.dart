import 'dart:convert';

import 'package:boilerplate/domain/entity/ishihara/answer_list.dart';
import 'package:boilerplate/domain/repository/ishihara/ishihara_answers_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IshiharaAnswersRepositoryImpl extends IshiharaAnswersRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // constructor
  IshiharaAnswersRepositoryImpl();

  // Answers: ------------------------------------------------------------------
  @override
  Future<AnswerList?> getAnswers(String uid) async {
    AnswerList? answerList;

    await db.collection("user")
      .doc(uid)
      .get()
      .then((value) {
        if(value.data() != null) {
          final data = value.data() as Map<String, dynamic>;

          if(data['answers'] != null) {
            answerList = AnswerList.fromJson(json.decode(data['answers']));
          }
        }
      });

    return answerList;
  }

  @override
  Future<void> setAnswers(String uid, AnswerList answers) {
    db.collection("statistics")
      .doc("answers")
      .update({"quantity": FieldValue.increment(1)});

    return db.collection("user")
      .doc(uid)
      .set({"answers": answers.toJson()}, SetOptions(merge: true));
  }

  // Result: -------------------------------------------------------------------
  @override
  Future<String?> getResult(String uid) async {
    String? result;

    await db.collection("user")
      .doc(uid)
      .get()
      .then((value) {
        if(value.data() != null) {
          final data = value.data() as Map<String, dynamic>;

          result = data['result'];
        }
      });

    return result;
  }

  @override
  Future<double?> getPercentage(String uid) async {
    double? percentage;

    await db.collection("user")
      .doc(uid)
      .get()
      .then((value) {
        if(value.data() != null) {
          final data = value.data() as Map<String, dynamic>;

          percentage = data['percentage'];
        }
      });

    return percentage;
  }

  @override
  Future<void> setResult(String uid, String result) =>
    db.collection("user")
      .doc(uid)
      .set({"result": result}, SetOptions(merge: true));

  @override
  Future<void> setResultPercentage(String uid, double percentage) =>
    db.collection("user")
      .doc(uid)
      .set({"percentage": percentage}, SetOptions(merge: true));

}