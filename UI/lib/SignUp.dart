import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// ignore: camel_case_types
class SignUp extends StatefulWidget {

  SignUp({super.key}) {
    initializeBack4App();
  }

  Future<void> initializeBack4App() async {
    WidgetsFlutterBinding.ensureInitialized();
    const keyApplicationId = 'hOoI6HM0LI94JaXZLVwwRuZlNRkz0zN1w636fcth';
    const keyClientKey = '21bKnetARHhrDOL0J5FmSDDfK2fm3HvmBbPHzjwm';
    const keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);
  }

  @override
  State<SignUp> createState() => _signUpState();
}

// ignore: camel_case_types
class _signUpState extends State<SignUp> {

  var password = TextEditingController();
  var userName = TextEditingController();
  String msg = "";
  bool hide = true;
  var count = 1;
  var icon = const Icon(
    Icons.visibility,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
        ),
        body: Center(
          child: Card(
            shadowColor: Colors.red,
            elevation: 11,
            child: Container(
                width: 350,
                height: 300,
                //padding: const EdgeInsets.all(11),
                padding: const EdgeInsets.fromLTRB(11, 11, 11, 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: userName,
                      decoration: InputDecoration(
                        // this is use to give decorations in our text field
                          hintText: 'User-Name', // this is use to  give hint
                          enabledBorder: OutlineInputBorder(
                            // this is use when our text field is unfocused
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.blue)),
                          focusedBorder: const OutlineInputBorder(
                            // this is use when our text field is focused
                              borderSide: BorderSide(
                                // in this we can control the animations of border sides
                                color: Colors.red,
                                width: 3,
                              )),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.black,
                          )),
                    ),
                    Container(
                      height: 20,
                    ),
                    TextField(
                      obscureText: hide,
                      // this is use to hide our text field
                      obscuringCharacter: '*',
                      //this is use to give hidden char symbol
                      controller: password,
                      // this is for to retrieve text from user, password is predefine by us
                      decoration: InputDecoration(
                        // this is use to give decorations in our text field
                        hintText: 'Enter password',
                        // this is use to  give hint
                        enabledBorder: OutlineInputBorder(
                          // this is use when our text field is unfocused
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.blue)),
                        focusedBorder: const OutlineInputBorder(
                          // this is use when our text field is focused
                            borderSide: BorderSide(
                              // in this we can control the animations of border sides
                              color: Colors.red,
                              width: 3,
                            )),

                        //suffixText: 'hello ' // this is use to give something at the last of text field
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),

                        suffixIcon: IconButton(
                          icon: icon,
                          onPressed: () {
                            setState(() {
                              if (count % 2 != 0) {
                                hide = false;
                                icon = const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                );
                                count++;
                              }
                              else {
                                hide = true;
                                icon = const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                );
                                count++;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(msg,
                        style: const TextStyle(color: Colors.red, fontSize: 17),),
                    ),

                    ElevatedButton(
                        onPressed: () async {

                          if (userName.text.toString() == '' || password.text.toString() == ''){
                            setState(() {
                              msg = 'Empty User-Name or Password';
                              //print('Query failed: ${response.error?.message}');
                            });
                          }
                          else {
                            var firstObject = ParseObject('Auth')
                              ..set('Username', userName.text.toString())..set(
                                  'Password', password.text.toString());
                            await firstObject.save();

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }},
                        child: const Text('SignUp')),
                    Container(
                      height: 20,
                    ),

                  ],
                )),
          ),
        )
    );
  }
}