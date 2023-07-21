import 'package:flutter/material.dart';

class GoalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 150,
        child: Column(
          children: [
            // circle box
            Container(
              width: 30,
              height: 30,
              child: Center(
                child: Text("3",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 15),
            // progress bar
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: 0.5,
                minHeight: 5,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
          ],
        ));
  }
}
