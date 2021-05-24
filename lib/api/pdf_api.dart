import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class User {
  final String name;
  final int age;
  final String statue;

  const User({this.name, this.age, this.statue});
}

//This class for UI Output
class PdfApi {
  static Future<File> generateTable() async {
    final pdf = Document();

    final headers = ['Name', 'Age', 'Statues'];
    final users = [
      User(name: 'Mengly', age: 20, statue: 'Single'),
      User(name: 'Mengly', age: 20, statue: 'Single'),
      User(name: 'Mengly', age: 20, statue: 'Single'),
      User(name: 'Mengly', age: 20, statue: 'Single'),
      User(name: 'Mengly', age: 20, statue: 'Single'),
      User(name: 'Mengly', age: 20, statue: 'Single'),
      User(name: 'Mengly', age: 20, statue: 'Single'),
    ];
    final data =
        users.map((user) => [user.name, user.age, user.statue]).toList();

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a5,
        build: (Context context) {
          return Container(
              child: Column(children: [
            Text("Hello PDF"),
            SizedBox(height: 10),
            Table.fromTextArray(headers: headers, data: data)
          ])); // Center
        })); //
    // final image = MemoryImage(
    //   File('assets/images/Atech.png').readAsBytesSync(),
    // );
    //
    // pdf.addPage(Page(build: (Context context) {
    //   return Center(
    //     child: Image(image),
    //   ); // Center
    // })); // Page

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({String name, Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
