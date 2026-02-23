import 'package:ai_study_assistant/features/auth/screens/create_account.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Splash()
    );
  }
}


class Splash extends StatelessWidget {
  const Splash({super.key});

    Widget getDot({required Color dotColor}){
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 218, 253),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Image.asset("assets/images/icon.png"),
            Text("AI Study Assistant",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: const Color.fromARGB(255, 0, 0, 0)
              ),),
            SizedBox(height: 5,),
            Text("Learn Smarter Wiht AI",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),),
            Spacer(),
            
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                 MaterialPageRoute(builder: (context){
                  return CreateAccount();
                 })
                 );
              },
              child: Container(
                width: 100,
                color: const Color.fromARGB(255, 202, 218, 253),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getDot(dotColor: const Color.fromARGB(255,178, 188, 254)),
                    getDot(dotColor: const Color.fromARGB(255,156, 169, 255)),
                    getDot(dotColor: const Color.fromARGB(255, 142, 156, 254)),
                    getDot(dotColor: const Color.fromARGB(255,128, 145, 254)),
                    SizedBox(height: 80,),
                  ],
                ),
              ),
            )
          ],
      ),),
    );
  }
}




