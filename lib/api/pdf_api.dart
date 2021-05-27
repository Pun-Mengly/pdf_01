import 'dart:core';
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_01/data/data_item.dart';
import 'package:pdf_01/model/invoice.dart';

//This class for UI Output
class PdfApi {
  static Future<File> generateTable() async {
    final pdf = Document();

    final headers = ['Description', 'Size', 'Qty', 'Amount'];

    invoice;
    final data = invoice
        .map(
            (user) => [user.description, user.size, user.quantity, user.amount])
        .toList();

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a5,
        build: (Context context) {
          return Container(
            alignment: Alignment.topLeft,
            child: Column(children: [
              Text("Invoice".toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              SizedBox(height: 10),
              Table.fromTextArray(
                  headers: headers,
                  data: data,
                  border: null,
                  headerDecoration: BoxDecoration(color: PdfColors.grey300),
                  headerStyle: TextStyle(fontWeight: FontWeight.bold),
                  cellHeight: 30,
                  cellAlignments: {
                    0: Alignment.centerLeft,
                    1: Alignment.centerRight,
                    2: Alignment.centerRight,
                    3: Alignment.centerRight
                  }),
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sub Total'),
                          Text(_total().toString(),
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                    SizedBox(height: 7),
                    Row(children: [
                      Text('VAT'),
                      SizedBox(width: 180),
                      Text('0%'),
                    ]),
                    SizedBox(height: 7),
                    Divider(),
                    Text('Grand Total (R) '),
                    SizedBox(height: 7),
                    Text('Grand Total (D)'),
                  ]))
            ]),
          ); // Center
        })); //

    // final image = await imageFromAssetBundle('assets/image.png');
    //
    // pdf.addPage(Page(build: (Context context) {
    //   return Center(
    //     child: Image(image),
    //   ); // Center
    // })); // Page

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Widget MM() {}
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

  static Widget buildFooter(InvoiceItem invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Text('Thank you for coming. Please come again!!')
        ],
      );
  // sum amount without vat
  static double _total() {
    return 1000;
  }
}
