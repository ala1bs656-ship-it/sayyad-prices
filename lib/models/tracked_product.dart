class TrackedProduct {
  final String name;
  final String store;
  final String url;
  final int currentPrice;
  final int targetPrice;
  final String size;
  final String status;

  const TrackedProduct({
    required this.name,
    required this.store,
    required this.url,
    required this.currentPrice,
    required this.targetPrice,
    this.size = '',
    this.status = 'متابعة تجريبية',
  });

  bool get reachedTarget => currentPrice <= targetPrice;
}
