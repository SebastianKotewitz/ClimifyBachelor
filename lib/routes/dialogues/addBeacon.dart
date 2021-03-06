import 'package:climify/models/api_response.dart';
import 'package:climify/models/beacon.dart';
import 'package:climify/models/buildingModel.dart';
import 'package:climify/services/rest_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class AddBeacon {
  final BuildContext context;
  final String token;
  final BuildingModel building;
  final List<Tuple2<String, String>> beaconList;
  final List<Beacon> alreadyExistingBeacons;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final void Function(int) setBeaconsAdded;
  StatefulBuilder addBeaconDialog;

  RestService _restService;

  AddBeacon(
    this.context, {
    this.token,
    this.beaconList,
    this.alreadyExistingBeacons,
    this.building,
    this.scaffoldKey,
    this.setBeaconsAdded,
  }) {
    _restService = RestService(context);
    List<bool> list = [];
    for (int i = 0; i < beaconList.length; i++) {
      list.add(false);
    }
    int successFullyAddedBeacons = 0;
    addBeaconDialog = StatefulBuilder(
      builder: (context, setState) {
        setState(() {});
        APIResponse<String> apiResponse;
        void _submitBeacon() async {
          for (int i = 0; i < beaconList.length; i++) {
            if (list[i] == true) {
              try {
                apiResponse = await _restService.postBeacon(
                  Tuple2(beaconList[i].item1, beaconList[i].item2),
                  building,
                );
              } catch (e) {
                print(e);
                apiResponse =
                    APIResponse<String>(error: true, errorMessage: "");
              }
              if (apiResponse.error == false) {
                successFullyAddedBeacons = successFullyAddedBeacons + 1;
              }
            }
          }
          setBeaconsAdded(successFullyAddedBeacons);
          Navigator.of(context).pop();
        }

        bool submitEnabled = list.contains(true);

        void updateSelectedBeaconList(int index) async {
          setState(() {
            list[index] = !list[index];
          });
        }

        //return CircularProgressIndicator();
        return SimpleDialog(
          title: Text("Add Beacon"),
          children: <Widget>[
            Container(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: beaconList.length,
                  itemBuilder: (_, int index) {
                    print(beaconList[index]);
                    return InkWell(
                      onTap: () {
                        updateSelectedBeaconList(index);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        color: list[index] == true
                            ? Colors.grey[300]
                            : (alreadyExistingBeacons.any((beacon) =>
                                    beacon.name == beaconList[index].item1)
                                ? Colors.brown[200]
                                : Colors.white),
                        child: ListTile(
                          title: Text(beaconList[index].item1),
                        ),
                      ),
                    );
                  }),
            ),
            RaisedButton(
              color: submitEnabled ? Colors.green : Colors.red,
              child: Text("Submit"),
              onPressed: () => submitEnabled ? _submitBeacon() : null,
            ),
          ],
        );
      },
    );
  }

  StatefulBuilder get dialog => addBeaconDialog;
}
