import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import '../image/image_to_cpcl.dart';
import '../image/image_to_zpl.dart';
import '../view/invoice_widget.dart';
import '../image/widget_to_image.dart';
import '../image/image_to_pdf.dart';

class PrintService {
  static final GlobalKey _key = GlobalKey();

  static Widget hiddenInvoice({
    required String invoiceNo,
    required String total,
    required String vat,
    required String net,
  }) {
    return RepaintBoundary(
      key: _key,
      child: InvoiceWidget(
        invoiceNo: invoiceNo,
        total: total,
        vat: vat,
        net: net,
      ),
    );
  }

  //? Image
  static Future<Uint8List> generateImage() async {
    await WidgetsBinding.instance.endOfFrame;
    return WidgetToImage.capture(_key);
  }

  //? PDF
  static Future<File> generatePdf() async {
    final image = await generateImage();
    final file = await ImageToPdf.generate(image);

    if (!await file.exists()) {
      throw Exception('PDF file was not created');
    }

    return file;
  }

  //? ZPL
  static Future<void> printZebra() async {
    final image = await generateImage(); // PNG من Widget
    final zpl = ImageToZpl.convert(image);

    log(zpl);
  }

  //? CPCL
  static Future<void> printCpcl() async {
    final image = await generateImage(); // من PrintService
    final cpcl = ImageToCpcl.convert(image, paperWidth: 576);

    log(cpcl);
  }
}
