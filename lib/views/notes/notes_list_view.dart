import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:sqflite/sqflite.dart';

import '../../services/auth/bloc/theme_bloc.dart';
import '../../services/crud/notes_service.dart';

typedef NoteCallback = void Function(CloudNote note);
//typedef NoteCallBack = void Function(DatabaseNote note);

/*class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NotesListView(
      {Key? key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Dismissible(
          key: ValueKey(note.hashCode),
          background: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete),
              ],
            ),
            decoration: BoxDecoration(color: Colors.redAccent[100]),
          ),
          onDismissed: (direction) async {
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
              onDeleteNote(note);
            }
          },
          child: ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            /* trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: Icon(Icons.delete)),*/
          ),
        );
      },
    );
  }
}*/
class NotesListView extends StatelessWidget {
  final List notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  final String group;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.group,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      notes.length,
      (index) {
        final note = notes.elementAt(index);
        return Dismissible(
            key: UniqueKey(),
            background: Container(
              decoration: BoxDecoration(color: Colors.redAccent[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete),
                ],
              ),
            ),
            onDismissed: (direction) async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            child: GestureDetector(
              onTap: () {
                onTap(note);
              },
              child: Container(
                //height: 100,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: context.read<ThemeBloc>().state == ThemeMode.light
                      ? Colors.white
                      : Colors.grey[800],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      group != "Today"
                          ? "${note.date.toString().split("T")[0]}  ${note.text}"
                          : "${note.text}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15),
                    )
                  ],
                ),
              ),
            ) /*ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            /* trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: Icon(Icons.delete)),*/
          ),*/
            );
      },
    ));
  }
}
