import 'package:flutter/material.dart';

import 'model/details.dart';

class AppProvider with ChangeNotifier{
  final Set _addedList = {};
  Set get addedList => _addedList;

  void addTodo(Detail eachRequest){
    addedList.add(eachRequest);
    notifyListeners();
  }

  void removeTodo(Detail eachRequest){
    addedList.remove(eachRequest);
    notifyListeners();
  }
}