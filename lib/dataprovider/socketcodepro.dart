import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:instaAP/utility/utils.dart';

class SocketItem {
  SocketIO connectSocketIO() {
    SocketIO _socketIO;
    _socketIO = SocketIOManager().createSocketIO(Utils.url, "/connect");
    _socketIO.init();
    _socketIO.connect();
    return _socketIO;
  }

  Future subscribetomessge() async {
    connectSocketIO().subscribe(
      "message",
      (data) {
        print(data);
      },
    );
  }
}
