import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum Type {
  notebook,
  section,
}

const uuid = Uuid();
final formatter = DateFormat.yMd();

class NoteBook {
  NoteBook({
    required this.userId,
    required this.type,
    required this.name,
    this.listChildIds = const [],
  })  : creationDate = DateTime.now(),
        id = uuid.v4();

  final String userId;
  final String id;
  final Type type;
  final String name;
  final DateTime creationDate;
  List<String> listChildIds;
  

  NoteBook.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        type = parseTypeStatus(json['type']),
        name = json['name'],
        creationDate = DateTime.parse(json['creationDate']),
        listChildIds = List<String>.from(json['listChildIds'] as List<dynamic>);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'type': type.name.toString(),
      'name': name,
      'creationDate': creationDate.toIso8601String(),
      'listChildIds': listChildIds,
    };
  }

  static Type parseTypeStatus(String status) {
    return status == Type.notebook.name ? Type.notebook : Type.section;
  }
}
