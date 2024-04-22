import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

class Users {
  Users({required this.email, required this.uid, this.sharedNotes = const []});

  final String email;
  final String uid;
  List<String>? sharedNotes;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'sharedNotes': sharedNotes,
      'uid': uid,
    };
  }

  Users.fromJson(Map<String, dynamic> json)
      : email = json['email'] ?? '',
        uid = json['uid'] ?? '',
        sharedNotes = json['sharedNotes'] != null
            ? List<String>.from(json['sharedNotes'] as List<dynamic>)
            : null;
}
