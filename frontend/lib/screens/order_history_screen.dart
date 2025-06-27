import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Order history screen showing past orders
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  // TODO: Replace with actual API call to fetch order history from backend
  // This dummy data should be replaced with dynamic data fetching from the server
  static final List<OrderHistoryItem> _orderHistory = [
    OrderHistoryItem(
      id: 'ORD-001',
      displayId: 'Selection #1',
      date: DateTime(2023, 10, 1),
      totalCalories: 240,
      status: OrderStatus.confirmed,
      items: ['Idli x2', 'Samosa x1'],
    ),
    OrderHistoryItem(
      id: 'ORD-002',
      displayId: 'Selection #2',
      date: DateTime(2023, 10, 3),
      totalCalories: 420,
      status: OrderStatus.delivered,
      items: ['Biryani x1', 'Chai x2'],
    ),
    OrderHistoryItem(
      id: 'ORD-003',
      displayId: 'Selection #3',
      date: DateTime(2023, 10, 5),
      totalCalories: 168,
      status: OrderStatus.confirmed,
      items: ['Dosa x1'],
    ),
    OrderHistoryItem(
      id: 'ORD-004',
      displayId: 'Selection #4',
      date: DateTime(2023, 10, 8),
      totalCalories: 635,
      status: OrderStatus.delivered,
      items: ['Butter Chicken x1', 'Samosa x2', 'Chai x1'],
    ),
    OrderHistoryItem(
      id: 'ORD-005',
      displayId: 'Selection #5',
      date: DateTime(2023, 10, 12),
      totalCalories: 116,
      status: OrderStatus.pending,
      items: ['Idli x2'],
    ),
    OrderHistoryItem(
      id: 'ORD-006',
      displayId: 'Selection #6',
      date: DateTime(2023, 10, 15),
      totalCalories: 350,
      status: OrderStatus.cancelled,
      items: ['Butter Chicken x1'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Order History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _orderHistory.isEmpty ? _EmptyHistoryView() : _OrderHistoryList(),
    );
  }
}

/// Empty state view when no order history
class _EmptyHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: const Color(0xFF495867).withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            Text(
              'No Order History',
              style: GoogleFonts.zenLoop(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF495867),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your past orders will appear here once you start placing orders.',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                color: const Color(0xFF495867).withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Order history list view
class _OrderHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: OrderHistoryScreen._orderHistory.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _OrderHistoryCard(
          order: OrderHistoryScreen._orderHistory[index],
        );
      },
    );
  }
}

/// Individual order history card
class _OrderHistoryCard extends StatelessWidget {
  final OrderHistoryItem order;

  const _OrderHistoryCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.displayId,
                  style: GoogleFonts.zenLoop(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF495867), // Payne's Gray
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            
            // Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: const Color(0xFF495867).withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(order.date),
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: const Color(0xFF495867).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Total Calories
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  size: 16,
                  color: Color(0xFFFE7252), // Tomato color
                ),
                const SizedBox(width: 8),
                Text(
                  '${order.totalCalories} calories',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF495867),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Order Items
            Text(
              'Items:',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF495867),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: order.items.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E1D7), // Champagne Pink
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF8B7D7A).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.epilogue(
                    fontSize: 12,
                    color: const Color(0xFF495867),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Format date to readable string
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Status chip widget with Mint color for confirmed status
class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.displayName,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: status.textColor,
        ),
      ),
      backgroundColor: status.backgroundColor,
      side: BorderSide(
        color: status.borderColor,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// Data model for order history items
class OrderHistoryItem {
  final String id;
  final String displayId;
  final DateTime date;
  final int totalCalories;
  final OrderStatus status;
  final List<String> items;

  const OrderHistoryItem({
    required this.id,
    required this.displayId,
    required this.date,
    required this.totalCalories,
    required this.status,
    required this.items,
  });
}

/// Order status enum with color configurations
enum OrderStatus {
  pending,
  confirmed,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFFF4E6); // Light orange
      case OrderStatus.confirmed:
        return const Color(0xFFE8F5F0); // Light mint (as requested)
      case OrderStatus.delivered:
        return const Color(0xFFE8F5F0); // Light mint
      case OrderStatus.cancelled:
        return const Color(0xFFFFE4E1); // Light red
    }
  }

  Color get borderColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFE7252); // Tomato
      case OrderStatus.confirmed:
        return const Color(0xFF3AB795); // Mint (as requested)
      case OrderStatus.delivered:
        return const Color(0xFF3AB795); // Mint
      case OrderStatus.cancelled:
        return const Color(0xFFBA1A1A); // Red
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFF495867); // Payne's Gray
      case OrderStatus.confirmed:
        return const Color(0xFF495867); // Payne's Gray
      case OrderStatus.delivered:
        return const Color(0xFF495867); // Payne's Gray
      case OrderStatus.cancelled:
        return const Color(0xFF495867); // Payne's Gray
    }
  }
}
