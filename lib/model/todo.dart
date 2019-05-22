
class Todo {
  String title;
  String content;
  int id;

  Todo({this.id, this.title, this.content});

  @override
  String toString() {
    return '$title: $content';
  }

  Todo.fromJson(Map<String, dynamic> data) {
    id = data['id'] as int;
    title = data['title'];
    content = data['content'];
  }
}
