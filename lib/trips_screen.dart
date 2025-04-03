import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:welitravels/dashboard_screen.dart';
import 'package:welitravels/trip_detail_screen.dart';

class TripPage extends StatelessWidget {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/gallery/IMG4.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        'Choose Trip',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildFeaturedTripSection(context),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Available Trips',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildAvailableTripsList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableTripsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildHotPlaceCard(
            context,
            image: 'assets/gallery/IMG3.jpg',
            title: 'Umrah January🕋',
            rating: 4.8,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripDetailScreen(
                    image: 'assets/gallery/IMG3.jpg',
                    title: 'Umrah January🕋',
                    description: "Umrah trip is a pilgrimage to the holy city of Mecca, Saudi Arabia, to perform a set of rituals that worship Allah\n\nUmrah trip is a pilgrimage to the holy city of Mecca, Saudi Arabia, to perform a set of rituals that worship Allah\n\nUmrah trip is a pilgrimage to the holy city of Mecca, Saudi Arabia, to perform a set of rituals that worship Allah",
                    date: 'January',
                    duration: '14',
                    price: '\$2,500',
                    rating: 4.8,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildHotPlaceCard(
            context,
            image: 'assets/gallery/IMG2.jpg',
            title: 'Umrah December🕋',
            rating: 4.5,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripDetailScreen(
                    image: 'assets/gallery/IMG2.jpg',
                    title: 'Umrah December🕋',
                    description: "Umrah trip is a pilgrimage to the holy city of Mecca, Saudi Arabia, to perform a set of rituals that worship Allah\n\nUmrah trip is a pilgrimage to the holy city of Mecca, Saudi Arabia, to perform a set of rituals that worship Allah\n\nUmrah trip is a pilgrimage to the holy city of Mecca, Saudi Arabia, to perform a set of rituals that worship Allah",
                    date: 'December',
                    duration: '21',
                    price: '\$2,500',
                    rating: 4.5,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
Widget _buildHotPlaceCard(
  BuildContext context, {
  required String image,
  required String title,
  required double rating,
  required VoidCallback onTap,
  String location = '',
  int price = 0,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (location.isNotEmpty)
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      Row(
                        children: List.generate(
                          rating.toInt(),
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                      if (price > 0)
                        Text(
                          '\$$price per night',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget _buildFeaturedTripSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              'assets/gallery/IMG23.jpg',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Trip: Umrah',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$2,500 (7 days)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  onPressed: () => _showPlanDialog(context, "Featured Trip: Umrah", "\$2,500"),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      color: Color(0xFF03451F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  void _showPlanDialog(BuildContext context, String title, String price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.payments, color: Colors.purple.shade800),
              const SizedBox(width: 8),
              const Text('Choose Payment Plan'),
            ],
          ),
          content: SizedBox(
            height: 206,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPlanCard(
                  title: 'Pay in Installments',
                  price: price,
                  description: 'Split your payment into 5 easy installments',
                  borderColor: Colors.purple.shade100,
                  textColor: Colors.purple,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _showInstallmentDetails(context, price);
                  },
                ),
                const SizedBox(height: 16),
                _buildPlanCard(
                  title: 'One Time Payment',
                  price: price,
                  description: 'Pay the full amount now and get 5% discount',
                  borderColor: Colors.blue.shade100,
                  textColor: Colors.blue,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _redirectToWhatsApp(title, context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String description,
    required Color borderColor,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12.0),
          color: borderColor.withOpacity(0.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: iconColor, size: 20),
          ],
        ),
      ),
    );
  }

  void _redirectToWhatsApp(String title, BuildContext context) async {
    const String phoneNumber = "+256787018472";
    final String message = Uri.encodeComponent(
        "Hello, I am interested in booking the $title trip. Could you provide more details?");
    final String url = "https://wa.me/${phoneNumber.replaceAll('+', '')}?text=$message";

    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }


void _showInstallmentDetails(BuildContext context, String price) {
  // Remove redeclaration of context
  String priceStr = price.replaceAll(RegExp(r'[^\d.]'), '');
  double priceValue = double.tryParse(priceStr) ?? 2500; // Rename to avoid conflict
  double installmentAmount = priceValue / 5;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.purple.shade800),
              const SizedBox(width: 8),
              const Text('Installment Schedule'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInstallmentRow(
                "First Payment", 
                "\$${installmentAmount.toStringAsFixed(2)}", 
                "Due today"
              ),
              const SizedBox(height: 8),
              _buildInstallmentRow(
                "Second Payment", 
                "\$${installmentAmount.toStringAsFixed(2)}", 
                "Due in 30 days"
              ),
              const SizedBox(height: 8),
              _buildInstallmentRow(
                "Third Payment", 
                "\$${installmentAmount.toStringAsFixed(2)}", 
                "Due in 60 days"
              ),
              const SizedBox(height: 8),
              _buildInstallmentRow(
                "Forth Payment", 
                "\$${installmentAmount.toStringAsFixed(2)}", 
                "Due in 90 days"
              ),
              const SizedBox(height: 8),
              _buildInstallmentRow(
                "Final Payment", 
                "\$${installmentAmount.toStringAsFixed(2)}", 
                "Due in 120 days"
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                    Text(
                    '\$${double.parse(price.replaceAll(RegExp(r"[^\d.]"), "")).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Installment payment selected. First payment processed!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade800,
                foregroundColor: Colors.white,
              ),
              child: const Text('Proceed'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  Widget _buildInstallmentRow(String label, String amount, String dueDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              dueDate,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }