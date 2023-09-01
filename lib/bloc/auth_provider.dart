import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/models/models.dart';

import '../services/firestore_database.dart';


enum Status{
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Registering
}

/*
The UI will depends on the Status to decide which screen/action to be done.

- Uninitialized - Checking user is logged or not, the Splash Screen will be shown
- Authenticated - User is authenticated successfully, Home Page will be shown
- Authenticating - Sign In button just been pressed, progress bar will be shown
- Unauthenticated - User is not authenticated, login page will be shown
- Registering - User just pressed registering, progress bar will be shown

Take note, this is just an idea. You can remove or further add more different
status for your UI or widgets to listen.
 */

class AuthProvider extends ChangeNotifier{
    late FirebaseAuth _auth;

    // default status
    Status _status = Status.Uninitialized;

    Status get status => _status; 

    // get current User
    User? get currentUser => _auth.currentUser;


    AuthProvider(){
      // initialize object
      _auth = FirebaseAuth.instance;

      // listener for authentication changes such as user sign in and sign out
      _auth.authStateChanges().listen(onAuthStateChanged);
    }

    Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);


    // Create user object based on the given user
    UserModel _userFromFirebase(User? user){
      if(user == null){
        return UserModel(uid: '');
      }
      return UserModel(uid: user.uid, 
        email: user.email,
        name: user.displayName,
        phoneNumber: user.phoneNumber,
        imageUrl: user.photoURL
      );
    }

    Future<void> onAuthStateChanged(User? firebaseUser) async{
      if(firebaseUser == null){
        _status = Status.Unauthenticated;
      }else{
        _status = Status.Authenticated;
      }
      notifyListeners();
    }

    Future<UserModel> registerWithEmailAndPassword(String email, String password ) async{
      try{
        _status = Status.Registering;
        notifyListeners();
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        User? firebaseUser = result.user;
        return _userFromFirebase(firebaseUser);
      }catch(e){
        _status = Status.Unauthenticated;
        notifyListeners();
        return UserModel(uid: '');
      }
      
    }

    // Method to handle user sign in using email and password
    Future<bool> signInWithEmailAndPassword(String email, String password) async{

      try{
        _status = Status.Authenticating;
        notifyListeners();
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return true;
      }catch(e){
        _status = Status.Unauthenticated;
        notifyListeners();
        return false;
      }
    }


}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

final firebaseDBProvider = Provider<FirestoreDatabase>((ref) => FirestoreDatabase(uid: ref.watch(authProvider).currentUser!.uid));


final currentUserProvider = Provider<UserModel>((ref){ 
  
  
  final user = ref.watch(authProvider).currentUser!;
  final newUser = UserModel(uid: user.uid, 
        email: user.email,
        name: user.displayName,
        phoneNumber: user.phoneNumber,
        imageUrl: user.photoURL
      );

    return newUser;
  });
