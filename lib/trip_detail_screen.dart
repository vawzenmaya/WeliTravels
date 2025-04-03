import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:welitravels/dashboard_screen.dart';
// import 'package:welitravels/requirements.dart';

class TripDetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String date;
  final String duration;
  final String price;
  final double rating;
  final List<String> highlights;
  final List<String> inclusions;
  final List<String> exclusions;

  const TripDetailScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.price,
    required this.rating,
    this.highlights = const [],
    this.inclusions = const [],
    this.exclusions = const [],
  }) : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> with SingleTickerProviderStateMixin {
  bool showReviews = false;
  bool isFavorite = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleReviews() {
    setState(() {
      showReviews = !showReviews;
    });
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _redirectToWhatsApp() async {
    const String phoneNumber = "+256787018472";
    final String message = Uri.encodeComponent(
        "Hello, I am interested in booking the ${widget.title} trip. Could you provide more details?");
    final String url = "https://wa.me/${phoneNumber.replaceAll('+', '')}?text=$message";
    
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp.')),
      );
    }
  }

  void _showReviewModal() {
    int selectedRating = 0;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Rating",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Rate this Journey", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Describe your experience",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRating > 0) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Thank you for your $selectedRating-star review!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a rating'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Submit Review",
                      style: TextStyle(fontSize: 18, color: Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 5,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 15,
                    child: GestureDetector(
                      onTap: toggleFavorite,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_border,
                          size: 30,
                          color: const Color.fromARGB(255, 250, 203, 18),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.5 - 20,
                    left: 25,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.8,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 254, 247, 255),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                ),
                child: showReviews
                    ? buildReviewsSection()
                    : buildContentSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContentSection() {
    return Column(
      children: [
        // Rating and reviews button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Color.fromARGB(255, 250, 203, 18), size: 30),
                  const SizedBox(width: 5),
                  Text(
                    widget.rating.toString(),
                    style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 131, 176, 124)),
                  ),
                  const Text(
                    "  (546 reviews)",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              TextButton(
                onPressed: toggleReviews,
                child: const Text(
                  "View Reviews",
                  style: TextStyle(fontSize: 18, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
        
        // Tab bar for different sections
        TabBar(
          controller: _tabController,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.purple,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Inclusions'),
          ],
        ),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildOverviewTab(),
              buildInclusionsTab(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "per person",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _showPlanDialog(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: const Color.fromARGB(255, 204, 215, 204),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Highlights",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10
          ),
          ...widget.highlights.map((highlight) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    highlight,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ],
            ),
          )).toList(),
          if (widget.highlights.isEmpty)
            const Text(
              "No highlights available for this trip.",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Trip Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.calendar_today, "Date", widget.date),
                _buildDetailRow(Icons.access_time, "Duration", widget.duration),
                _buildDetailRow(Icons.group, "Group Size", "10-15 people"),
                _buildDetailRow(Icons.language, "Languages", "English, Arabic"),
                _buildDetailRow(Icons.location_on, "Meeting Point", "Airport"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInclusionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's Included",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...widget.inclusions.map((inclusion) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inclusion,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ],
            ),
          )).toList(),
          if (widget.inclusions.isEmpty)
            const Text(
              "No inclusions specified for this trip.",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          
          const SizedBox(height: 20),
          const Text(
            "What's Not Included",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...widget.exclusions.map((exclusion) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.cancel, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exclusion,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ],
            ),
          )).toList(),
          if (widget.exclusions.isEmpty)
            const Text(
              "No exclusions specified for this trip.",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade800),
                    const SizedBox(width: 8),
                    const Text(
                      "Important Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please note that this trip requires a valid passport with at least 6 months validity and a visa for Saudi Arabia. Travel insurance is mandatory for all participants.",
                  style: TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewsSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Color.fromARGB(255, 250, 203, 18), size: 30),
                  const SizedBox(width: 5),
                  Text(
                    widget.rating.toString(),
                    style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 129, 176, 124)),
                  ),
                  const Text(
                    "  (512 reviews)",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
              TextButton(
                onPressed: toggleReviews,
                child: const Text(
                  "Hide Reviews",
                  style: TextStyle(fontSize: 18, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
        // Rating breakdown
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         flex: 3,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             _buildRatingBar("5", 0.9),
        //             _buildRatingBar("4", 0.7),
        //             _buildRatingBar("3", 0.4),
        //             _buildRatingBar("2", 0.2),
        //             _buildRatingBar("1", 0.1),
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         flex: 2,
        //         child: Column(
        //           children: [
        //             _buildRatingCategory("Service", 4.8),
        //             _buildRatingCategory("Value", 4.5),
        //             _buildRatingCategory("Location", 4.9),
        //             _buildRatingCategory("Cleanliness", 4.7),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 10),
        // const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 10,
            itemBuilder: (context, index) {
              // Sample review data
              final reviewers = ["Mansor", "Fatima", "Ahmed", "Layla", "Omar", "Zainab", "Khalid", "Aisha", "Yusuf", "Noor"];
              final comments = [
                "Thank you very much Weli Travels. The trip was amazing!",
                "Excellent service and organization. Highly recommended!",
                "The guides were knowledgeable and friendly. Great experience.",
                "Everything was perfect from start to finish.",
                "Amazing trip! Will definitely book again with Weli Travels.",
                "The accommodations were superb. Very comfortable.",
                "Well organized and professional service.",
                "The itinerary was perfect. We saw all the important sites.",
                "Great value for money. Exceeded my expectations.",
                "Unforgettable experience. Thank you Weli Travels!"
              ];
              final ratings = [5, 4, 5, 4, 5, 3, 4, 5, 4, 5];
              final timeAgo = ["2 days ago", "1 week ago", "2 weeks ago", "3 days ago", "1 month ago",
                               "5 days ago", "2 months ago", "1 day ago", "3 weeks ago", "4 days ago"];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 234, 233, 233),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/maguy.jpg"),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(reviewers[index]),
                      Text(
                        timeAgo[index],
                        style: const TextStyle(color: Colors.purple, fontSize: 12),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(comments[index]),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(
                          5,
                          (starIndex) => Icon(
                            Icons.star,
                            color: starIndex < ratings[index] ? Colors.amber : Colors.grey[300],
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: _showReviewModal,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "Add a review",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildRatingBar(String label, double percentage) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       children: [
  //         SizedBox(width: 15, child: Text(label)),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Stack(
  //             children: [
  //               Container(
  //                 height: 8,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade300,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //               ),
  //               FractionallySizedBox(
  //                 widthFactor: percentage,
  //                 child: Container(
  //                   height: 8,
  //                   decoration: BoxDecoration(
  //                     color: Colors.amber,
  //                     borderRadius: BorderRadius.circular(4),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 8),
  //         Text("${(percentage * 100).toInt()}%"),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildRatingCategory(String category, double rating) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(category, style: const TextStyle(fontSize: 12)),
  //         Row(
  //           children: [
  //             Text(
  //               rating.toString(),
  //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
  //             ),
  //             const Icon(Icons.star, color: Colors.amber, size: 12),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.purple.shade800),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPlanDialog() {
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
                  price: widget.price,
                  description: 'Split your payment into 5 easy installments',
                  borderColor: Colors.purple.shade100,
                  textColor: Colors.purple,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _showInstallmentDetails();
                  },
                ),
                const SizedBox(height: 16),
                _buildPlanCard(
                  title: 'One Time Payment',
                  price: widget.price,
                  description: 'Pay the full amount now and get 5% discount',
                  borderColor: Colors.blue.shade100,
                  textColor: Colors.blue,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _redirectToWhatsApp();
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red
                ),
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

  void _showInstallmentDetails() {
    String priceStr = widget.price.replaceAll(RegExp(r'[^\d.]'), '');
    double price = double.tryParse(priceStr) ?? 2500;
    
    double installmentAmount = price / 5;
    
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
                    widget.price,
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
}