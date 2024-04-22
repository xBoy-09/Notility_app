import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum AccountStatus { active, suspended, banned }

class User {
  User({
    required this.email,
    required this.password,
    required this.username,
    this.fullName = '',
    this.dateOfBirth,
    this.profilePicture = '',
    this.contactInfo = '',
    this.accountStatus = AccountStatus.active,
  })  : userId = uuid.v4(),
        creationDate = DateTime.now(),
        lastLogin = DateTime.now();

  final String userId;
  final String email;
  final String password;
  final String username;
  String fullName;
  final DateTime? dateOfBirth;
  final String profilePicture;
  final String contactInfo;
  final AccountStatus accountStatus;
  final DateTime creationDate;
  final DateTime lastLogin;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profilePicture': profilePicture,
      'contactInfo': contactInfo,
      'accountStatus': accountStatus.toString().split('.').last,
      'creationDate': creationDate.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] ?? '',
        email = json['email'] ?? '',
        password = json['password'] ?? '',
        username = json['username'] ?? '',
        fullName = json['fullName'] ?? '',
        dateOfBirth = json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : null,
        profilePicture = json['profilePicture'] ?? '',
        contactInfo = json['contactInfo'] ?? '',
        accountStatus = parseAccountStatus(json['accountStatus']),
        creationDate = DateTime.parse(json['creationDate']),
        lastLogin = DateTime.parse(json['lastLogin']);


  // Convert image data to string (Base64 encoding)
  String imageToString(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  // Convert string (Base64 encoding) back to image data
  Uint8List stringToImage(String base64String) {
    return base64Decode(base64String);
  }

  static AccountStatus parseAccountStatus(String status) {
    switch (status) {
      case 'active':
        return AccountStatus.active;
      case 'inactive':
        return AccountStatus.banned;
      case 'suspended':
        return AccountStatus.suspended;
      // Handle other cases if needed
      default:
        throw ArgumentError('Invalid account status: $status');
    }
  }
}
