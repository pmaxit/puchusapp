import 'package:flutter/material.dart';

class RecordingWidget extends StatelessWidget {
  const RecordingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        
        children: [
         // Record your affirmations
    
         // red button 
    
          // text field
          Text("Record your affirmations", style: Theme.of(context).textTheme.titleMedium,),
          const SizedBox(height: 12.0,),
          Center(child: IconButton(
            icon:  CircleAvatar(
              radius: 30.0,
              child: Icon(Icons.mic, color: Colors.red.shade400, size: 50.0,)),
            onPressed: () {
              // Navigator.pop(context);
            },
          ),),
    
          // progressbar
          const SizedBox(height: 20.0,),
          const Text("00:00:00", style: TextStyle(fontSize: 20.0),),
          const SizedBox(height: 20.0,),
          const LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          
            ],
          
      ),
    );
  }
}