import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:file_manager/file_manager.dart';

import 'package:flutter/material.dart';
import 'package:pdfviewer/pdfPlayer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'getacsess.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    PermissionStatus status =PermissionStatus.denied;

  // Future<void> requestPermission(Permission permission) async {
  //   status = await permission.request();
  //   if (status.isGranted) {
  //
  //
  //
  //
  //     print('ok');
  //   } else {
  //
  //
  //     print('object');
  //   }
  // }

  @override
  void initState() {
    //requestPermission(Permission.storage);

    super.initState();

  }
  @override

@override

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: GetAcsess(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FileManagerController controller = FileManagerController();
  @override
  void didUpdateWidget(covariant HomePage oldWidget) {

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
        controller: controller,
        child: Scaffold(
          appBar: appBar(context),
          body: FileManager(

            controller: controller,
            builder: (context, snapshot) {
              final List<FileSystemEntity> entities = snapshot;


              return ConditionalBuilder(
                  condition:entities.isNotEmpty   ,

                  builder:(context)=>ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  FileSystemEntity? entity = entities[index];

                  return Card(
                    child: ListTile(
                      leading: FileManager.isFile(entity)
                          ? const Icon(Icons.feed_outlined)
                          : const Icon(Icons.folder),
                      title: Text(FileManager.basename(
                        entity,
                        showFileExtension: true,
                      )),
                      subtitle: subtitle(entity),
                      onTap: () async {
                        if (FileManager.isDirectory(entity)) {
                          // open the folder
                          controller.openDirectory(entity);

                          // delete a folder
                          // await entity.delete(recursive: true);

                          // rename a folder
                          //await entity.rename("newPath");

                          // Check weather folder exists
                          // entity.exists();

                          // get date of file
                          // DateTime date = (await entity.stat()).modified;
                        } else {
                          File? file = File(entity.path);
                          String pdf = entity.path;

                          pdf.endsWith('pdf');

                          if (pdf.endsWith('pdf')) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfPlayer(
                                    file: file,
                                  ),
                                ));
                          } else {
                            showWarningDialog(context);
                            print('file not supported');
                          }

                          // delete a file
                          //await entity.delete();

                          // rename a file
                          // await entity.rename("newPath");

                          // Check weather file exists
                          // entity.exists();

                          // get date of file
                          // DateTime date = (await entity.stat()).modified;

                          // get the size of the file
                          //int size = (await entity.stat()).size;
                        }
                      },
                    ),
                  );
                },
              ) ,
                  fallback:(context)=> const Center(child: CircularProgressIndicator()) ,

              );
            },
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () async {
          //     setState(() {
          //             
          //     });
          //   },
          //   label: const Text("Request File Access Permission"),
          // ),),
        ));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => sort(context),
          icon: const Icon(Icons.sort_rounded),
        ),
        IconButton(
          onPressed: () => selectStorage(context),
          icon: const Icon(Icons.sd_storage_rounded),
        )
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          await controller.goToParentDirectory();
        },
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              FileManager.formatBytes(size),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return const Text("");
        }
      },
    );
  }

  Future<void> selectStorage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder<List<Directory>>(
          future: FileManager.getStorageList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FileSystemEntity> storageList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storageList
                        .map((e) => ListTile(
                              title: Text(
                                FileManager.basename(e),
                              ),
                              onTap: () {
                                controller.openDirectory(e);
                                Navigator.pop(context);
                              },
                            ))
                        .toList()),
              );
            }
            return const Dialog(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  title: const Text("Name"),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("Size"),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  }),
              ListTile(
                  title: const Text("type"),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // createFolder(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       TextEditingController folderName = TextEditingController();
  //       return Dialog(
  //         child: Container(
  //           padding: const EdgeInsets.all(10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               ListTile(
  //                 title: TextField(
  //                   controller: folderName,
  //                 ),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   try {
  //                     // Create Folder
  //                     await FileManager.createFolder(
  //                         controller.getCurrentPath, folderName.text);
  //                     // Open Created Folder
  //                     controller.setCurrentPath =
  //                         "${controller.getCurrentPath}/${folderName.text}";
  //                   } catch (e) {}
  //
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Create Folder'),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  /////////////////////////////////
  showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("file not supported"),
                content: const Icon(
                  Icons.warning_amber_outlined,
                  size: 35,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "ok",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
