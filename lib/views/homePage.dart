import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/theme_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/views/notes/notes_view.dart';

import '../services/auth/auth_service.dart';
import '../services/cloud/firebase_cloud_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.folder_open_outlined,
                )),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.note_add_outlined,
                ))
          ],
        ),
      ),
      appBar: AppBar(
          /*leading: IconButton(
              onPressed: () {
                context.read<ThemeBloc>().add(
                      ChangeThemeEvent(
                          currentTheme:
                              context.read<ThemeBloc>().state == ThemeMode.dark
                                  ? ThemeMode.light
                                  : ThemeMode.dark),
                    );
              },
              icon: context.read<ThemeBloc>().state == ThemeMode.dark
                  ? Icon(
                      Icons.light_mode,
                      size: 32,
                      color: Colors.yellowAccent,
                    )
                  : Icon(Icons.dark_mode,
                      size: 32, color: Colors.yellowAccent)),
         */
          actions: [
            TextButton(
                onPressed: () {},
                child: Text(
                  "Edit",
                  style:
                      TextStyle(color: Colors.yellowAccent[200], fontSize: 20),
                ))
          ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Folders",
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
              Text(
                "iCloud",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const NotesView();
                    },
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  //height: 100,
                  decoration: BoxDecoration(
                      color: context.read<ThemeBloc>().state == ThemeMode.light
                          ? Colors.white
                          : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_open_outlined),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        "Notes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 10,
                      ),
                      StreamBuilder<int>(
                          stream: _notesService
                              .allNotes(ownerUserId: userId)
                              .getLength,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final noteCount = snapshot.data ?? 0;
                              return Text("$noteCount");
                            } else {
                              return const Text("");
                            }
                          }),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
