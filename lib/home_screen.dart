import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:welitravels/dashboard_screen.dart';
import 'package:welitravels/edit_profile_screen.dart';
import 'package:welitravels/flight_booking_screen.dart';
import 'package:welitravels/gallery_screen.dart';
import 'package:welitravels/hotel_booking_screen.dart';
import 'package:welitravels/image_edit_screen.dart';
import 'package:welitravels/login_screen.dart';
import 'package:welitravels/requirements.dart';
import 'package:welitravels/settings_screen.dart';
import 'package:welitravels/trips_screen.dart';
import 'package:welitravels/visa_application_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _activeCategory;

  final List<String> imgList = [
    'assets/gallery/IMG1.jpg',
    'assets/gallery/IMG2.jpg',
    'assets/gallery/IMG3.jpg',
    'assets/gallery/IMG4.jpg',
    'assets/gallery/IMG5.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTripPopup();
    });
  }

  void _showTripPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/gallery/POP1.jpg',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Limited Offer',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Kids Umrah',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Plan your dream vacation with us and explore the world like never before.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Explore Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Maybe Later',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Hi, Bashir',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/gallery/background1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(),
                const SizedBox(height: 20),
                _buildHeroSection(),
                const SizedBox(height: 20),
                _buildCategoriesSection(),
                const SizedBox(height: 20),
                _buildDealsSection(),
                const SizedBox(height: 10),
                _buildSocialMediaSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/gallery/IMG23.jpg'),
                      fit: BoxFit.cover,
                    ),
                    color: isDarkMode
                        ? Colors.black
                        : const Color.fromARGB(255, 141, 3, 134),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/maguy.jpg'),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Yahya',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.chat_rounded,
                  title: 'Chat with Us',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    _redirectToWhatsApp();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_rounded,
                  title: 'Edit Profile',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfileScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  },
                  // ),
                  // _buildDrawerItem(
                  //   icon: Icons.privacy_tip_rounded,
                  //   title: 'Privacy',
                  //   isDarkMode: isDarkMode,
                  //   onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.hotel_rounded,
                  title: 'Hotel Bookings',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _activeCategory = 'Hotels';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HotelBookingScreen(onComplete: _onComplete)),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.flight_takeoff_rounded,
                  title: 'Flight Reservations',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _activeCategory = 'Hotels';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) =>
                        FlightBookingScreen(
                          onComplete: _onComplete
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://www.welitravel.com/');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  isDarkMode: isDarkMode,
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: const Text('Sign Out',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.code,
                      size: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '© Develop With Effect',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  'v1.0.2',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
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
              Icon(Icons.flight, color: Colors.purple.shade800),
              const SizedBox(width: 8),
              const Text('Choose Travel Plan'),
            ],
          ),
          content: SizedBox(
            height: 162,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPlanCard(
                  title: 'Individual',
                  description: 'Let\'s help you travel to Mecca easily',
                  borderColor: Colors.purple.shade100,
                  textColor: Colors.purple,
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    _showTrip();
                  },
                ),
                const SizedBox(height: 16),
                _buildPlanCard(
                  title: 'With Group',
                  description:
                      'Travel with us and other people to Mecca cheaply',
                  borderColor: Colors.blue.shade100,
                  textColor: Colors.blue,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TripPage()),
                    );
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

  void _showTrip() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedTrip;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.purple.shade800),
                  const SizedBox(width: 10),
                  Text(
                    'Choose Your Trip',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTrip('Umrah January🕋', selectedTrip, (trip) {
                    setState(() {
                      selectedTrip = trip;
                    });
                  }),
                  const SizedBox(height: 12),
                  _buildTrip('Umrah December🕋', selectedTrip, (trip) {
                    setState(() {
                      selectedTrip = trip;
                    });
                  }),
                  const SizedBox(height: 12),
                  _buildTrip('Hajj🕋', selectedTrip, (trip) {
                    setState(() {
                      selectedTrip = trip;
                    });
                  }),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1.2),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red.shade700, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedTrip == null
                      ? null
                      : () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripRequirementsScreen(
                                  tripTitle: selectedTrip!),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fulfill all the following requirements',
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.purple.shade800,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
      },
    );
  }

  Widget _buildTrip(
      String tripTitle, String? selectedTrip, Function(String) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(tripTitle),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              selectedTrip == tripTitle ? Colors.purple.shade50 : Colors.white,
          border: Border.all(
            color: selectedTrip == tripTitle
                ? Colors.purple.shade800
                : Colors.grey.shade300,
            width: selectedTrip == tripTitle ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tripTitle,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: selectedTrip == tripTitle
                    ? Colors.purple.shade800
                    : Colors.black,
              ),
            ),
            if (selectedTrip == tripTitle)
              Icon(Icons.check_circle, color: Colors.purple.shade800),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : isDarkMode
                ? Colors.purple[200]
                : Colors.purple,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Colors.red
              : isDarkMode
                  ? Colors.white
                  : Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
    );
  }

  Widget _buildCarousel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          height: 200.0,
          viewportFraction: 0.85,
        ),
        items: imgList.map((item) {
          return GestureDetector(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditScreen(
                    carouselImages: imgList,
                    onImageEdit: (updatedImages) {
                      setState(() {
                        imgList.clear();
                        imgList.addAll(updatedImages);
                      });
                    },
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: item.startsWith('assets/')
                  ? Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.file(
                      File(item),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Connecting Dreams',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Explore the world with our exclusive offers',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              onPressed: () => _showPlanDialog(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Plan Your Next Trip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _redirectToWhatsApp() async {
    const String phoneNumber = "+256787018472";
    final String message = Uri.encodeComponent(
        "Hello, am contacting you from WeliTravel App and I a few inquries to make");
    final String whatsappUrl = "https://wa.me/$phoneNumber?text=$message";

    final Uri uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    }
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Categories',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryItem(
                  icon: const Icon(Icons.flight_takeoff,
                      size: 20, color: Colors.purple),
                  label: 'Trips',
                  isSelected: _activeCategory == 'Trips',
                  onPressed: () {
                    setState(() {
                      _activeCategory = 'Trips';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TripPage()),
                    );
                  },
                ),
                _buildCategoryItem(
                  icon: const Icon(Icons.burst_mode_outlined,
                      size: 20, color: Colors.purple),
                  label: 'Gallery',
                  isSelected: _activeCategory == 'Gallery',
                  onPressed: () {
                    setState(() {
                      _activeCategory = 'Gallery';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GalleryScreen()),
                    );
                  },
                ),
                _buildCategoryItem(
                  icon: const Icon(Icons.credit_card_rounded,
                      size: 20, color: Colors.purple),
                  label: 'Visa',
                  isSelected: _activeCategory == 'Visa',
                  onPressed: () {
                    setState(() {
                      _activeCategory = 'Visa';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VisaApplicationScreen(onComplete: _onComplete)),
                    );
                  },
                ),
                _buildCategoryItem(
                  icon: const Icon(Icons.local_hotel,
                      size: 20, color: Colors.purple),
                  label: 'Hotels',
                  isSelected: _activeCategory == 'Hotels',
                  onPressed: () {
                    setState(() {
                      _activeCategory = 'Hotels';
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HotelBookingScreen(onComplete: _onComplete)),
                    );
                  },
                ),
                _buildCategoryItem(
                  icon:
                      const Icon(Icons.public, size: 20, color: Colors.purple),
                  label: 'Website',
                  isSelected: _activeCategory == 'Website',
                  onPressed: () async {
                    setState(() {
                      _activeCategory = 'Website';
                    });
                    final Uri url = Uri.parse('https://www.welitravel.com/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not launch website')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isCompleted = false;

  void _onComplete() {
    Navigator.pop(
        context, {'requirement': 'Hotel Accommodation', 'completed': true});
  }

  Widget _buildCategoryItem({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
    required Icon icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.purple[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 15,
              backgroundColor: isSelected ? Colors.white : Colors.purple[100],
              child: icon,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealsSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deals of the Month',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          _buildDealItem(
            'assets/gallery/IMG5.jpg',
            'Umrah Trip',
            '50% off',
          ),
        ],
      ),
    );
  }

  Widget _buildDealItem(String imageUrl, String title, String offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    offer,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildSocialMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connect With Us',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialMediaItem(
                icon: 'assets/icons/tiktok.png',
                name: 'TikTok',
                url: 'https://www.tiktok.com/@welitravel?lang=en',
              ),
              _buildSocialMediaItem(
                icon: 'assets/icons/facebook.png',
                name: 'Facebook',
                url: 'https://www.facebook.com/welitravel/',
              ),
              _buildSocialMediaItem(
                icon: 'assets/icons/twitter.png',
                name: 'X',
                url: 'https://x.com/welitravel?lang=en',
              ),
              _buildSocialMediaItem(
                icon: 'assets/icons/instagram.png',
                name: 'Instagram',
                url: 'https://www.instagram.com/welitravel/?hl=en',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaItem({
    required String icon,
    required String name,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
