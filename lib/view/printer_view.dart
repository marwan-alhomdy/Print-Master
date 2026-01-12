import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../service/print_service.dart';

class PrinterView extends StatelessWidget {
  const PrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Print Demo')),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await PrintService.printZebra();
                  } catch (e) {
                    debugPrint('ZPL generation failed: $e');
                  }
                },
                child: const Text('Print Invoice ZPL'),
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await PrintService.printCpcl();
                  } catch (e) {
                    debugPrint('CPCL generation failed: $e');
                  }
                },
                child: const Text('Print Invoice CPCL'),
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final file = await PrintService.generatePdf();
                    debugPrint('PDF created at: ${file.path}');
                    await OpenFile.open(file.path);
                  } catch (e) {
                    debugPrint('PDF generation failed: $e');
                  }
                },
                child: const Text('Print Invoice Pdf'),
              ),
            ),

            const SizedBox(height: 40),
            // الفاتورة المخفية
            PrintService.hiddenInvoice(
              invoiceNo: 'INV-001',
              total: '100.00 SAR',
              vat: '15.00 SAR',
              net: '115.00 SAR',
            ),
          ],
        ),
      ),
    );
  }
}
