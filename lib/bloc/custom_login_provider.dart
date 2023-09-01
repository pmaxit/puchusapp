import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum CustomLoginStatus{
  privateSpace,
  publicSpace
}

class CustomLogin extends ChangeNotifier{
    
    final String privateSpacePassword = "1234";
    
    
    final List<String> passwords= [];


    CustomLoginStatus _status = CustomLoginStatus.publicSpace;

    CustomLoginStatus get status => _status;

    void checkPassword(String password){
      if(password == privateSpacePassword){
        _status = CustomLoginStatus.privateSpace;
      }
      else{
        _status = CustomLoginStatus.publicSpace;
      }
      notifyListeners();
    }

}

final customLoginProvider= ChangeNotifierProvider<CustomLogin>((ref) => CustomLogin());