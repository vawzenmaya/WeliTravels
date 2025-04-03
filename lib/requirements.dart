import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:welitravels/car_pickup_screen.dart';
import 'package:welitravels/flight_booking_screen.dart';
import 'package:welitravels/hotel_booking_screen.dart';
import 'package:welitravels/visa_application_screen.dart';

class TripRequirementsScreen extends StatefulWidget {
  final String tripTitle;

  const TripRequirementsScreen({super.key, required this.tripTitle});

  @override
  _TripRequirementsScreenState createState() => _TripRequirementsScreenState();
}

class _TripRequirementsScreenState extends State<TripRequirementsScreen> {
  final List<Requirement> _requirements = [
    Requirement(
      title: 'Valid Passport',
      description: '6+ months validity remaining',
      actionType: ActionType.dialog,
      whatsappMessage: 'I need help obtaining a passport',
    ),
    Requirement(
      title: 'Visa Documentation',
      description: 'Required for entry',
      actionType: ActionType.visaScreen,
    ),
    Requirement(
      title: 'Flight Tickets',
      description: 'Round-trip booking',
      actionType: ActionType.flightScreen,
    ),
    Requirement(
      title: 'Hotel Accommodation',
      description: 'Verified halal options',
      actionType: ActionType.hotelScreen,
    ),
    Requirement(
      title: 'Airport Transfer',
      description: 'Optional private car service',
      actionType: ActionType.optional,
      isOptional: true,
    ),
  ];

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _currentStep = _calculateInitialStep();
  }

  int _calculateInitialStep() {
    for (int i = 0; i < _requirements.length; i++) {
      if (!_requirements[i].isCompleted && !_requirements[i].isOptional) {
        return i;
      }
    }
    return _requirements.length - 1;
  }

  void _handleRequirementTap(int index) async {
    final requirement = _requirements[index];
    
    if (requirement.isCompleted) return;

    switch (requirement.actionType) {
      case ActionType.dialog:
        final hasPassport = await _showPassportDialog(context);
        if (hasPassport ?? false) {
          _markComplete(index);
        } else {
          _launchWhatsApp(requirement.whatsappMessage!);
        }
        break;

      case ActionType.whatsapp:
        _launchWhatsApp(requirement.whatsappMessage!);
        break;

      case ActionType.visaScreen:
        _navigateToVisaScreen();
        break;

      case ActionType.flightScreen:
        _navigateToFlightScreen();
        break;

      case ActionType.hotelScreen:
        _navigateToHotelScreen();
        break;

      case ActionType.optional:
        final needsTransfer = await _showCarPickupDialog(context);
        if (needsTransfer ?? false) {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (_) => CarPickupScreen(
                onComplete: () => _markRequirementComplete('Airport Transfer'),
              ),
            ),
          );
        } else {
          _markComplete(index);
        }
        break;
     }
  }

  Future<bool?> _showPassportDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Passport Verification'),
        content: const Text('Do you have a valid passport with at least 6 months validity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Get Assistance'
              ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade800,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'I Have Passport',
              style: TextStyle(
                color: Colors.white
              ),
              ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showCarPickupDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Airport Transfer'),
        content: const Text('Would you like to arrange private airport transfer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No Thanks'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade800,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Arrange Transfer',
              style: TextStyle(
                color: Colors.white
              ),
              ),
          ),
        ],
      ),
    );
  }

  void _markComplete(int index) {
    setState(() {
      _requirements[index].isCompleted = true;
      if (index < _requirements.length - 1) {
        _currentStep = index + 1;
      }
    });
  }

  Future<void> _launchWhatsApp(String message) async {
    const phone = '+256787018472';
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripTitle),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildTimeline()),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journey Preparation Checklist',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.purple.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete these steps to finalize your spiritual journey',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _requirements.length,
      separatorBuilder: (_, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _TimelineItem(
        requirement: _requirements[index],
        isActive: index <= _currentStep,
        isFirst: index == 0,
        isLast: index == _requirements.length - 1,
        onTap: () => _handleRequirementTap(index),
      ),
    );
  }

  Widget _buildContinueButton() {
    final allComplete = _requirements
        .where((r) => !r.isOptional)
        .every((r) => r.isCompleted);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: allComplete 
                    ? Colors.green.shade600 
                    : Colors.purple.shade800,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: allComplete ? () => _handleCompletion() : null,
              child: Text(
                allComplete ? 'Complete Booking' : 'Continue Preparation',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
    );
  }

  void _handleCompletion() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => const PaymentScreen()),
    );
  }

    void _navigateToVisaScreen() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => VisaApplicationScreen(
        onComplete: () => _markRequirementComplete('Visa Documentation'),
      ),
    ));
  }

  void _navigateToFlightScreen() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => FlightBookingScreen(
        onComplete: () => _markRequirementComplete('Flight Tickets'),
      ),
    ));
  }

  void _navigateToHotelScreen() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => HotelBookingScreen(
        onComplete: () => _markRequirementComplete('Hotel Accommodation'),
      ),
    ));
  }

  void _markRequirementComplete(String title) {
    setState(() {
      final index = _requirements.indexWhere((r) => r.title == title);
      if (index != -1) {
        _requirements[index].isCompleted = true;
        _currentStep = index < _requirements.length - 1 ? index + 1 : index;
      }
    });
  }
}

class _TimelineItem extends StatelessWidget {
  final Requirement requirement;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineItem({
    required this.requirement,
    required this.isActive,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: requirement.isCompleted ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimelineIndicator(),
            const SizedBox(width: 16),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIndicator() {
    return Column(
      children: [
        if (!isFirst) Container(
          width: 2,
          height: 24,
          color: isActive ? Colors.purple.shade200 : Colors.grey.shade300,
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: requirement.isCompleted 
                ? Colors.green.shade400 
                : isActive 
                    ? Colors.purple.shade800 
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: requirement.isCompleted
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        if (!isLast) Container(
          width: 2,
          height: 24,
          color: isActive ? Colors.purple.shade200 : Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          requirement.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: requirement.isCompleted 
                ? Colors.green.shade800 
                : Colors.purple.shade900,
            decoration: requirement.isCompleted 
                ? TextDecoration.lineThrough 
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          requirement.description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        if (requirement.isOptional)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Optional Service',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.purple.shade800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ignore: unused_element
class _RequirementDetailScreen extends StatelessWidget {
  final Requirement requirement;

  const _RequirementDetailScreen({required this.requirement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(requirement.title),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Requirements for ${requirement.title}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Payment Processing Screen'),
      ),
    );
  }
}

// enum ActionType { dialog, whatsapp, screen, optional }

class Requirement {
  final String title;
  final String description;
  final ActionType actionType;
  final String? whatsappMessage;
  bool isCompleted;
  final bool isOptional;

  Requirement({
    required this.title,
    required this.description,
    required this.actionType,
    this.whatsappMessage,
    this.isCompleted = false,
    this.isOptional = false,
  });
}
enum ActionType {
  dialog,
  whatsapp,
  visaScreen,
  flightScreen,
  hotelScreen,
  optional
}