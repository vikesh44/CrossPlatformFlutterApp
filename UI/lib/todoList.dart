import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class todoList extends StatefulWidget {

  todoList() {
    initializeBack4App();
  }

  Future<void> initializeBack4App() async {
    WidgetsFlutterBinding.ensureInitialized();
    final keyApplicationId = 'hOoI6HM0LI94JaXZLVwwRuZlNRkz0zN1w636fcth';
    final keyClientKey = '21bKnetARHhrDOL0J5FmSDDfK2fm3HvmBbPHzjwm';
    final keyParseServerUrl = 'https://parseapi.back4app.com';

    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);
  }

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> {
  late Future<List<ParseObject>> _expensesFuture;
  var password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _expensesFuture = _fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Table'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Implement refresh logic
              setState(() {
                _expensesFuture = _fetchExpenses();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ParseObject>>(
        future: _expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final expenses = snapshot.data ?? [];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _showAddExpenseDialog(context);
                      },
                      child: Icon(Icons.add),
                    ),
                    SizedBox(width: 16.0),
                    FloatingActionButton(
                      onPressed: () {
                        // Implement refresh logic
                        setState(() {
                          _expensesFuture = _fetchExpenses();
                        });
                      },
                      child: Icon(Icons.refresh),
                    ),
                  ],
                ),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Title'),
                    ),
                    DataColumn(
                      label: Text('Description'),
                    ),
                    DataColumn(
                      label: Text('Amount'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: expenses.map((expense) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(expense['Title'] ?? '')),
                        DataCell(Text(expense['Description'] ?? '')),
                        DataCell(Text('\$${expense['Amount'] ?? ''}')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showAddExpenseDialog(context, expense);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteExpense(expense);
                              },
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<ParseObject>> _fetchExpenses() async {
    final queryBuilder = QueryBuilder(ParseObject('ExpenseManager'))
      ..orderByDescending('createdAt');
    final response = await queryBuilder.query();
    if (response.success && response.results != null) {
      return response.results!.cast<ParseObject>();
    } else {
      throw Exception('Failed to fetch expenses');
    }
  }

  Future<void> _addExpense(
      String title, String description, String amount) async {
    final expense = ParseObject('ExpenseManager')
      ..set('Title', title)
      ..set('Description', description)
      ..set('Amount', double.parse(amount));

    final response = await expense.save();
    if (response.success) {
      setState(() {
        _expensesFuture = _fetchExpenses();
      });
    } else {
      print('Failed to add expense: ${response.error!.message}');
    }
  }

  Future<void> _updateExpense(ParseObject expense, String title,
      String description, String amount) async {
    expense.set('Title', title);
    expense.set('Description', description);
    expense.set('Amount', double.parse(amount));

    final response = await expense.save();
    if (response.success) {
      setState(() {
        _expensesFuture = _fetchExpenses();
      });
    } else {
      print('Failed to update expense: ${response.error!.message}');
    }
  }

  Future<void> _deleteExpense(ParseObject expense) async {
    final response = await expense.delete();
    if (response.success) {
      setState(() {
        _expensesFuture = _fetchExpenses();
      });
    } else {
      print('Failed to delete expense: ${response.error!.message}');
    }
  }

  Future<void> _showAddExpenseDialog(BuildContext context,
      [ParseObject? existingExpense]) async {
    TextEditingController titleController =
    TextEditingController(text: existingExpense?['Title'] ?? '');
    TextEditingController descriptionController =
    TextEditingController(text: existingExpense?['Description'] ?? '');
    TextEditingController amountController = TextEditingController(
        text: existingExpense?['Amount']?.toString() ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingExpense != null ? 'Edit Expense' : 'Add Expense'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (existingExpense != null) {
                  _updateExpense(
                    existingExpense,
                    titleController.text,
                    descriptionController.text,
                    amountController.text,
                  );
                } else {
                  _addExpense(
                    titleController.text,
                    descriptionController.text,
                    amountController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(existingExpense != null ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}