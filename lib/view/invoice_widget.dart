import 'package:flutter/material.dart';

class InvoiceWidget extends StatelessWidget {
  final String invoiceNo;
  final String total;
  final String vat;
  final String net;

  const InvoiceWidget({
    super.key,
    required this.invoiceNo,
    required this.total,
    required this.vat,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 300, // عرض طابعة 80mm
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'مؤسسة المثال التجارية',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 4),
            const Divider(),

            _row('رقم الفاتورة', invoiceNo),
            _row('الإجمالي', total),
            _row('الضريبة', vat),
            _row('الصافي', net),

            const Divider(),
            const SizedBox(height: 8),

            const Center(
              child: Text(
                'شكراً لتعاملكم معنا',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 10)),
          Text(value, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
