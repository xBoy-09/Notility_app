import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

enum NoteTag {
  work,
  personal,
  important,
  meeting,
  idea,
  reminder,
  shopping,
  travel,
  study,
  health,
  poetry,
  others,
  task,
  project,
  event,
  goal,
  achievement,
  milestone,
  deadline,
  journal,
  diary,
  reflection,
  quote,
  inspiration,
  motivation,
  aspiration,
  ambition,
  dream,
  wish,
  desire,
  hope,
  expectation,
  plan,
  strategy,
  tactic,
  objective,
  mission,
  vision,
  purpose,
  intent,
  aim,
  target,
  destination,
  journey,
  adventure,
  exploration,
  discovery,
  innovation,
  creativity,
  imagination,
  invention,
  solution,
  problem,
  challenge,
  obstacle,
  barrier,
  difficulty,
  trial,
  test,
  examination,
  assessment,
  evaluation,
  analysis,
  critique,
  review,
  feedback,
  improvement,
  enhancement,
  development,
  progress,
  growth,
  success,
  accomplishment,
  fulfillment,
  satisfaction,
  happiness,
  joy,
  peace,
  tranquility,
  serenity,
  calmness,
  relaxation,
  meditation,
  mindfulness,
  spirituality,
  wellness,
  fitness,
  nutrition,
  diet,
  exercise,
  sport,
  hobby,
  leisure,
  recreation,
  entertainment,
  fun,
  enjoyment,
  pleasure,
  positivity,
  optimism,
  gratitude,
  kindness,
  compassion,
  empathy,
  generosity,
}


final formatter = DateFormat.yMd();
const uuid = Uuid();

class Note {
  Note({
    this.tags,
    required this.content,
    this.heading,
    this.isPinned = false,
    required this.userId,
    required this.route,
    required this.notebook,
    required this.section,
  })  : id = uuid.v4(),
        createdAt = DateTime.now(),
        modifiedAt = DateTime.now();

  final String userId;
  final String id;
  List<NoteTag>? tags;
  String? heading;
  String content;
  final DateTime createdAt;
  DateTime modifiedAt;
  bool isPinned;
  String route; 
  String section; 
  String notebook;

  Note.fromJson(Map<String, dynamic> json) //Converting Json pull to Note
      : id = json['id'],
        userId = json['userId'],
        tags = (json['tags'] as List<dynamic>?)
            ?.map((tag) => NoteTag.values[tag as int])
            .toList(),
        heading = json['heading'],
        content = json['content'],
        createdAt = DateTime.parse(json['createdAt']),
        modifiedAt = DateTime.parse(json['modifiedAt']),
        route = json['route'],
        notebook = json['notebook'],
        section = json['section'],
        isPinned = json['isPinned'];

  Map<String, dynamic> toJson() { // Converting Note to Json when sending to dataBase
    return {
      'id': id,
      'userId': userId,
      'tags': tags?.map((tag) => tag.index).toList(),
      'heading': heading,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'route' : route,
      'notebook' : notebook,
      'section' : section,
      'isPinned': isPinned,
    };
  }
}



