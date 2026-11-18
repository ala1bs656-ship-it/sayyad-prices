import 'package:flutter/material.dart';
import '../models/tracked_product.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductCard extends StatelessWidget {
  final TrackedProduct product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final reached = product.reachedTarget;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: const Color(0xFFE8F4EE), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF16865B)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('${product.store}${product.size.isEmpty ? '' : ' • ${product.size}'}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ])),
                Icon(Icons.more_horiz, color: Colors.grey.shade500),
              ],
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _price('السعر المسجل', '${product.currentPrice} ج.م'),
              _price('السعر المستهدف', '${product.targetPrice} ج.م', alignEnd: true),
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: reached ? const Color(0xFFE5F5EC) : const Color(0xFFF1F3F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(reached ? Icons.check_circle : Icons.info_outline, size: 16, color: reached ? Colors.green : Colors.black54),
                const SizedBox(width: 6),
                Expanded(child: Text(product.status, style: const TextStyle(fontSize: 11))),
              ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final uri = Uri.tryParse(product.url);
                  if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('افتح المنتج'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _price(String label, String value, {bool alignEnd = false}) => Column(
    crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.black54, fontSize: 11)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
    ],
  );
}
