import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:recase/recase.dart';

void main(List<String> arguments) {
  const listQuestions = [
    [
      {
        'question': 'What you want to create?',
        'options': ['Stateful Widget', 'Stateless Widget', 'Plain Class']
      },
      'type'
    ],
  ];

  var otherQuestions = [
    ['Where you want to save?', 'path'],
    ['What is your class name?', 'name'],
  ];
  final dialog = CLI_Dialog(
    listQuestions: listQuestions,
    questions: otherQuestions,
  );
  final answers = dialog.ask();

  String fileType = answers['type'];
  String path = answers['path'];
  ReCase fileName = ReCase(answers['name']);

  String fileStub = getFileStubs()[fileType] ?? '';
  String filePath = buildFilePath(path, fileName.pascalCase);
  String className = fileName.pascalCase;
  fileStub = fileStub.replaceAll('{{FILENAME}}', className);

  File(filePath).create(recursive: true).whenComplete(() {
    File(filePath).writeAsString(fileStub);
  });
}

String buildFilePath(String path, String fileName) {
  List<String> pathList = path.split('/');
  pathList.removeWhere((value) => value == "");
  path = pathList.join('/');

  return "$path/$fileName.dart";
}

Map<String, String> getFileStubs() {
  return {
    'Stateful Widget': getStatefulStub(),
    'Stateless Widget': getStatelessStub(),
    'Plain Class': getPlanClass(),
  };
}

String getStatefulStub() {
  return """
import 'package:flutter/material.dart';

class {{FILENAME}} extends StatefulWidget {

  const {{FILENAME}}({Key? key}) : super(key: key);

  @override
  _{{FILENAME}}State createState() => _{{FILENAME}}State();
}

class _{{FILENAME}}State extends State<{{FILENAME}}> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
""";
}

String getStatelessStub() {
  return """
import 'package:flutter/material.dart';

class {{FILENAME}} extends StatelessWidget {
  const {{FILENAME}}({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
""";
}

String getPlanClass() {
  return """
class {{FILENAME}} {

  //

}

""";
}
