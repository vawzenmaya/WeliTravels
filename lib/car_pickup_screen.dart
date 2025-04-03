import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarPickupScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  
  const CarPickupScreen({
    super.key, 
    this.onComplete,
  });

  @override
  State<CarPickupScreen> createState() => _CarPickupScreenState();
}

class _CarPickupScreenState extends State<CarPickupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pickupAddressController = TextEditingController();
  DateTime _pickupDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _pickupTime = const TimeOfDay(hour: 10, minute: 0);
  int _passengers = 1;
  String _selectedVehicleType = 'Sedan';
  bool _includeReturnTrip = false;
  final List<Map<String, dynamic>> _vehicleOptions = [
    {'type': 'Sedan', 'capacity': 3, 'price': 50, 'icon': Icons.directions_car},
    {'type': 'SUV', 'capacity': 5, 'price': 75, 'icon': Icons.directions_car},
    {'type': 'Van', 'capacity': 8, 'price': 100, 'icon': Icons.airport_shuttle},
    {'type': 'Luxury', 'capacity': 3, 'price': 120, 'icon': Icons.airline_seat_individual_suite},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pickupAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airport Transport'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Personal Information'),
                _buildPersonalInfoSection(),
                
                const SizedBox(height: 24),
                _buildSectionTitle('Pickup Details'),
                _buildPickupDetailsSection(),
                
                const SizedBox(height: 24),
                _buildSectionTitle('Vehicle Selection'),
                _buildVehicleSelectionSection(),
                
                const SizedBox(height: 24),
                _buildAdditionalOptionsSection(),
                
                const SizedBox(height: 24),
                _buildPriceSummary(),
                
                const SizedBox(height: 24),
                _buildBookButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade800,
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _pickupAddressController,
              decoration: const InputDecoration(
                labelText: 'Pickup Address',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pickup address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Pickup Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  DateFormat('EEE, MMM d, yyyy').format(_pickupDate),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Pickup Time',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _pickupTime.format(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Number of Passengers:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_passengers > 1) {
                            setState(() {
                              _passengers--;
                              _updateVehicleTypeBasedOnPassengers();
                            });
                          }
                        },
                        color: Colors.purple.shade800,
                      ),
                      Text(
                        '$_passengers',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            _passengers++;
                            _updateVehicleTypeBasedOnPassengers();
                          });
                        },
                        color: Colors.purple.shade800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelectionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: _vehicleOptions.map((vehicle) {
            final bool isSelected = _selectedVehicleType == vehicle['type'];
            final bool isDisabled = _passengers > vehicle['capacity'];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: isDisabled ? null : () {
                  setState(() {
                    _selectedVehicleType = vehicle['type'];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.indigo : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    color: isDisabled 
                        ? Colors.grey.shade200 
                        : (isSelected ? Colors.indigo.withOpacity(0.1) : Colors.white),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        vehicle['icon'],
                        color: isDisabled ? Colors.grey : Colors.purple.shade800,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vehicle['type'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDisabled ? Colors.grey : Colors.black,
                              ),
                            ),
                            Text(
                              'Up to ${vehicle['capacity']} passengers',
                              style: TextStyle(
                                color: isDisabled ? Colors.grey : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${vehicle['price']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.grey : Colors.purple.shade800,
                        ),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check_circle, color: Colors.indigo),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Include Return Trip',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            Switch(
              value: _includeReturnTrip,
              onChanged: (value) {
                setState(() {
                  _includeReturnTrip = value;
                });
              },
              activeColor: Colors.purple.shade800,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    final selectedVehicle = _vehicleOptions.firstWhere(
      (vehicle) => vehicle['type'] == _selectedVehicleType,
      orElse: () => _vehicleOptions.first,
    );
    
    final basePrice = selectedVehicle['price'];
    final returnTripPrice = _includeReturnTrip ? basePrice : 0;
    final totalPrice = basePrice + returnTripPrice;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Base fare (${selectedVehicle['type']})'),
                Text('\$$basePrice'),
              ],
            ),
            if (_includeReturnTrip) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Return trip'),
                  Text('\$$returnTripPrice'),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$$totalPrice',
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
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Book Transport',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _pickupDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple.shade800,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _pickupDate) {
      setState(() {
        _pickupDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple.shade800,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _pickupTime) {
      setState(() {
        _pickupTime = picked;
      });
    }
  }

  void _updateVehicleTypeBasedOnPassengers() {
    // Find a suitable vehicle based on passenger count
    final suitableVehicles = _vehicleOptions
        .where((vehicle) => vehicle['capacity'] >= _passengers)
        .toList();
    
    if (suitableVehicles.isNotEmpty) {
      // If current vehicle is not suitable, select the first suitable one
      if (!suitableVehicles.any((v) => v['type'] == _selectedVehicleType)) {
        _selectedVehicleType = suitableVehicles.first['type'];
      }
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // Get the selected vehicle
      final selectedVehicle = _vehicleOptions.firstWhere(
        (vehicle) => vehicle['type'] == _selectedVehicleType,
      );
      
      // Calculate price
      final basePrice = selectedVehicle['price'];
      final returnTripPrice = _includeReturnTrip ? basePrice : 0;
      final totalPrice = basePrice + returnTripPrice;
      
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Booking Confirmed'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConfirmationRow('Name', _nameController.text),
                _buildConfirmationRow('Phone', _phoneController.text),
                _buildConfirmationRow('Pickup Address', _pickupAddressController.text),
                _buildConfirmationRow('Date', DateFormat('EEE, MMM d, yyyy').format(_pickupDate)),
                _buildConfirmationRow('Time', _pickupTime.format(context)),
                _buildConfirmationRow('Passengers', _passengers.toString()),
                _buildConfirmationRow('Vehicle', _selectedVehicleType),
                _buildConfirmationRow('Return Trip', _includeReturnTrip ? 'Yes' : 'No'),
                const Divider(height: 20),
                _buildConfirmationRow('Total Price', '\$$totalPrice', isBold: true),
                const SizedBox(height: 16),
                const Text(
                  'Your driver will contact you shortly before pickup.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                
                // Call the onComplete callback if provided
                if (widget.onComplete != null) {
                  widget.onComplete!();
                }
                
                // Navigate back to previous screen
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildConfirmationRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _pickupAddressController.clear();
      _pickupDate = DateTime.now().add(const Duration(days: 1));
      _pickupTime = const TimeOfDay(hour: 10, minute: 0);
      _passengers = 1;
      _selectedVehicleType = 'Sedan';
      _includeReturnTrip = false;
    });
  }
}

