import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gd5_a_1413/database/sql_helper.dart';
import 'package:gd5_a_1413/entity/employee.dart';
import 'package:gd5_a_1413/inputPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SQFLITE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> employee = [];

  void refresh() async {
    final data = await SQLHelper.getEmployee();
    setState(() {
      employee = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EMPLOYEE"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const InputPage(
                        title: 'INPUT EMPLOYEE',
                        id: null,
                        name: null,
                        email: null,
                        hobi: null)),
              ).then((_) => refresh());
            },
          ),
          IconButton(icon: Icon(Icons.clear), onPressed: () async {})
        ],
      ),
      body: ListView.builder(
        itemCount: employee.length,
        itemBuilder: (context, index) {
          return Slidable(
              child: ListTile(
                title: Text(employee[index]['name']),
                subtitle: Text(
                    employee[index]['email'] + '\n' + employee[index]['hobi']),
              ),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                IconSlideAction(
                  caption: 'Update',
                  color: Colors.blue,
                  icon: Icons.update,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputPage(
                              title: 'INPUT EMPLOYEE',
                              id: employee[index]['id'],
                              name: employee[index]['name'],
                              email: employee[index]['email'],
                              hobi: employee[index]['hobi'])),
                    ).then((_) => refresh());
                  },
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    await deleteEmployee(employee[index]['id']);
                  },
                )
              ]);
        },
      ),
    );
  }

  Future<void> deleteEmployee(int id) async {
    await SQLHelper.deleteEmployee(id);
    refresh();
  }
}
