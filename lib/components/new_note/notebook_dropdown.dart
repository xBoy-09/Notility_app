import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notility/models/notebook.dart';
import 'package:notility/server/mongodb.dart' as mongo;

class DropdownButtonExample extends StatefulWidget {
  final Function(String)
      sendBackNotebook; //function being passed from the New Note screen to return the selected Notebook from the drop down
  final Function(String)
      sendBackSection; //function being passed from the New Note screen to return the selected Section of the notebook from the drop down
  const DropdownButtonExample({
    super.key,
    required this.sendBackNotebook,
    required this.sendBackSection,
  });

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  final user = FirebaseAuth.instance.currentUser!;
  List<NoteBook> notebooks = <NoteBook>[]; //list to store notebooks
  List<NoteBook> sections = <NoteBook>[]; //list to store sections

  Map<String, List<NoteBook>> notebookDict =
      {}; //dictionary to map the list of sections each notebook has

  //default variables for the dropdowns
  String _chosenNotebook = '';
  String _chosenSection = '';

  //the selected notebook stored in a separate variable
  late NoteBook noteBook;
  bool disableDropdown = true;

  @override
  void initState() {
    super.initState();
    getNoteBooks();
  }

  //api call to get the notebooks

  void getNoteBooks() async {
    notebooks = await mongo.MongoDatabase.getNoteBookOrSectionForUser(
        userId: user.uid.toString(), type: mongo.Type.notebook);
    print('got notebooks:');
    for (var notebook in notebooks) {
      print(notebook.name);
      // print(notebook.id);
    }
    if (notebooks.isNotEmpty) {
      setState(() {
        //setting the default value of the dropdown to the first notebook
        // _chosenNotebook = notebooks.first.id;
        //setting the notebook as the first notebook
        // noteBook =
        //     notebooks.firstWhere((notebook) => notebook.id == _chosenNotebook);
      });

      //calling the dictBuilder function to populate the dictionary
      dictBuilder();
    }
  }

  //api call to use the "noteBook" variable and gets its sections
  Future<void> getSections() async {
    List<NoteBook> newSections =
        await mongo.MongoDatabase.getNoteBookOrSectionForUser(
            userId: user.uid.toString(),
            type: mongo.Type.section,
            sections: noteBook!.listChildIds);
    setState(() {
      sections = newSections;
    });
  }

/*function to create the dictionary
  it takes the list of all notebooks, iterates over them, finds their sections list
  and adds them to the dictionary
*/
  Future<void> dictBuilder() async {
    for (var book in notebooks) {
      noteBook = book;
      await getSections();
      notebookDict[noteBook.name] =
          sections.isNotEmpty ? List.from(sections) : [];
    }
  }

  void updateDropdown() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            value: _chosenNotebook.isNotEmpty ? _chosenNotebook : null,
            style: TextStyle(
              color: Colors.grey[800],
            ),
            underline: Container(
              height: 2,
              color: Colors.white,
            ),
            hint: const Text('Choose Notebook', style: TextStyle(color: Colors.white),),
            items: notebooks.map<DropdownMenuItem<String>>((NoteBook notebook) {
              return DropdownMenuItem<String>(
                value: notebook.id,
                child: Text(notebook.name),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              setState(() {
                _chosenNotebook = newValue!;
                noteBook = notebooks
                    .firstWhere((notebook) => notebook.id == _chosenNotebook);

                widget.sendBackNotebook(noteBook.name); //sending the name back

                // print('notebook name = ${noteBook.name}');
                // notebookDict.forEach((notebook, sections) {
                //   print('$notebook: $sections');
                // });
                // sections.clear();
                //choosing the section from the notebook
                sections = notebookDict[noteBook.name] ?? [];
                print(sections.length);
                if (sections.isNotEmpty) {
                  disableDropdown = false;
                  _chosenSection = '';
                }
              });

              updateDropdown();
            },
          ),
        ),
        Visibility(
          visible: sections.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              value: _chosenSection.isNotEmpty ? _chosenSection : null,
              style: TextStyle(
                color: Colors.grey[800],
              ),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              hint: const Text('Choose Section', style: TextStyle(color: Colors.white)),
              items: sections.map<DropdownMenuItem<String>>((NoteBook sect) {
                return DropdownMenuItem<String>(
                  value: sect.id,
                  child: Text(sect.name),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                print(sections);
                setState(() {
                  _chosenSection = newValue!;

                  //converting the chosen id back to a section and sending its name back
                  NoteBook selectedSection = sections
                      .firstWhere((section) => section.id == _chosenSection);
                  widget.sendBackSection(selectedSection.name);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
