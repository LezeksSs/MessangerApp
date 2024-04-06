import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  String token = "";
  // reference our box
  final _myBox = Hive.box('mybox');

  // tun this method if this is the 1st time ever opening this app
  void createInitialData(String token) {
    _myBox.put("token", token);
  }

  // load the data from database
  void loadData() {
    token = _myBox.get("token");
  }

  // update the database
  void updateDataBase(String token) {
    _myBox.put("token", token);
  }

  // delete the data from database
  void deleteData() {
    _myBox.delete("token");
  }

  String getToken() {
    return _myBox.get("token");
  }

}