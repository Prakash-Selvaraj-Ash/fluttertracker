import 'package:bus_tracker_client/src/webclient/web_client_base.dart';
import 'package:signalr_client/signalr_client.dart';

typedef MethodInvacationFunc = void Function(List<Object> arguments);

class SignalrServices extends WebClientBase {
  final routePrefix = "broadCast";
  HubConnection _hubConnection;
  

  initialize(MethodInvacationFunc onBroadCast) {
    final url = "${baseUrl}/${routePrefix}";
    _hubConnection = HubConnectionBuilder().withUrl(url).build();
    _hubConnection.onclose((error) => print("Connection Closed"));
    _hubConnection.on('BroadCastTrack', onBroadCast);
  }

  start(String userId) async {
    if (_hubConnection == null) {
      return;
    }

    await _hubConnection.start();
    await _hubConnection.invoke('MapUserAndConnection', args:<Object>[userId]);
  }
  close(){
    _hubConnection.stop();
  }
}
