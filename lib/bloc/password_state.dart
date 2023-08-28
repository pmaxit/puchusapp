import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


enum PasswordStateEnum{
  initial,
  correct,
  incorrect
}

class PasswordState extends ChangeNotifier{
  final String password;
  final List<int> passwordList = [];
  PasswordStateEnum _passwordStateEnum = PasswordStateEnum.initial;

  PasswordStateEnum get passwordStateEnum => _passwordStateEnum;

  PasswordState({
    required this.password,
  });

  PasswordState copyWith({
    String? password,
  }) {
    return PasswordState(
      password: password ?? this.password,
    );
  }

  void addToPassword(int number){
    passwordList.add(number);
    // check if password is correct

    print(" password $passwordList");

    if(passwordList.length < 4){
      return;
    }

    if(passwordList.length == 4){
      // check if password is correct
      String passwordToCheck = passwordList.join('');
      if(passwordToCheck == password){
        // password is correct
        // go to next page
        // reset password
        _passwordStateEnum = PasswordStateEnum.correct;
    }else{
      // password is incorrect
      // reset password
      _passwordStateEnum = PasswordStateEnum.incorrect;
    }
    }
    
    notifyListeners();
  }

  
}


// provider
final passwordProvider = ChangeNotifierProvider<PasswordState>((ref) {
  return PasswordState(password: '1234');
});
