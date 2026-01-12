import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ImageToPdf {
  static Future<File> generate(Uint8List image) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (_) => pw.Image(pw.MemoryImage(image), fit: pw.BoxFit.contain),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
