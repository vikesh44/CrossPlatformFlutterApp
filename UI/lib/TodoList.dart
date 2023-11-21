import 'package:expense_manager_ui/TodoDetails.dart';
import 'package:expense_manager_ui/main.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// ignore: camel_case_types
class TodoList extends StatefulWidget {
  TodoList({super.key}) {
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
  State<TodoList> createState() => _TodoListState();
}

// ignore: camel_case_types
class _TodoListState extends State<TodoList> {
  late Future<List<ParseObject>> _todoFuture;

  @override
  void initState() {
    super.initState();
    _todoFuture = getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to block the back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Todo List"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          // Set to false to hide the back button
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Implement refresh logic
                setState(() {
                  _showAddTodoDialog(context);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // Implement refresh logic
                setState(() {
                  _todoFuture = getTodo();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // Implement refresh logic
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MyApp()));
                });
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: FutureBuilder<List<ParseObject>>(
                    future: getTodo(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Center(
                            child: SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator()),
                          );
                        default:
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error..."),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("No Data..."),
                            );
                          } else {
                            return ListView.builder(
                                padding: const EdgeInsets.only(top: 10.0),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  //*************************************
                                  //Get Parse Object Values
                                  final varTodo = snapshot.data?[index];
                                  final varTitle =
                                      varTodo?.get<String>('Title')!;
                                  final varDescription =
                                      varTodo?.get<String>('Description') ?? '';
                                  final varDone = varTodo?.get<bool>('Done')!;
                                  //*************************************

                                  return ListTile(
                                    title: Text(varTitle!),
                                    subtitle: Text(varDescription),
                                    leading: CircleAvatar(
                                      backgroundColor: varDone == true
                                          ? Colors.green
                                          : Colors.blue,
                                      foregroundColor: Colors.white,
                                      child: Icon(varDone == true
                                          ? Icons.check
                                          : Icons.error),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TodoDetails(
                                            title: varTitle,
                                            description: varDescription,
                                            isDone: varDone,
                                          ),
                                        ),
                                      );
                                    },
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            value: varDone,
                                            onChanged: (value) async {
                                              await markComplete(
                                                  varTodo!.objectId!, value!);
                                              setState(() {
                                                //Refresh UI
                                              });
                                            }),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () async {
                                            _showAddTodoDialog(
                                                context, varTodo);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            await deleteTodo(
                                                varTodo!.objectId!);
                                            setState(() {
                                              const snackBar = SnackBar(
                                                content: Text("Todo deleted!"),
                                                duration: Duration(seconds: 2),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }
                      }
                    }))
          ],
        ),
      ),
    );
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Todo'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> saveTodo(String title, String description) async {
    final todo = ParseObject('Todo')
      ..set('Title', title)
      ..set('Description', description)
      ..set('Done', false);
    var response = await todo.save();
    if (response.success) {
      setState(() {
        _todoFuture = getTodo();
      });
    } else {
      print('Failed to add new todo item: ${response.error!.message}');
    }
  }

  Future<void> markComplete(String id, bool done) async {
    var todo = ParseObject('Todo')
      ..objectId = id
      ..set('Done', done);
    var response = await todo.save();

    if (response.success) {
      setState(() {
        _todoFuture = getTodo();
      });
    } else {
      print('Failed to update todo item: ${response.error!.message}');
    }
  }

  Future<void> updateTodo(
      ParseObject todo, String title, String description) async {
    todo.set('Tone', title);
    todo.set('Description', description);
    final response = await todo.save();
    if (response.success) {
      setState(() {
        _todoFuture = getTodo();
      });
    } else {
      print('Failed to update todo item: ${response.error!.message}');
    }
  }

  Future<void> deleteTodo(String id) async {
    var todo = ParseObject('Todo')..objectId = id;
    final response = await todo.delete();
    if (response.success) {
      setState(() {
        _todoFuture = getTodo();
      });
    } else {
      print('Failed to delete todo item: ${response.error!.message}');
    }
  }

  Future<void> _showAddTodoDialog(BuildContext context,
      [ParseObject? todoItem]) async {
    TextEditingController titleController =
        TextEditingController(text: todoItem?['Title'] ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: todoItem?['Description'] ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(todoItem != null ? 'Edit Todo' : 'Add Todo'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (todoItem != null) {
                  updateTodo(
                    todoItem,
                    titleController.text,
                    descriptionController.text,
                  );
                } else {
                  saveTodo(titleController.text, descriptionController.text);
                }
                Navigator.pop(context);
              },
              child: Text(todoItem != null ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
