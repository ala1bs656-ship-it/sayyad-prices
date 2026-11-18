import 'package:flutter/material.dart';
import '../data/demo_products.dart';
import '../models/tracked_product.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';
import 'plans_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TrackedProduct> products = [...demoProducts];
  int tab = 0;

  Future<void> addProduct() async {
    final product = await Navigator.push<TrackedProduct>(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );
    if (product != null) setState(() => products.insert(0, product));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('صيّاد الأسعار', style: TextStyle(fontWeight: FontWeight.w900)),
            Text('اشتري بذكاء ومتدفعش زيادة', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addProduct,
        icon: const Icon(Icons.add_link_rounded),
        label: const Text('أضف منتج'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (v) {
          setState(() => tab = v);
          if (v == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PlansScreen()));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'المفضلة'),
          NavigationDestination(icon: Icon(Icons.workspace_premium_outlined), label: 'الباقات'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF147A55), Color(0xFF25A875)]),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('خليك أول واحد يعرف', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('تابع السعر وحدد المبلغ اللي يناسبك، وهننبهك لما تتوفر بيانات سعر جديدة.', style: TextStyle(color: Colors.white, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المنتجات اللي بتتابعها', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${products.length} منتجات', style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),
          ...products.map((p) => ProductCard(product: p)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFFF4DA), borderRadius: BorderRadius.circular(14)),
            child: const Text('تنبيه: الأسعار المعروضة في النسخة الحالية تجريبية وليست تحديثات مباشرة من المتاجر.', style: TextStyle(fontSize: 12, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
