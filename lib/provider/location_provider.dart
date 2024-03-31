import 'package:flutter/foundation.dart';

class Locationprovider with ChangeNotifier{
  String? _location;
  String? get location => _location;
    String? _location1;
  String? get location1 => _location1;

  void updateLocation(String newLocation){
    _location = newLocation;
    notifyListeners();
}
 void updateLocation1(String newLocation){
    _location1 = newLocation;
    notifyListeners();
}
}