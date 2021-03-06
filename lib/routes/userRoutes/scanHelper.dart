import 'package:climify/models/api_response.dart';
import 'package:climify/models/buildingModel.dart';
import 'package:climify/models/feedbackQuestion.dart';
import 'package:climify/models/roomModel.dart';
import 'package:climify/services/bluetooth.dart';
import 'package:climify/services/rest_service.dart';
import 'package:climify/services/snackbarError.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ScanHelper {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String token;
  final BuildContext context;

  ScanHelper(
    this.context, {
    @required this.scaffoldKey,
    @required this.token,
  }) {
    _restService = RestService(context);
    _bluetooth = BluetoothServices(context);
  }

  BluetoothServices _bluetooth;
  RestService _restService;
  BuildingModel _building;
  RoomModel _room;
  List<FeedbackQuestion> _questions;

  Future<_Result> scanBuildingAndRoom({
    bool resetBuilding = false,
  }) async {
    if (_building == null || resetBuilding) {
      await _getBuildingAndRoomScan();
    } else {
      await _getAndSetRoom();
    }
    await getActiveQuestions();
    return _Result(
      _building,
      _room,
      _questions,
    );
  }

  Future<void> _getBuildingAndRoomScan() async {
    APIResponse<Tuple2<BuildingModel, RoomModel>> apiResponse =
        await _bluetooth.getBuildingAndRoomFromScan(token);
    if (!apiResponse.error) {
      _building = apiResponse.data.item1;
      _room = apiResponse.data.item2;
    } else {
      SnackBarError.showErrorSnackBar(apiResponse.errorMessage, scaffoldKey);
    }
    return;
  }

  Future<void> _getAndSetRoom() async {
    APIResponse<RoomModel> apiResponse =
        await _bluetooth.getRoomFromBuilding(_building, token);
    if (!apiResponse.error) {
      _room = apiResponse.data;
    } else {
      SnackBarError.showErrorSnackBar(apiResponse.errorMessage, scaffoldKey);
    }
    return;
  }

  Future<List<FeedbackQuestion>> getActiveQuestions() async {
    if (_room == null) {
      return [];
    }
    APIResponse<List<FeedbackQuestion>> apiResponseQuestions =
        await _restService.getActiveQuestionsByRoom(_room.id, token);
    if (!apiResponseQuestions.error) {
      _questions = apiResponseQuestions.data;
      return _questions;
    }
    SnackBarError.showErrorSnackBar(
      apiResponseQuestions.errorMessage,
      scaffoldKey,
    );
    return [];
  }
}

class _Result {
  final BuildingModel building;
  final RoomModel room;
  final List<FeedbackQuestion> questions;

  _Result(
    this.building,
    this.room,
    this.questions,
  );
}
