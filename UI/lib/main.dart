import 'package:expense_manager_ui/SignUp.dart';
import 'package:expense_manager_ui/TodoList.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

dynamic non1;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'hOoI6HM0LI94JaXZLVwwRuZlNRkz0zN1w636fcth';
  const keyClientKey = '21bKnetARHhrDOL0J5FmSDDfK2fm3HvmBbPHzjwm';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  autoSendSessionId:
  true;
  debug:
  true;

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  var userName = TextEditingController();
  String msg = "";
  bool hide = true;
  var count = 1;
  Icon icon = const Icon(
    Icons.visibility,
    color: Colors.grey,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
        shadowColor: Colors.red,
        elevation: 11,
        child: Container(
            width: 350,
            height: 350,
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
                          } else {
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
                  child: Text(
                    msg,
                    style: const TextStyle(color: Colors.red, fontSize: 17),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (userName.text.toString() == '' ||
                          password.text.toString() == '') {
                        setState(() {
                          msg = 'Empty User-Name or Password';
                          //print('Query failed: ${response.error?.message}');
                        });
                      } else {
                        Future<void> fetchData() async {
                          final query = QueryBuilder(ParseObject('Auth'))
                            ..whereEqualTo(
                                'Username',
                                userName.text
                                    .toString()) // Replace with your specific column and value
                            ..whereEqualTo(
                                'Password', password.text.toString());

                          try {
                            final response = await query.query();
                            if (response.success && response.results != null) {
                              for (final result in response.results!) {
                                // Access and use the data from the specified column
                                var columnValue1 = result.get('Username');
                                var columnValue2 = result.get('Password');
                                print(
                                    'Data from Back4App, Column: $columnValue1');
                                print(
                                    'Data from Back4App, Column: $columnValue2');

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        // builder: (context) => TodoList()));
                                        builder: (context) => TodoList()));
                              }
                            } else {
                              setState(() {
                                // const AlertDialog(
                                //   title: Text('Error'),
                                //   content: Text('Invalid User-Name or Password'),
                                // );
                                msg = 'Invalid User-Name or Password';
                                print(
                                    'Query failed: ${response.error?.message}');
                              });
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
                        }

                        fetchData();
                      }
                    },
                    child: const Text('Login')),
                Container(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: const Text('Don\'t have Account?'))
              ],
            )),
      ),
    ));
  }
}
