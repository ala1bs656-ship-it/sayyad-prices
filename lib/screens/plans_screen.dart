import 'package:flutter/material.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الباقات والاشتراكات')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('اختار الباقة المناسبة ليك', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('الأسعار التالية مقترحة للتصميم فقط. الدفع والاشتراكات غير مفعّلين في هذه النسخة.', style: TextStyle(color: Colors.black54, height: 1.5)),
        const SizedBox(height: 16),
        _plan('مجانية', '0 جنيه', ['متابعة 3 منتجات', 'تحديثات أساسية']),
        _plan('Basic', '49 جنيه / شهر', ['متابعة 20 منتج', 'تنبيهات عند تحقق السعر']),
        _plan('Pro', '99 جنيه / شهر', ['متابعة عدد أكبر من المنتجات', 'تنبيهات أسرع', 'سجل أسعار موسع'], featured: true),
        const SizedBox(height: 12),
        const Text('يمكن إضافة خيار سنوي بعد تحديد الأسعار النهائية وربط الدفع الرسمي عبر متاجر التطبيقات.', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ]),
    );
  }

  Widget _plan(String name, String price, List<String> features, {bool featured = false}) => Card(
    color: featured ? const Color(0xFFEAF6EF) : Colors.white,
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF16865B))),
        ]),
        const SizedBox(height: 10),
        ...features.map((f) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(children: [const Icon(Icons.check_circle_outline, size: 17, color: Color(0xFF16865B)), const SizedBox(width: 8), Text(f)]))),
      ]),
    ),
  );
}
