import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'fileList.dart';
import 'data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  int count_select = 0;
  List<ElementList> listElem = [];

  List<Data> datas = [];

  String _selectedPath = '';
  int cursor_select = 0;

  //List<String> srcs = [];
  FileList? fileList;

  void copyFile(String sourcePath, String destinationPath) {
    File sourceFile = File(sourcePath);
    File destinationFile =
        File(path.join(destinationPath, path.basename(sourcePath)));

    // Проверяем, существует ли файл, который нужно скопировать
    if (!sourceFile.existsSync()) {
      print('Файл не существует');
      return;
    }

    // Проверяем, существует ли папка, в которую нужно скопировать файл
    if (!Directory(path.dirname(destinationFile.path)).existsSync()) {
      print('Папка назначения не существует');
      return;
    }

    // Копируем файл
    try {
      sourceFile.copySync(destinationFile.path);
      print('Файл успешно скопирован');
    } catch (e) {
      print('Ошибка при копировании файла: $e');
    }
  }

  void createFolderIfNotExists(String path) {
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('Папка создана по пути: $path');
    } else {
      print('Папка уже существует по пути: $path');
    }
  }

  List<String> save = [];

  void save_files() {
    save = [];
    createFolderIfNotExists(src_save!);
    for (Data file in datas) {
      if (file.state_select == true) {
        save.add(file.src);
      }
    }
    for (String file in save) {
      copyFile(file, src_save!);
    }
  }

  void _openFileExplorer() async {
    String? temp_src = await FilePicker.platform.getDirectoryPath();
    setState(() {
      src = temp_src;
      src_save = src! + '\\Save';
    });
    if (src != null) {
      print('Выбранная папка: $src');
      //srcs = [];
      datas = [];
      Directory directory = Directory(src!);
      List<FileSystemEntity> files = directory.listSync();

      for (FileSystemEntity file in files) {
        if (file is File && file.path.endsWith('.JPG')) {
          print(file.path);
          //srcs.add(file.path);
          datas.add(Data(
              src: file.path, cursor: false, name: path.basename(file.path)));
        }
      }
    }
    setState(() {
      datas[0].set_active_cursor();

      for (Data element in datas) {
        listElem.add(ElementList(element));
      }
      //fileList = FileList(datas);
    });
  }

  set_add_active_cursor() {
    print(cursor_select);
    setState(() {
      if (cursor_select < datas.length - 1) {
        datas[cursor_select].set_unactive_cursor();
        listElem[cursor_select++].el.set_unactive_cursor();
        datas[cursor_select].set_active_cursor();
        listElem[cursor_select].el.set_active_cursor();
      }
      src_img = datas[cursor_select].src;
    });
  }

  set_dell_active_cursor() {
    print(cursor_select);
    setState(() {
      if (cursor_select > 0) {
        datas[cursor_select].set_unactive_cursor();
        listElem[cursor_select--].el.set_unactive_cursor();
        datas[cursor_select].set_active_cursor();
        listElem[cursor_select].el.set_active_cursor();
      }
      src_img = datas[cursor_select].src;
    });
  }

  set_active() {
    print(cursor_select);
    setState(() {
      if (datas[cursor_select].state_select) {
        datas[cursor_select].set_unactive_state_select();
        listElem[cursor_select].el.set_unactive();
        count_select--;
      } else {
        datas[cursor_select].set_active_state_select();
        listElem[cursor_select].el.set_active();
        count_select++;
      }
    });
  }

  String? src = "";
  String? src_save = "";
  String? src_img = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 19,
              child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      setState(() {
                        set_dell_active_cursor();
                      });
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.arrowDown) {
                      setState(() {
                        set_add_active_cursor();
                      });
                    } else if (event.logicalKey ==
                        LogicalKeyboardKey.arrowLeft) {
                      set_active();
                    }
                  }
                },
                child: Container(
                  color:
                      const Color.fromARGB(255, 29, 29, 29), // Тёмно-серый фон
                  child: src_img!.isNotEmpty
                      ? Container(
                          color: const Color.fromARGB(255, 29, 29, 29),
                          child: Image.file(File(src_img!)),
                        )
                      : Container(
                          color: const Color.fromARGB(255, 29, 29, 29),
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      color: const Color.fromARGB(
                          255, 29, 29, 29), // Тёмно-серый фон
                      child: src!.isEmpty
                          ? Container()
                          : Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [...listElem],
                                ),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: const Color.fromARGB(
                            255, 29, 29, 29), // Тёмно-серый фон
                        padding: EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Container(
                              child: TextField(
                                enabled: false,
                                controller:
                                    TextEditingController(text: _selectedPath),
                                decoration: InputDecoration(
                                  labelText: src_save,
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 29, 29, 29),
                                ),
                                onPressed: _openFileExplorer,
                                child: Text('Выбрать папку'),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: const Color.fromARGB(255, 29, 29, 29),
                      child: Column(children: [
                        Container(
                          color: const Color.fromARGB(255, 29, 29, 29),
                          child: Text(
                            'Выбрано:',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                        Container(
                          color: const Color.fromARGB(255, 29, 29, 29),
                          child: Text(
                            count_select.toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 29, 29, 29),
                            ),
                            onPressed: save_files,
                            child: Text('Сохранить'),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElementList extends StatefulWidget {
  late _ElementList el;
  Data? data;
  ElementList(Data this.data) {
    el = _ElementList(this.data!);
  }
  @override
  _ElementList createState() => el;
}

class _ElementList extends State<ElementList> {
  Data? data;
  _ElementList(Data this.data);
  @override
  set_active_cursor() {
    setState(() {
      data?.set_active_cursor();
    });
  }

  set_unactive_cursor() {
    setState(() {
      data?.set_unactive_cursor();
    });
  }

  set_active() {
    setState(() {
      data?.set_active_cursor();
    });
  }

  set_unactive() {
    setState(() {
      data?.set_unactive_state_select();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
      color: data!.cursor
          ? Color.fromARGB(255, 59, 59, 59)
          : Color.fromARGB(255, 29, 29, 29),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data!.name,
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey,
            ),
          ),
          if (data!.state_select)
            Icon(
              Icons.check,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
