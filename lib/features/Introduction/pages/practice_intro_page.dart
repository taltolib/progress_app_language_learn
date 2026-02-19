
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class PracticeIntroPage extends StatefulWidget {
  const PracticeIntroPage({super.key});

  @override
  State<PracticeIntroPage> createState() => _PracticeIntroPageState();
}

class _PracticeIntroPageState extends State<PracticeIntroPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation/note_a.json',
                width: 150,
                height: 150,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('a',style: TextStyle(color: Colors.white, fontSize: 20),)
              ]
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('bbbb',style: TextStyle(color: Colors.blueAccent, fontSize: 20),)
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('VVVV',style: TextStyle(color: Colors.green, fontSize: 20),)
            ],
          ),
        ],
      ),
    );
  }
}
