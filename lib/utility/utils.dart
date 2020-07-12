import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class Utils {
  static String url = "http://192.168.0.108:5000";
  static String login = "/login";
  static String register = "/register";
  static String userlist = "/userlist";
  static String chatiditem = "/createchatID";
  static Map<String, String> map = {"Content-type": "application/json"};
  static String chatlistitem = "/getchatlist/";
  static String clients = "/clients";

  static SocketIO getSocketIO(Function socketStatus) {
    SocketIO socketIO = SocketIOManager()
        .createSocketIO(url, '/', socketStatusCallback: socketStatus);
    socketIO.init();
    socketIO.connect();
    return socketIO;
  }
}
