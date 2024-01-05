import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'data.dart';

class FileList extends StatefulWidget {
  List<ElementList> companyPanel = [];
  FileList(List<Data> data) {
    for (Data element in data) {
      companyPanel.add(ElementList(element));
    }
  }

  @override
  _FileList createState() => _FileList();
}

class _FileList extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [...widget.companyPanel],
        ),
      ),
    );
  }
}

class ElementList extends StatefulWidget {
  Data? data;
  ElementList(Data this.data);
  @override
  _ElementList createState() => _ElementList(
        data!,
      );
}

class _ElementList extends State<ElementList> {
  Data? data;
  _ElementList(Data this.data);
  @override
  set_active_cursor() {
    setState(() {
      print('object');
      widget.data?.cursor = true;
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
