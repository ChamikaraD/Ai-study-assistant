import 'package:ai_study_assistant/features/auth/screens/login_account.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';







class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 218, 253),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //icon part
            SizedBox(height: 80,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  Image.asset("assets/images/icon.png"),
                  Text("AI Study Assistant",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 0, 0, 0)
                  ),),
                ],
              ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 63, 152, 254),
                    blurRadius: 6,
                    spreadRadius: 4,
                  ),
                ],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      //create ur acc + back-arrow icon
                      children: [
                        GestureDetector(
                          child: Icon(Icons.arrow_back_ios_new,
                          size: 23,),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 50,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Create Your Account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),),
                            Text("Learn & Save Knowladge With AI",
                            style: TextStyle(
                              color: const Color.fromARGB(255,27, 137, 255),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),)
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            //3 text fiels
                            SizedBox(
                              height: 44,
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  prefixIcon: Icon(Icons.person_2_outlined),
                                  isDense: true,
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 50,
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 22,),
                            SizedBox(
                              height: 44,
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.email_outlined),
                                  isDense: true,
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 50,
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)
                                  )
                                ),
                              ),
                            ),
                            SizedBox(height: 22,),
                            SizedBox(
                              height: 44,
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.lock_outlined),
                                  isDense: true,
                                  prefixIconConstraints: BoxConstraints(
                                    minWidth: 50,
                                  ),
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25)
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: null,
                            side: BorderSide(
                              width: 2,
                            ),),
                            RichText(text: TextSpan(
                              text: "I Agree to ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms ",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255,27, 137, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    //put a navigator here to move terms
                                  }
                                ),
                                TextSpan(
                                  text: "& ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                      )
                                ),
                                TextSpan(
                                  text: "Conditions",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255,27, 137, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                  ..onTap =(){
                                    //put a navigator here to move Conditions
                                  }
                                ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(height: 15,),
                        TextButton(
                          onPressed: (){}, 
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 0, 123, 255) ,
                            foregroundColor: Colors.white,   
                            minimumSize: Size(double.infinity, 44) 
                          ),
                          child: Text("Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),)),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                //indent: 10,
                                thickness: 1,
                                color: Colors.black,
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text("Or Sign with",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),),
                              ),
                              Expanded(
                              child: Divider(
                                endIndent: 10,
                                thickness: 1,
                                color: Colors.black,
                              )),
                          ],
                          
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //google + apple
                          children: [
                            TextButton(
                              onPressed: (){}, 
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255) ,
                                foregroundColor: const Color.fromARGB(255, 0, 0, 0),   
                                minimumSize: Size(170, 44) ,
                              ),
                              child: Row(
                                children: [
                                  Image.asset("assets/images/google.png",
                                  width: 20,),
                                  SizedBox(width: 10,),
                                  Text("Google",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                ],
                              )),
                            TextButton(
                              onPressed: (){}, 
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255) ,
                                foregroundColor: const Color.fromARGB(255, 0, 0, 0),   
                                minimumSize: Size(170, 44) ,
                              ),
                              child: Row(
                                children: [
                                  Image.asset("assets/images/apple.png",
                                  width: 20,),
                                  SizedBox(width: 10,),
                                  Text("Apple",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                ],
                              )),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(text: TextSpan(
                              text: "Already Have an Account ?",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: " Log in ",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255,27, 137, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                 ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (){
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (context)=>LoginAccount()
                                            ));
                                      }
                                  ),

                                ],
                                

                              )
                            )
                          ],
                        ),
                        SizedBox(height: 55,),
                      ],
                    ),
                  )
                ],
              ),
            )
          
        ],
      ),
    );
  }
}