import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'package:welitravels/edit_profile_screen.dart';
import 'package:welitravels/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Color _primaryColor = Colors.purple.shade800;
  final Color _secondaryColor = Colors.deepPurple.shade700;
  final Color _backgroundColor = Colors.grey.shade50;
  final Color _cardColor = Colors.white;

  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English';
  String _appVersion = '1.0.0';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: _primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 16),
                  _buildSectionTitle('App Preferences'),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      title: 'Dark Mode',
                      subtitle: 'Switch between light and dark theme',
                      icon: Icons.dark_mode,
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          _darkModeEnabled = value;
                        });
                        // Implement theme change logic here
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Language',
                      subtitle: _selectedLanguage,
                      icon: Icons.language,
                      onTap: _showLanguageSelector,
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Currency',
                      subtitle: _selectedCurrency,
                      icon: Icons.currency_exchange,
                      onTap: _showCurrencySelector,
                    ),
                  ]),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Notifications'),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      title: 'Push Notifications',
                      subtitle: 'Receive push notifications',
                      icon: Icons.notifications,
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                    _buildDivider(),
                    _buildSwitchTile(
                      title: 'Email Notifications',
                      subtitle: 'Receive email updates',
                      icon: Icons.email,
                      value: _emailNotificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _emailNotificationsEnabled = value;
                        });
                      },
                    ),
                  ]),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Security'),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      title: 'Biometric Authentication',
                      subtitle: 'Use fingerprint or face ID to login',
                      icon: Icons.fingerprint,
                      value: _biometricEnabled,
                      onChanged: (value) {
                        setState(() {
                          _biometricEnabled = value;
                        });
                        // Implement biometric logic here
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      icon: Icons.lock,
                      onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen()),
                          );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Change password tapped'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Privacy Settings',
                      subtitle: 'Manage your data and privacy',
                      icon: Icons.privacy_tip,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Privacy settings tapped'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ]),
                  
                  const SizedBox(height: 16),
                  _buildSectionTitle('Support & About'),
                  _buildSettingsCard([
                    _buildNavigationTile(
                      title: 'Help Center',
                      subtitle: 'Get help with using the app',
                      icon: Icons.help,
                      onTap: () {
                        _launchURL('https://www.welitravel.com/');
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Contact Us',
                      subtitle: 'Reach out to our support team',
                      icon: Icons.support_agent,
                      onTap: _showContactOptions,
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Rate the App',
                      subtitle: 'Tell us what you think',
                      icon: Icons.star,
                      onTap: () {
                        _launchAppStore();
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'Share the App',
                      subtitle: 'Invite friends to join',
                      icon: Icons.share,
                      onTap: () {
                        Share.share(
                          'Check out this amazing travel app: https://www.welitravel.com/',
                          subject: 'Travel App Invitation',
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildNavigationTile(
                      title: 'About',
                      subtitle: 'Version $_appVersion',
                      icon: Icons.info,
                      onTap: _showAboutDialog,
                    ),
                  ]),
                  
                  const SizedBox(height: 16),
                  _buildSettingsCard([
                    ListTile(
                      title: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red.shade700,
                      ),
                      onTap: _showLogoutConfirmation,
                    ),
                  ]),
                  
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'MADE BY VAWZEN',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _primaryColor.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/maguy.jpg'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kasule Vawzen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'vawzenmaya@gmail.com',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: _primaryColor,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: _primaryColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: _primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: _primaryColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      endIndent: 16,
      color: Colors.grey.shade200,
    );
  }

  void _showLanguageSelector() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Arabic'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  activeColor: _primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Language changed to $_selectedLanguage'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector() {
    final currencies = [
      {'code': 'USD', 'name': 'US Dollar'},
      {'code': 'EUR', 'name': 'Euro'},
      {'code': 'GBP', 'name': 'British Pound'},
      {'code': 'JPY', 'name': 'Japanese Yen'},
      {'code': 'CAD', 'name': 'Canadian Dollar'},
      {'code': 'AUD', 'name': 'Australian Dollar'},
      {'code': 'UGX', 'name': 'Ugandan Shilling'},
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Currency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return RadioListTile<String>(
                  title: Text(currency['name']!),
                  subtitle: Text(currency['code']!),
                  value: currency['code']!,
                  groupValue: _selectedCurrency,
                  activeColor: _primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Currency changed to $_selectedCurrency'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactOption(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'vawzenmaya@gmail.com',
              onTap: () {
                Navigator.pop(context);
                _launchURL('vawzenmaya@gmail.com');
              },
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.phone,
              title: 'Call Support',
              subtitle: '+257 762 540 123',
              onTap: () {
                Navigator.pop(context);
                _launchURL('tel:+257 762 540 123');
              },
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Live chat feature coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.chat_outlined,
              title: 'WhatsApp',
              subtitle: '+256 787 018 472',
              onTap: () {
                Navigator.pop(context);
                _launchURL('https://wa.me/256787018472');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: _primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info,
                color: _primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            const Text('About'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Travel App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version: $_appVersion',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This app helps you discover amazing travel destinations, book flights, hotels, and create unforgettable travel experiences.',
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2025 Develop With Effect. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
                Navigator.pop(context);
              _launchURL('https://www.welitravel.com/');
            },
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                color: _primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
                Navigator.pop(context);
              _launchURL('https://www.welitravel.com/');
            },
            child: Text(
              'Terms of Service',
              style: TextStyle(
                color: _primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white70),),
          ),
        ],
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

  Future<void> _launchAppStore() async {
    final String url;
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=com.example.travelapp';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/id123456789';
    } else {
      url = 'https://example.com/app';
    }
    
    await _launchURL(url);
  }
}

