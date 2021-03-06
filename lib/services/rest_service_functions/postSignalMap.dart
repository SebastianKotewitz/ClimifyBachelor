part of 'package:climify/services/rest_service.dart';

Future<APIResponse<String>> postSignalMapRequest(
  BuildContext context,
  SignalMap signalMap,
  String roomId,
) {
  final String body = json.encode({
    'beacons': signalMap.beacons,
    'roomId': roomId,
    'buildingId': signalMap.buildingId,
  });
  return RestService.requestServer(
    context,
    fromJson: (_) {
      return "Scan added";
    },
    body: body,
    requestType: RequestType.POST,
    route: '/signalMaps',
  );
}