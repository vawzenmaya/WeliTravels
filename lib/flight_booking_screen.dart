import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class FlightBookingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const FlightBookingScreen({super.key, required this.onComplete});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  late VideoPlayerController _controller;
  String _selectedClass = 'Economy';
  String _tripType = 'Round trip';
  int _adults = 1;
  int _children = 0;
  int _infantsInSeat = 0;
  int _infantsOnLap = 0;
  String _selectedAirline = 'Ethiopian Airlines';
  DateTime? _departureDate;
  DateTime? _returnDate;
  final TextEditingController _fromController = TextEditingController(text: 'Entebbe EBB');
  final TextEditingController _toController = TextEditingController();
  bool _isSearching = false;

  // Theme colors
  final Color _primaryColor = Colors.purple.shade800;
  final Color _secondaryColor = Colors.green.shade600;
  final Color _backgroundColor = Colors.white;
  final Color _textColor = Colors.grey.shade800;
  
  // Popular destinations for suggestions
  final List<String> _popularDestinations = [
    'Mecca (MEC)', 'Dubai (DXB)', 'London (LHR)', 
    'New York (JFK)', 'Paris (CDG)', 'Tokyo (HND)',
    'Singapore (SIN)', 'Nairobi (NBO)', 'Cairo (CAI)',
    'Johannesburg (JNB)', 'Cape Town (CPT)', 'Addis Ababa (ADD)'
  ];

  final List<String> _airlines = [
    'Ethiopian Airlines', 'UTair Express', 'Rwandair', 'Qatar Airways',
    'Kenya Airways', 'Flydubai', 'Air Tanzania', 'EgyptAir', 'Air Arabia',
    'Turkish Airlines', 'China Southern Airlines', 'Xiamen Airlines',
    'Emirates', 'Shandong Airlines', 'Lao Airlines', 'Sichuan Airlines',
    'IndiGo', 'flyadeal', 'Delta Air Lines', 'Air Botswana',
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/gallery/flight.mov')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Booking'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          )
        ],
      ),
      backgroundColor: _backgroundColor,
      body: Column(
        children: [
          _buildTicketPreview(),
          Expanded(child: _buildBookingForm()),
        ],
      ),
    );
  }

  Widget _buildTicketPreview() {
    return SizedBox(
      height: 238,
      child: Stack(
        children: [
          // Video background
          if (_controller.value.isInitialized)
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            Container(color: Colors.grey.shade300),
          Container(color: Colors.black.withOpacity(0.6)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Boarding Pass',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EBB',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Entebbe',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.flight,
                              color: _secondaryColor,
                              size: 24,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 1,
                              width: 100,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _departureDate != null 
                                ? DateFormat('dd MMM yyyy').format(_departureDate!)
                                : 'Select date',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _toController.text.isNotEmpty ? _toController.text.split(' ').last.replaceAll('(', '').replaceAll(')', '') : 'MEC',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _toController.text.isNotEmpty ? _toController.text.split(' ').first : 'Mecca',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketItem('Passenger', 'John Doe'),
                    _buildTicketItem('Flight', 'SV 1023'),
                    _buildTicketItem('Class', _selectedClass),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketItem('Boarding', '18:30'),
                    _buildTicketItem('Gate', 'B12'),
                    _buildTicketItem('Seat', '23A'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Trip Details'),
              const SizedBox(height: 16),
              _buildTripTypeSelector(),
              const SizedBox(height: 24),
              _buildLocationFields(),
              const SizedBox(height: 24),
              _buildDateFields(),
              const SizedBox(height: 24),
              _buildSectionTitle('Passengers & Preferences'),
              const SizedBox(height: 16),
              _buildPassengerAndClassRow(),
              const SizedBox(height: 24),
              _buildAirlineSelector(),
              const SizedBox(height: 30),
              _buildSearchButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTripTypeButton('Round trip'),
            _buildTripTypeButton('One way'),
            _buildTripTypeButton('Multi-city'),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeButton(String type) {
    final isSelected = _tripType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tripType = type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            type,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationField(
          label: 'From',
          hint: 'Departure city or airport',
          controller: _fromController,
          icon: Icons.flight_takeoff,
          readOnly: true, // Usually departure is fixed
        ),
        const SizedBox(height: 16),
        _buildLocationField(
          label: 'To',
          hint: 'Destination city or airport',
          controller: _toController,
          icon: Icons.flight_land,
          onTap: _showDestinationSelector,
        ),
      ],
    );
  }

  Widget _buildLocationField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly || onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: _primaryColor),
        suffixIcon: controller.text.isNotEmpty && !readOnly
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () => setState(() => controller.clear()),
              )
            : null,
        labelStyle: TextStyle(color: _textColor),
        hintStyle: TextStyle(color: _textColor.withOpacity(0.6)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      style: TextStyle(color: _textColor, fontWeight: FontWeight.w500),
    );
  }

  void _showDestinationSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
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
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search destinations',
                  prefixIcon: Icon(Icons.search, color: _primaryColor),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Popular Destinations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...List.generate(
                    _popularDestinations.length,
                    (index) => ListTile(
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: _primaryColor,
                      ),
                      title: Text(_popularDestinations[index].split(' ').first),
                      subtitle: Text(
                        _popularDestinations[index].split(' ').last,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      onTap: () {
                        setState(() {
                          _toController.text = _popularDestinations[index];
                        });
                        Navigator.pop(context);
                      },
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

  Future<void> _selectDate(bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture
          ? _departureDate ?? DateTime.now()
          : _returnDate ?? (_departureDate?.add(const Duration(days: 7)) ?? DateTime.now().add(const Duration(days: 7))),
      firstDate: isDeparture ? DateTime.now() : (_departureDate ?? DateTime.now()),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: _primaryColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: _textColor,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          // If return date is before the new departure date, reset it
          if (_returnDate != null && _returnDate!.isBefore(_departureDate!)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  Widget _buildDateFields() {
    return Row(
      children: [
        Expanded(child: _buildDateField('Departure', true)),
        if (_tripType != 'One way') const SizedBox(width: 16),
        if (_tripType != 'One way') Expanded(child: _buildDateField('Return', false)),
      ],
    );
  }

  Widget _buildDateField(String label, bool isDeparture) {
    final date = isDeparture ? _departureDate : _returnDate;
    final displayDate = date != null ? DateFormat('dd MMM yyyy').format(date) : 'Select date';

    return InkWell(
      onTap: () => _selectDate(isDeparture),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: _primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: _textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayDate,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerAndClassRow() {
    return Row(
      children: [
        Expanded(child: _buildPassengerSelector()),
        const SizedBox(width: 16),
        Expanded(child: _buildClassSelector()),
      ],
    );
  }

  Widget _buildPassengerSelector() {
    final totalPassengers = _adults + _children + _infantsInSeat + _infantsOnLap;
    
    return InkWell(
      onTap: _showPassengerModal,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.people, color: _primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passengers',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalPassengers ${totalPassengers == 1 ? 'passenger' : 'passengers'}',
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSelector() {
    return InkWell(
      onTap: _showClassSelector,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.airline_seat_recline_normal, color: _primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedClass,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  void _showClassSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Class',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...['Economy', 'Business', 'First Class'].map((cls) => 
              RadioListTile<String>(
                title: Text(cls),
                value: cls,
                groupValue: _selectedClass,
                activeColor: _primaryColor,
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAirlineSelector() {
    return InkWell(
      onTap: _showAirlineSelector,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.flight, color: _primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferred Airline',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedAirline,
                    style: TextStyle(
                      color: _textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  void _showAirlineSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Column(
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
                'Select Airline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _airlines.length,
                itemBuilder: (context, index) => RadioListTile<String>(
                  title: Text(_airlines[index]),
                  value: _airlines[index],
                  groupValue: _selectedAirline,
                  activeColor: _primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _selectedAirline = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _isSearching ? null : _handleSearch,
      style: ElevatedButton.styleFrom(
        backgroundColor: _secondaryColor,
        disabledBackgroundColor: Colors.grey.shade400,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: _isSearching
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Searching...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : const Text(
              'Search Flights',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }

  void _showPassengerModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Passengers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildPassengerCounter(
                'Adults',
                '12+ years',
                _adults,
                (v) => setModalState(() => _adults = v),
                minValue: 1, // At least one adult required
              ),
              _buildPassengerCounter(
                'Children',
                '2-11 years',
                _children,
                (v) => setModalState(() => _children = v),
              ),
              _buildPassengerCounter(
                'Infants (seat)',
                'Under 2 years',
                _infantsInSeat,
                (v) => setModalState(() => _infantsInSeat = v),
              ),
              _buildPassengerCounter(
                'Infants (lap)',
                'Under 2 years',
                _infantsOnLap,
                (v) => setModalState(() => _infantsOnLap = v),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Update the main state
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCounter(
    String title,
    String subtitle,
    int value,
    Function(int) onChanged, {
    int minValue = 0,
    int maxValue = 9,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: _textColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                onPressed: value > minValue
                    ? () => onChanged(value - 1)
                    : null,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$value',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildCounterButton(
                icon: Icons.add,
                onPressed: value < maxValue
                    ? () => onChanged(value + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: onPressed != null ? _primaryColor.withOpacity(0.1) : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: onPressed != null ? _primaryColor : Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _handleSearch() {
    // Validate inputs
    if (_toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a destination'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a departure date'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_tripType == 'Round trip' && _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a return date'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show loading state
    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        
        // Call the completion callback
        widget.onComplete();
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.support_agent,
              color: _primaryColor,
            ),
            const SizedBox(width: 12),
            const Text(
              'Booking Assistance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need help with your flight booking?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Our travel experts are available 24/7 to assist you with your booking needs.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _launchWhatsApp('I need help with flight booking');
            },
            icon: const Icon(
              Icons.chat_outlined,
              color: Colors.white,
              size: 20,
            ),
            label: const Text(
              'Chat with Agent',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
          const SnackBar(
            content: Text('Could not launch WhatsApp'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildTicketItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

