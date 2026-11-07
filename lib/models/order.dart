import 'service_category.dart';
import 'service_provider.dart';

class Order {
  const Order({
    required this.code,
    required this.category,
    required this.customerName,
    required this.pickup,
    required this.quantity,
    required this.schedule,
    required this.total,
    this.destination,
    this.note,
    this.provider,
  });

  final String code;
  final ServiceCategory category;
  final String customerName;
  final String pickup;
  final String? destination;
  final int quantity;
  final DateTime schedule;
  final String? note;
  final int total;
  final ServiceProvider? provider;
}
