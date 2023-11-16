import 'package:expense_manager_ui/todoList.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'hOoI6HM0LI94JaXZLVwwRuZlNRkz0zN1w636fcth';
  final keyClientKey = '21bKnetARHhrDOL0J5FmSDDfK2fm3HvmBbPHzjwm';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Expense Table',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  //keyboardType: TextInputType.number, // this is use to change the keyboard type
                  // decoration: InputDecoration(
                  //   // this is use to give decorations in our text field
                  //     border: OutlineInputBorder(
                  //       // this is use to give outline to our text field
                  //         borderRadius: BorderRadius.circular(30))),
                  decoration: InputDecoration(
                      // this is use to give decorations in our text field
                      hintText: 'User-Name', // this is use to  give hint
                      enabledBorder: OutlineInputBorder(
                          // this is use when our text field is unfocused
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.blue)),
                      focusedBorder: OutlineInputBorder(
                          // this is use when our text field is focused
                          borderSide: BorderSide(
                        // in this we can control the animations of border sides
                        color: Colors.red,
                        width: 3,
                      )),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      )

                      //suffixText: 'hello ' // this is use to give something at the last of text field
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.remove_red_eye, color: Colors.black,),
                      //   onPressed: (){
                      //
                      //   },
                      // ),

                      ),
                ),
                Container(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
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
                        borderSide: BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        // this is use when our text field is focused
                        borderSide: BorderSide(
                      // in this we can control the animations of border sides
                      color: Colors.red,
                      width: 3,
                    )),

                    //suffixText: 'hello ' // this is use to give something at the last of text field
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => todoList()));
                    },
                    child: Text('login'))
              ],
            )),
      ),
    );
  }
}
