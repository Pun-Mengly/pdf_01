import 'dart:io';

import 'package:flutter/services.dart';
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

    var now = DateTime.now();
    final headers = ['Description', 'Size', 'Qty', 'Amount'];

    final data = invoice
        .map((objItem) => [
              objItem.description,
              objItem.size,
              objItem.quantity,
              objItem.amount
            ])
        .toList();

    var assetImage = MemoryImage(
      (await rootBundle.load(
        'assets/burherlogo.png',
      ))
          .buffer
          .asUint8List(),
    );

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a5,
        build: (context) {
          return [
            Container(
              child: Column(children: [
                Row(children: [
                  Container(
                    child: Text('Sarah Puy\nTek Thar,\nSenSok,\nPhnom Penh'),
                  ),
                  SizedBox(width: 35),
                  Container(
                    height: 80,
                    child: Image(assetImage),
                  ),
                  SizedBox(width: 35),
                  Container(
                      child: Text('Cashier: Thida\nTables: BB009\nDate: $now')),
                ]),
                SizedBox(height: 10),
                Text("Invoice".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    )),
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
                            Text(
                              _subTotal().toString(),
                            )
                          ]),
                      SizedBox(height: 7),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('VAT'),
                            Text('19%'),
                            Text(_vatTotal().toString())
                          ]),
                      SizedBox(height: 7),
                      Divider(),
                      Text('Grand Total (R) '),
                      SizedBox(height: 7),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grand Total (D)'),
                            Text(_grandTotal().toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                    ]))
              ]),
            ) // Center
          ];
        },
        footer: (context) => buildFooter(InvoiceItem())));

    return saveDocument(name: 'my_atech_invoice.pdf', pdf: pdf);
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

  static Widget buildFooter(InvoiceItem invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Text('Orkun sorab ka mor. Som mor mdong teat!!'),
          Text('Thank you for coming. Please come again!!')
        ],
      );
  // sum amount without vat
  static double _subTotal() {
    double total = 0;
    for (double i = 0; i < invoice.length; i++) {
      total += invoice[i.toInt()].amount;
    }

    return total;
  }

  static double _grandTotal() {
    double total = 0;
    double vat = 0.19;
    double grandTotal = 0;
    for (double i = 0; i < invoice.length; i++) {
      total += invoice[i.toInt()].amount;
    }
    vat = total * vat;
    grandTotal = total + vat;
    return grandTotal;
  }

  static double _vatTotal() {
    double total = 0;
    double vat = 0.19;
    double grandTotal = 0;
    for (double i = 0; i < invoice.length; i++) {
      total += invoice[i.toInt()].amount;
    }
    vat = total * vat;

    return vat;
  }
}
