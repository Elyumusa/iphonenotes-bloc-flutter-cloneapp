import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

import '../../services/auth/bloc/theme_bloc.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  //late final NotesService _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  //String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // _notesService = NotesService();
    super.initState();
  }

  Map timeFilters = {
    "Today": [],
    "Previous 7 Days": [],
    "Previous 30 Days": [],
  };
  final List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.transparent,
        height: 80,
        child: Row(
          children: [
            Spacer(),
            StreamBuilder(
              stream: _notesService.allNotes(ownerUserId: userId).getLength,
              builder: (context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  final noteCount = snapshot.data ?? 0;
                  final text = context.loc.notes_title(noteCount);
                  return Text(text);
                } else {
                  return const Text('');
                }
              },
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                },
                icon: const Icon(
                  Icons.note_add_outlined,
                ))
          ],
        ),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.yellowAccent[700],
                size: 16,
              ),
              Text(
                "Folders",
                style: TextStyle(color: Colors.yellowAccent[700], fontSize: 12),
              )
            ],
          ),
        ),
        /*title: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              final text = context.loc.notes_title(noteCount);
              return Text(text);
            } else {
              return const Text('');
            }
          },
        ),*/
        actions: [
          /* IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(context.loc.logout_button),
                ),
              ];
            },
          )
        */
        ],
      ),
      body: /*FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Waiting for all notes...");
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        print(allNotes);
                        return NotesListView(
                          notes: allNotes,
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                                createOrUpdateNoteRoute,
                                arguments: note);
                          },
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(id: note.id);
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return CircularProgressIndicator();
                  }
                },
              );
            default:
              return CircularProgressIndicator();
          }
        },
      )*/
          Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notes",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineSmall!.color),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Autocomplete(
                  optionsBuilder: (textEditingValue) {
                    return [const Iterable.empty()];
                  },
                  onSelected: (option) {},
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextFormField(
                        validator: (value) {},
                        focusNode: focusNode,
                        controller: textEditingController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(fontSize: 16),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[400],
                            ),
                            suffixIcon: Icon(
                              Icons.keyboard_voice,
                              color: Colors.grey[500],
                            ),
                            hintText: "Search",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: context.read<ThemeBloc>().state ==
                                    ThemeMode.light
                                ? Colors.grey[200]
                                : Colors.grey[800]));
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              StreamBuilder(
                stream: _notesService.allNotes(ownerUserId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as Iterable<CloudNote>;
                        allNotes.forEach(
                          (element) {
                            if (DateTime.parse(element.date).day ==
                                    DateTime.now().day &&
                                DateTime.parse(element.date).month ==
                                    DateTime.now().month) {
                              timeFilters['Today'].removeWhere(
                                  (e) => e.documentId == element.documentId);
                              if (element.text.isNotEmpty ||
                                  element.title.isNotEmpty) {
                                timeFilters['Today'].add(element);
                              }
                            } else if (DateTime.parse(element.date).day !=
                                    DateTime.now().day &&
                                DateTime.parse(element.date).month ==
                                    DateTime.now().month &&
                                DateTime.parse(element.date).day >
                                    DateTime.now()
                                        .subtract(Duration(days: 7))
                                        .day) {
                              timeFilters['Previous 7 Days'].removeWhere(
                                  (e) => e.documentId == element.documentId);
                              if (element.text.isNotEmpty ||
                                  element.title.isNotEmpty) {
                                timeFilters['Previous 7 Days'].add(element);
                              }
                            } else if (DateTime.parse(element.date).day !=
                                    DateTime.now().day &&
                                DateTime.parse(element.date).month ==
                                    DateTime.now().month &&
                                DateTime.parse(element.date).day <
                                    DateTime.now()
                                        .subtract(Duration(days: 7))
                                        .day) {
                              timeFilters['Previous 30 Days'].removeWhere(
                                  (e) => e.documentId == element.documentId);
                              if (element.text.isNotEmpty ||
                                  element.title.isNotEmpty) {
                                timeFilters['Previous 30 Days'].add(element);
                              }
                            } else {
                              String month =
                                  months[DateTime.parse(element.date).month];
                              if (timeFilters[month] != null) {
                                timeFilters[month].removeWhere(
                                    (e) => e.documentId == element.documentId);
                                timeFilters[month].add(element);
                              } else {
                                timeFilters[month] = [];
                                timeFilters[month].removeWhere(
                                    (e) => e.documentId == element.documentId);
                                if (element.text.isNotEmpty ||
                                    element.title.isNotEmpty) {
                                  timeFilters[month].add(element);
                                }
                              }
                            }
                          },
                        );
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...timeFilters.keys.map((e) {
                                print(
                                    "Previous 30 days hmmm: ${timeFilters.keys.length}");
                                if (timeFilters[e].isNotEmpty) {
                                  print("object: ${timeFilters[e][0].text}");
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      NotesListView(
                                        group: e,
                                        notes: timeFilters[e],
                                        onDeleteNote: (note) async {
                                          await _notesService.deleteNote(
                                              documentId: note.documentId);
                                          setState(() {});
                                        },
                                        onTap: (note) {
                                          Navigator.of(context).pushNamed(
                                            createOrUpdateNoteRoute,
                                            arguments: note,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  print(
                                      "Previous 30 days hmmm again: ${timeFilters.keys.length}");
                                  return SizedBox();
                                }
                              }).toList()
                            ],
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
