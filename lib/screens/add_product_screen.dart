import 'package:flutter/material.dart';
import '../models/tracked_product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final name = TextEditingController();
  final url = TextEditingController();
  final target = TextEditingController(text: '2200');
  final size = TextEditingController();

  @override
  void dispose() { name.dispose(); url.dispose(); target.dispose(); size.dispose(); super.dispose(); }

  void save() {
    final price = int.tryParse(target.text.trim());
    final link = Uri.tryParse(url.text.trim());
    if (name.text.trim().isEmpty || link == null || !link.hasScheme || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('راجع اسم المنتج والرابط والسعر المستهدف')));
      return;
    }
    Navigator.pop(context, TrackedProduct(
      name: name.text.trim(),
      store: link.host,
      url: link.toString(),
      currentPrice: 0,
      targetPrice: price,
      size: size.text.trim(),
      status: 'تمت الإضافة محليًا — بانتظار ربط خدمة الأسعار',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        const Text('ضيف المنتج اللي عايز تتابع سعره', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        _field(name, 'اسم المنتج', Icons.shopping_bag_outlined),
        _field(url, 'رابط المنتج', Icons.link),
        _field(target, 'السعر المستهدف بالجنيه', Icons.flag, numeric: true),
        _field(size, 'المقاس أو اللون (اختياري)', Icons.tune),
        const SizedBox(height: 14),
        FilledButton.icon(onPressed: save, icon: const Icon(Icons.add), label: const Text('إضافة المنتج'), style: FilledButton.styleFrom(padding: const EdgeInsets.all(16))),
        const SizedBox(height: 12),
        const Text('إضافة المنتج تحفظه في هذه النسخة على الجهاز فقط. جلب السعر تلقائيًا سيُضاف بعد تجهيز الخادم ومصادر بيانات المتاجر.', style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5)),
      ]),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, {bool numeric = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
    ),
  );
}
