import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/server/mongodb.dart' as mongo;
  String parseNotebookName(String route) {
    return route.split('\\').first.trim();
  }

  String parseSectionName(String route) {
    return route.split('\\')[1].trim();
  }


Future createNewuserData(String userId) async {
  NoteBook newNoteBook = NoteBook(
    userId: userId,
    type: Type.notebook,
    name: 'My Notebook',
  );
  var newSection = NoteBook(
    userId: userId,
    type: Type.section,
    name: 'General',
  );
  newNoteBook.listChildIds = [newSection.id];

  Note newNote = Note(
    heading: 'Welcome',
    content: 'Welcome User',
    notebook: 'My Notebook',
    section: 'General',
    route: 'My Notebook \\ General',
    userId: userId,
    isPinned: true,
  );



  var result = await mongo.MongoDatabase.addNewNoteBookOrSection(
    noteBook: newNoteBook,
  );

  print('Notebook added : $result');

  result = await mongo.MongoDatabase.addNewNoteBookOrSection(
    noteBook: newSection,
    noteBookId: newNoteBook.id,
  );
  print('Section added : $result');

  result = await mongo.MongoDatabase.insertNote(newNote, newSection.name);

  print('Note added : $result');

  
}
