import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:simple_todo/model/todo.dart';

void main() => runApp(MyApp());

const mockData = [
  {'id': 1, 'title': 'go to work', 'content': 'Finish Jira tasks'},
  {'id': 2, 'title': 'Have lunch', 'content': 'Have lunch'},
];

class TodoStorage with ChangeNotifier {
  List<Todo> _todos = new List();

  List<Todo> get todos => _todos;

  TodoStorage(this._todos);

  void add(Todo todo) {
    todos.add(todo);
    notifyListeners();
  }

  void remove(Todo todo) {
    todos.removeWhere((Todo t) => t.id == todo.id);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoStorage>(
      builder: (_) => TodoStorage(new List()),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.green,
          ),
          home: MyTodoList()),
    );
  }
}

class MyTodoList extends StatefulWidget {
  @override
  _MyTodoListState createState() => _MyTodoListState();
}

class _MyTodoListState extends State<MyTodoList> {
//  List<Todo> todos = new List<Todo>();

  @override
  Widget build(BuildContext context) {
    TodoStorage storage = Provider.of<TodoStorage>(context);
    var todos = storage?.todos ?? new List();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo list',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => createTodo()),
      body: todos.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: todos.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int index) {
                return viewTodo(todos[index]);
              },
            ),
    );
  }

  createTodo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoCreate()));
  }

  Widget viewTodo(Todo todo) {
    return ListTile(
      leading: CircleAvatar(child: Text(todo.title[0])),
      title: Text(todo.title),
      subtitle: Text(todo.content),
      onTap: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodoDetail(todo: todo)))
          },
    );
  }

  Future<void> getTodos() async {
    await Future.delayed(Duration(seconds: 5));
    TodoStorage storage = Provider.of<TodoStorage>(context);
    mockData.forEach((d) {
      storage.add(new Todo.fromJson(d));
    });
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }
}

class TodoDetail extends StatelessWidget {
  final Todo todo;

  TodoDetail({this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text(todo.content)],
        ),
      ),
    );
  }
}

class TodoCreate extends StatefulWidget {
  @override
  _TodoCreateState createState() => _TodoCreateState();
}

class _TodoCreateState extends State<TodoCreate> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TodoStorage storage = Provider.of<TodoStorage>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidate: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: titleController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              decoration: InputDecoration(labelText: 'Enter title'),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: contentController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              decoration: InputDecoration(labelText: 'Enter content'),
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: Text('Submit'),
              onPressed: () => submitForm(storage),
            )
          ],
        ),
      ),
    );
  }

  submitForm(TodoStorage storage) {
    var title = titleController.value.text;
    var content = contentController.value.text;

    final todo = new Todo(title: title, content: content);
    storage.add(todo);
    Navigator.pop(context);
//    print('todo: $todo');
  }
}
