import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'visa_payment_screen.dart';

class VisaApplicationScreen extends StatefulWidget {
  final Function? onComplete;
  
  const VisaApplicationScreen({Key? key, this.onComplete}) : super(key: key);

  @override
  _VisaApplicationScreenState createState() => _VisaApplicationScreenState();
}

class _VisaApplicationScreenState extends State<VisaApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  DateTime? _selectedTravelDate;
  DateTime? _selectedReturnDate;
  String _selectedVisaType = 'Tourist';
  String _selectedCountry = 'Saudi Arabia';
  
  final List<String> _visaTypes = ['Tourist', 'Business', 'Umrah', 'Hajj', 'Transit'];
  final List<String> _countries = ['Saudi Arabia', 'UAE', 'Qatar', 'Kuwait', 'Oman', 'Bahrain'];

  bool _isUploading = false;
  bool _passportUploaded = false;
  bool _photoUploaded = false;
  bool _flightItineraryUploaded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _selectTravelDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTravelDate ?? DateTime.now().add(const Duration(days: 14)),
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
    if (picked != null && picked != _selectedTravelDate) {
      setState(() {
        _selectedTravelDate = picked;
        _selectedReturnDate = picked.add(const Duration(days: 14));
      });
    }
  }

  void _selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedReturnDate ?? 
          (_selectedTravelDate?.add(const Duration(days: 14)) ?? 
           DateTime.now().add(const Duration(days: 28))),
      firstDate: _selectedTravelDate ?? DateTime.now(),
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
    if (picked != null && picked != _selectedReturnDate) {
      setState(() {
        _selectedReturnDate = picked;
      });
    }
  }

  void _simulateDocumentUpload(String documentType) {
    setState(() {
      _isUploading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isUploading = false;
        switch (documentType) {
          case 'passport':
            _passportUploaded = true;
            break;
          case 'photo':
            _photoUploaded = true;
            break;
          case 'itinerary':
            _flightItineraryUploaded = true;
            break;
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$documentType uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      if (!_passportUploaded || !_photoUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload all required documents'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisaPaymentScreen(
            visaType: _selectedVisaType,
            country: _selectedCountry,
            travelDate: _selectedTravelDate!,
            onComplete: widget.onComplete,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Application'),
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
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name (as on the passport)',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passportController,
                  label: 'Passport Number',
                  icon: Icons.credit_card,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your passport number';
                    }
                    if (value.length < 6) {
                      return 'Passport number is too short';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                _buildSectionTitle('Visa Details'),
                
                _buildDropdown(
                  label: 'Destination Country',
                  value: _selectedCountry,
                  items: _countries,
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Visa Type',
                  value: _selectedVisaType,
                  items: _visaTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedVisaType = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                _buildDateSelector(
                  label: 'Travel Date',
                  value: _selectedTravelDate,
                  onTap: _selectTravelDate,
                ),
                
                const SizedBox(height: 16),
                _buildDateSelector(
                  label: 'Return Date',
                  value: _selectedReturnDate,
                  onTap: _selectReturnDate,
                ),
                
                const SizedBox(height: 24),
                _buildSectionTitle('Required Documents'),
                
                _buildDocumentUploader(
                  title: 'Passport Copy',
                  subtitle: 'Upload clear scan of passport bio page',
                  icon: Icons.description,
                  isUploaded: _passportUploaded,
                  isUploading: _isUploading,
                  onTap: () => _simulateDocumentUpload('passport'),
                ),
                
                _buildDocumentUploader(
                  title: 'Recent Photograph',
                  subtitle: 'White background, 35x45mm',
                  icon: Icons.photo_camera,
                  isUploaded: _photoUploaded,
                  isUploading: _isUploading,
                  onTap: () => _simulateDocumentUpload('photo'),
                ),
                
                _buildDocumentUploader(
                  title: 'Flight Itinerary',
                  subtitle: 'If already booked',
                  icon: Icons.flight,
                  isUploaded: _flightItineraryUploaded,
                  isUploading: _isUploading,
                  isOptional: true,
                  onTap: () => _simulateDocumentUpload('itinerary'),
                ),
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitApplication,
                    child: const Text(
                      'Continue to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade900,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.purple.shade800),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple.shade800, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple.shade800, width: 2),
        ),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value == null
              ? 'Select Date'
              : DateFormat('dd MMM yyyy').format(value),
        ),
      ),
    );
  }

  Widget _buildDocumentUploader({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isUploaded,
    required bool isUploading,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUploaded ? Colors.green : Colors.grey.shade300,
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isUploaded ? Colors.green.withOpacity(0.1) : Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isUploaded ? Icons.check_circle : icon,
            color: isUploaded ? Colors.green : Colors.purple.shade800,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isOptional)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Optional',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isUploading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : isUploaded
                ? const Icon(Icons.check_circle, color: Colors.green)
                : SizedBox(
                    width: 80, // Fixed width for the button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade800,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        minimumSize: const Size(60, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onTap,
                      child: const Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
        onTap: isUploaded || isUploading ? null : onTap,
      ),
    );
  }
}
