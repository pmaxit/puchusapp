import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oneui/bloc/auth_provider.dart';

class ImageSplashScreen extends ConsumerStatefulWidget {
  const ImageSplashScreen({super.key});

  @override
  SplashScreenState createState() =>  SplashScreenState();
}

class SplashScreenState extends ConsumerState<ImageSplashScreen> {
  startTime() async {
    final _duration = const Duration(seconds: 2);
    return  Timer(_duration, navigationPage);
  }

  void navigationPage() {
    final currentUser = ref.watch(authProvider.notifier).currentUser;
    if(currentUser !=null){
      Navigator.of(context).pushReplacementNamed('/');}
    else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
  

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Stack(
        fit: StackFit.expand,

        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),

              
          ),

          const Positioned(
            left: 0,
            right: 0,
            top: 150,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Life Journal",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your daily Progress Tracker",
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                   SizedBox(height: 40),
                  Text(
                    "21 days goal. Keep going!",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    )),
                  
                  

                ],
              ),
            )
          )
        ]
      ),
    );
  }
}