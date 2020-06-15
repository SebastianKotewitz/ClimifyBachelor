import 'package:climify/models/api_response.dart';
import 'package:climify/models/globalState.dart';
import 'package:climify/models/questionAndFeedback.dart';
import 'package:climify/routes/viewFeedback.dart';
//import 'package:climify/models/feedbackQuestion.dart';
import 'package:climify/styles/textStyles.dart';
import 'package:climify/widgets/roundedBox.dart';
import 'package:flutter/material.dart';
import 'package:climify/models/feedbackQuestion.dart';
import 'package:climify/models/roomModel.dart';

import 'package:climify/services/rest_service.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ViewAnsweredQuestionsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String token;

  const ViewAnsweredQuestionsWidget({
    Key key,
    @required this.scaffoldKey, this.token,
  }) : super(key: key);

  @override
  ViewAnsweredQuestionsWidgetState createState() => ViewAnsweredQuestionsWidgetState();
}

class ViewAnsweredQuestionsWidgetState extends State<ViewAnsweredQuestionsWidget> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _token;
  RestService _restService = RestService();
  List<QuestionAndFeedback> _feedbackList = <QuestionAndFeedback>[];
  List<QuestionAndFeedback> _tempFeedbackList = <QuestionAndFeedback>[];
  String _t = "week";
  
  @override
  void initState() {
    super.initState();
    _scaffoldKey = widget.scaffoldKey;
    _token = widget.token;
    _getFeedback();
  }

  Future<void> _getFeedback() async {
    await Future.delayed(Duration.zero);
    APIResponse<List<QuestionAndFeedback>> response = 
      await _restService.getFeedback(_token, "me", _t);
    if (response.error) return;
    response.data = response.data.reversed.toList();
    for (int i = 0; i < response.data.length; i++) {
      if (_tempFeedbackList.length == 0) {
        _tempFeedbackList.add(response.data[i]);
      } else {
        for (int j = 0; j < _tempFeedbackList.length; j++) {
          if (_tempFeedbackList[j].question.id == response.data[i].question.id) {
            break;
          } else if (j == (_tempFeedbackList.length - 1)) {
            _tempFeedbackList.add(response.data[i]);
          }
        }
      }
    }
    setState(() {
      _feedbackList = response.data;
      _tempFeedbackList = _tempFeedbackList;
    });
  }

  void _focusFeedback(QuestionAndFeedback feedback) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => 
        ViewFeedbackWidget(
          scaffoldKey: _scaffoldKey, 
          feedback: feedback,
          feedbackList: _feedbackList,
        )
      ),
    );
  }

  void setT(String t) {
    setState(() {
      _t = t;
    });
    _getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () => _getFeedback(),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height/10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/6,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: RoundedBox(
                      onTap: () => setT("hour"),
                      decoration: BoxDecoration(
                        color:  "hour" == _t
                          ? Colors.blue
                          : Colors.transparent,
                      ),
                      child: Container(
                        child: Center(
                          child: Text(
                            "hour",
                            style: TextStyles.optionStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/6,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: RoundedBox(
                      onTap: () => setT("day"),
                      decoration: BoxDecoration(
                        color:  "day" == _t
                          ? Colors.blue
                          : Colors.transparent,
                      ),
                      child: Container(
                        child: Center(
                          child: Text(
                            "day",
                            style: TextStyles.optionStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/6,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: RoundedBox(
                      onTap: () => setT("week"),
                      decoration: BoxDecoration(
                        color:  "week" == _t
                          ? Colors.blue
                          : Colors.transparent,
                      ),
                      child: Container(
                        child: Center(
                          child: Text(
                            "week",
                            style: TextStyles.optionStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/6,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: RoundedBox(
                      onTap: () => setT("month"),
                      decoration: BoxDecoration(
                        color:  "month" == _t
                          ? Colors.blue
                          : Colors.transparent,
                      ),
                      child: Container(
                        child: Center(
                          child: Text(
                            "month",
                            style: TextStyles.optionStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width/6,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: RoundedBox(
                      onTap: () => setT("year"),
                      decoration: BoxDecoration(
                        color:  "year" == _t
                          ? Colors.blue
                          : Colors.transparent,
                      ),
                      child: Container(
                        child: Center(
                          child: Text(
                            "year",
                            style: TextStyles.optionStyle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //_tempFeedbackList.length == 0
            Container(
              child: Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  itemCount: _tempFeedbackList.length,
                  itemBuilder: (_, index) => _buildingRow(_tempFeedbackList[index], index),
                ),
              ),
            )
            //: Container(),
          ],
        ),
      ),
    );
  }


  Widget _buildingRow(QuestionAndFeedback feedback, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        )
      ),
      child: Material(
        child: InkWell(
          onTap: () => _focusFeedback(feedback),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              feedback.question.value + "\n"
              "Last answered: " + feedback.updatedAt
              ,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}