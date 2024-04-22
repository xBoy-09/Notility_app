import 'dart:developer';

import 'package:notility/models/note.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/models/user.dart';
import 'package:notility/models/user_share.dart';
import 'package:notility/server/connection.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

enum Type {
  notebook,
  section,
}

class MongoDatabase {
  static var db,
      userCollection,
      notesCollection,
      notebookCollection,
      usershareCollection;

  static connect() async {
    // Connect to the db
    try {
      db = await Db.create(MONGO_CONN_URL);
      await db.open();
      inspect(db);
      userCollection = db.collection(USER_COLLECTION);
      notesCollection = db.collection(NOTES_COLLECTION);
      notebookCollection = db.collection(NOTEBOOK_COLLECTION);
      usershareCollection = db.collection(USERSHARE_COLLECTION);
    } catch (e) {
      print("Connection Failure: $e");
      throw Exception("Connection Failure");
    }
  }

  static Future<String> insertNote(Note note, String sectionName) async {
    // Insert a note
    try {
      var result = await MongoDatabase.notesCollection.insertOne(note.toJson());
      var resultSection = await MongoDatabase.notebookCollection
          .findOne(where.eq('name', sectionName));

      NoteBook section = NoteBook.fromJson(resultSection);

      if (section == null) {
        print('Section not found');
      } else {
        print('Section name: ${section.name}');
      }
      section.listChildIds.add(note.id);
      var resultUpdate = await MongoDatabase.notebookCollection.updateOne(
          where.eq("name", section.name),
          modify.set('listChildIds', section.listChildIds));
      print('updated count : ${resultUpdate.nModified}');

      return result.isSuccess
          ? "Data Inserted"
          : "Something Wrong while inserting data";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<bool> deleteNote({
    // Delete a note with NoteId
    required String noteId,
  }) async {
    try {
      var result =
          await MongoDatabase.notesCollection.deleteOne(where.eq("id", noteId));
      return result.isSuccess ? true : false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<String> updateNote({
    // Update any component of a note {heading, content, pinned val}
    required String noteId,
    String? heading,
    String? content,
    String? route,
    String? notebook,
    String? section,
    bool? isPinned,
  }) async {
    try {
      var resultFind;
      if (heading != null) {
        resultFind = await notesCollection.updateOne(
            where.eq("id", noteId),
            modify
                .set("heading", heading)
                .set("route", route)
                .set("notebook", notebook)
                .set("section", section)
                .set("modifiedAt", DateTime.now().toIso8601String()));
      }
      if (content != null) {
        resultFind = await notesCollection.updateOne(
            where.eq('id', noteId),
            modify
                .set('content', content)
                .set("route", route)
                .set("notebook", notebook)
                .set("section", section)
                .set("modifiedAt", DateTime.now().toIso8601String()));
      }
      if (isPinned != null) {
        resultFind = await notesCollection.updateOne(
            where.eq("id", noteId),
            modify
                .set("isPinned", isPinned)
                .set("route", route)
                .set("notebook", notebook)
                .set("section", section));
      }
      return resultFind.nMatched == 1
          ? "Updated Successfully"
          : "Something went wrong in updating";
    } catch (e) {
      print("Error while updating Notes : $e");
      return e.toString();
    }
  }

  static Future<String> updateTags({
    // Updating tags of the note
    required String noteId,
    required List<NoteTag> tags,
  }) async {
    try {
      var resultFind;
      resultFind = await notesCollection.updateOne(
        where.eq("id", noteId),
        modify.set(
          "tags",
          tags.map((tag) => tag.index).toList(),
        ),
      );
      return resultFind.nMatched == 1
          ? "Updated Successfully"
          : "Something went wrong in updating";
    } catch (e) {
      print("Error while updating Note Tags : $e");
      return e.toString();
    }
  }

  static Future<List<Note>> getAllNotesForUser({
    // Getting All notes for a user
    required String userId,
    required String sort,
  }) async {
    try {
      var resultFind = await notesCollection
          .find(where.eq('userId', userId).sortBy(sort, descending: true))
          .toList();
      final List<Note> notes = [...resultFind.map((doc) => Note.fromJson(doc))];
      return notes;
    } catch (e) {
      print(e.toString());
      return Future.value(<Note>[]);
    }
  }

  static Future<Note> getNote({
    //Get a single note using noteId
    required String noteId,
  }) async {
    try {
      var resultFind =
          await notesCollection.findOne(where.eq('id', noteId)).toList();
      final notes = resultFind.map((doc) => Note.fromJson(doc));
      return notes;
    } catch (e) {
      print(e.toString());
      return Future.value(Note(
        notebook: '',
        section: '',
        route: '',
        content: "",
        userId: '0',
      ));
    }
  }

  static Future<User?> getUserInfo({required userId}) async {
    try {
      var resultFind = await userCollection.findOne(where.eq('userId', userId));

      final User user = User.fromJson(resultFind);
      return user;
    } catch (e) {
      print('Error getting User Info : ${e.toString()}');
      return null;
    }
  }

  static Future<String> updateUserFeild({
    required userId,
    required updateFeild,
    upadteInput,
  }) async {
    var resultFind;
    try {
      if (updateFeild == "lastLogin") {
        resultFind = await userCollection.updateOne(where.eq('userId', userId),
            modify.set('lastLogin', DateTime.now().toIso8601String()));
      } else {
        resultFind = await userCollection.updateOne(
            where.eq('userId', userId), modify.set(updateFeild, upadteInput));
      }
      return resultFind.nMatched == 1
          ? "Updated Successfully"
          : "Something went wrong in updating";
    } catch (e) {
      print("Error while updating user info : ${e.toString()}");
      return e.toString();
    }
  }

// Getting Pinned notes for User.
// Can be set to limit 3 or all
  static Future<List<Note>> getPinnedNotesForUser({
    required String userId,
    bool limit = false,
  }) async {
    try {
      var resultFind = limit
          ? await notesCollection
              .find(where
                  .eq('userId', userId)
                  .eq('isPinned', true)
                  .sortBy('modifiedAt', descending: true)
                  .limit(3))
              .toList()
          : await notesCollection
              .find(where
                  .eq('userId', userId)
                  .eq('isPinned', true)
                  .sortBy('modifiedAt', descending: true))
              .toList();

      final List<Note> notes = [...resultFind.map((doc) => Note.fromJson(doc))];
      return notes;
    } catch (e) {
      print("Error while getting Pinned Notes : $e");
      return Future.value(<Note>[]);
    }
  }

// Get limited recent notes
  static Future<List<Note>> getRecentNotesForUser({
    required String userId,
    required int limit,
  }) async {
    try {
      var resultFind = await notesCollection
          .find(
            where
                .eq('userId', userId)
                .sortBy('modifiedAt', descending: true)
                .limit(limit),
          )
          .toList();
      final List<Note> notes = [
        ...resultFind.map((doc) => Note.fromJson(doc as Map<String, dynamic>))
      ];
      return notes;
    } catch (e) {
      print("Error while getting Recent Notes : $e");
      return <Note>[];
    }
  }

  static Future<String> addSectionInNotebookList({
    required String notebookId,
    required String sectionid,
  }) async {
    try {
      var result = await notebookCollection.findOne(where.eq('id', notebookId));
      var notebook = NoteBook.fromJson(result as Map<String, dynamic>);
      notebook.listChildIds.add(sectionid);
      var resultFind = await notebookCollection.replaceOne(
          where.eq('id', notebookId), notebook.toJson());
      print(resultFind.nMatched);
      return 'Successful';
    } catch (e) {
      print('Error adding new Section to Notebook list: ${e.toString()}');
      return e.toString();
    }
  }

  static Future<String> addNewNoteBookOrSection({
    required NoteBook noteBook,
    String?
        noteBookId, // is section is given, we need to add section to the notebook list too
  }) async {
    try {
      final WriteResult result =
          await notebookCollection.insertOne(noteBook.toJson());
      if (noteBookId != null) {
        addSectionInNotebookList(
            notebookId: noteBookId, sectionid: noteBook.id);
      }

      if (result.nInserted == 1) {
        return 'Successfull';
      } else {
        return 'Error Occured';
      }
    } catch (e) {
      print('Error adding new Notebook: ${e.toString()}');
      return e.toString();
    }
  }

  static Future<List<NoteBook>> getNoteBookOrSectionForUser({
    required String userId,
    required Type type,
    List<String>? sections,
  }) async {
    try {
      final result = sections == null
          ? await notebookCollection
              .find(
                where
                    .eq('userId', userId)
                    .eq('type', type.name)
                    .sortBy('creationDate', descending: true),
              )
              .toList()
          : await notebookCollection.find({
              'id': {r'$in': sections}
            }).toList();
      final List<NoteBook> notebooks = [
        ...result.map((doc) => NoteBook.fromJson(doc as Map<String, dynamic>))
      ];
      return notebooks;
    } catch (e) {
      print('Error getting Notebook for User: ${e.toString()}');
      return <NoteBook>[];
    }
  }

  static Future<String> chnageSectionForNote({
    required String noteId,
    required String oldSectionName,
    required String newSectionName,
  }) async {
    try {
      var result =
          await notebookCollection.findOne(where.eq('name', newSectionName));
      NoteBook section = NoteBook.fromJson(result as Map<String, dynamic>);
      result =
          await notebookCollection.findOne(where.eq('name', oldSectionName));
      NoteBook oldSection = NoteBook.fromJson(result as Map<String, dynamic>);
      oldSection.listChildIds.remove(noteId);
      section.listChildIds.add(noteId);

      var resultUpdate = await notebookCollection.updateOne(
          where.eq("name", oldSection.name),
          modify.set('listChildIds', oldSection.listChildIds));
      print(
          'old updated count : ${resultUpdate.nModified} of oldSection Name : ${oldSection.name}');

      resultUpdate = await notebookCollection.updateOne(
          where.eq("name", section.name),
          modify.set('listChildIds', section.listChildIds));
      print(
          'new updated count : ${resultUpdate.nModified} of new Section name : ${section.name}');
      return 'Successful';
    } catch (e) {
      print('Error chnaging route : ${e.toString()}');
      return e.toString();
    }
  }

  static Future<void> addRouteToNotes() async {
    try {
      final notes = await notesCollection.find().toList();

      for (var note in notes) {
        var route = note['route'] as String;
        var modifiedRoute = route.replaceAll('/', '\\');

        // Update the route in the note object
        note['route'] = modifiedRoute;

        // Update the record in the database
        await notesCollection.update(
          where.eq('id', note['id']),
          note,
        );
      }
    } catch (e) {
      print('Error updating Mongo: $e');
    }
  }

  // gets a list of all emails
  static Future<List<String>> getAllEmails() async {
    try {
      var resultFind = await usershareCollection.find().toList();

      List<String> lol = [];
      for (var user in resultFind) {
        var email = user['email'] as String;
        lol.add(email);
      }

      return lol;
    } catch (e) {
      print('Error getting emails from usershare collection: $e');
      return <String>[];
    }
  }

  // adds shared note to list
  static Future<String> addSharedNoteId(String email, String noteId) async {
    try {
      var userDocument = await usershareCollection.findOne({'email': email});
      var user = Users.fromJson(userDocument as Map<String, dynamic>);

      if (user.sharedNotes != null) {
        // if notes alr shared
        if (!user.sharedNotes!.contains(noteId)) {
          // if not alr shared add
          user.sharedNotes!.add(noteId);
          await usershareCollection.updateOne(
            {'email': email},
            {'\$set': user.toJson()},
          );
        } else {
          return "Note already shared with user!";
        }
      } else {
        user.sharedNotes = [noteId];
        await usershareCollection.updateOne(
          {'email': email},
          {'\$set': user.toJson()},
        );
      }
      return ('Note shared with user $email');
    } catch (e) {
      return ('Error sharing note: $e');
    }
  }

  // removes shared note from the list
  static Future<String> removeSharedNoteId(String email, String noteId) async {
    try {
      var userDocument = await usershareCollection.findOne({'email': email});
      var user = Users.fromJson(userDocument as Map<String, dynamic>);

      if (user.sharedNotes != null) {
        // if notes alr shared, remocve
        if (user.sharedNotes!.contains(noteId)) {
          user.sharedNotes!.remove(noteId);
          await usershareCollection.updateOne(
            {'email': email},
            {'\$set': user.toJson()},
          );
          return ('Note successfully unshared with user $email');
        } else {
          return "Note not shared with user!";
        }
      } else {
        return "Note not shared with user!";
      }
    } catch (e) {
      return ('Error unsharing note: $e');
    }
  }

  // creqates a new entry when a new user registers
  static Future<void> createNewEntry(String email, String uid) async {
    try {
      final newEntry = Users(
        email: email,
        uid: uid,
        sharedNotes: [],
      );

      // Insert the new document into the usershare collection
      await usershareCollection.insert(newEntry.toJson());

      print('New entry created in usershare collection.');
    } catch (e) {
      print('Error creating new entry: $e');
    }
  }

  // updates the email
  static Future<void> updateEntry(String email, String uid) async {
    try {
      // Insert the new document into the usershare collection
      var userDocument = await usershareCollection.findOne({'uid': uid});
      var user = Users.fromJson(userDocument as Map<String, dynamic>);

      if (user.email != email) {
        await usershareCollection.deleteOne({'uid': uid});
        final newEntry = Users(
          email: email,
          uid: user.uid,
          sharedNotes: user.sharedNotes,
        );
        await usershareCollection.insert(newEntry.toJson());
        print('New entry created in usershare collection.');
      } else
        print("no need to update.");
      return;
    } catch (e) {
      print('Error creating new entry: $e');
      return;
    }
  }

  // gets all the shared notes of a user
  static Future<List<Note>> getSharedNotes({
    required String uid,
  }) async {
    try {
      // print("here");
      // print(uid);
      var userDocument = await usershareCollection.findOne({'uid': uid});
      var user = Users.fromJson(userDocument as Map<String, dynamic>);
      // print("here");

      List<Note> notess = [];

      if (user.sharedNotes != null) {
        for (var notes in user.sharedNotes!) {
          // print(notes);\
          var resultF = await notesCollection.findOne({'id': notes});
          if (resultF != null) {
            var nute = Note.fromJson(resultF);
            notess.add(nute);
          } else {
            print("that note doesnt exist.");
          }
        }

        return notess;
      }

      return <Note>[];
    } catch (e) {
      print("Error while getting Shared Notes : $e");
      return <Note>[];
    }
  }

  // gets note maker (kinda useless)
  static Future<String> getNoteCreator({
    required String noteID,
  }) async {
    try {
      var resultF = await notesCollection.findOne({'id': noteID});
      var nute = Note.fromJson(resultF);
      return nute.userId;
    } catch (e) {
      return ("Error while getting Shared Notes : $e");
    }
  }
}
