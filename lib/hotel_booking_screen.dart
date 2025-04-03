import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HotelBookingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const HotelBookingScreen({super.key, required this.onComplete});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> with SingleTickerProviderStateMixin {
  final List<Hotel> _hotels = [
    Hotel(
      id: '1',
      name: 'Royal Makkah Clock Tower',
      imagePath: 'assets/images/Hot1.jpg',
      price: 450,
      rating: 4.0,
      location: 'Mecca, Saudi Arabia',
      amenities: ['wifi', 'pool', 'spa', 'restaurant', 'roomservice', 'breakfast'],
      rates: '399K reviews'
    ),
    Hotel(
      id: '2',
      name: 'Madinah Oberoi Hotel',
      imagePath: 'assets/images/Hot2.jpg',
      price: 380,
      rating: 2.8,
      location: 'Madinah, Saudi Arabia',
      amenities: ['wifi', 'prayer', 'gym', 'restaurant', 'roomservice', 'breakfast'],
      rates: '283K reviews'
    ),
    Hotel(
      id: '3',
      name: 'Al Badr Hotel',
      imagePath: 'assets/images/Hot3.jpg',
      price: 270,
      rating: 3.7,
      location: 'Madinah, Saudi Arabia',
      amenities: ['wifi', 'prayer', 'gym', 'restaurant', 'roomservice', 'breakfast'],
      rates: '375K reviews'
    ),
    Hotel(
      id: '4',
      name: 'Makkah Grand Hotel',
      imagePath: 'assets/images/Hot4.jpg',
      price: 320,
      rating: 4.9,
      location: 'Mecca, Saudi Arabia',
      amenities: ['wifi', 'prayer', 'gym', 'restaurant', 'roomservice', 'breakfast'],
      rates: '399K reviews'
    ),
    Hotel(
      id: '5',
      name: 'Zamzam Pullman',
      imagePath: 'assets/images/Hot5.jpg',
      price: 590,
      rating: 5,
      location: 'Mecca, Saudi Arabia',
      amenities: ['wifi', 'prayer', 'gym', 'restaurant', 'roomservice', 'breakfast'],
      rates: '5M reviews'
    ),
  ];
  
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;
  String _selectedSort = 'Recommended';
  double _priceRange = 1000;
  final Color _primaryColor = Colors.purple.shade800;
  final Color _secondaryColor = Colors.green.shade600;

  List<String> _selectedAmenities = [];
  List<Hotel> _filteredHotels = [];
  List<Hotel> _likedHotels = [];
  // ignore: unused_field
  int _selectedTabIndex = 0;
  late TabController _tabController;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _filteredHotels = List.from(_hotels);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _applyFilters() {
    setState(() {
      _filteredHotels = _hotels.where((hotel) {
        // Apply price filter
        if (hotel.price > _priceRange) {
          return false;
        }
        
        // Apply amenities filter
        if (_selectedAmenities.isNotEmpty) {
          for (String amenity in _selectedAmenities) {
            if (!hotel.amenities.contains(amenity.toLowerCase().replaceAll(' ', ''))) {
              return false;
            }
          }
        }
        
        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          return hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                 hotel.location.toLowerCase().contains(_searchQuery.toLowerCase());
        }
        
        return true;
      }).toList();
      
      // Apply sorting
      _sortHotels();
    });
  }
  
  void _sortHotels() {
    switch (_selectedSort) {
      case 'Price: Low to High':
        _filteredHotels.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        _filteredHotels.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        _filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Recommended':
      default:
        // No specific sorting for recommended
        break;
    }
  }
  
  void _toggleLike(Hotel hotel) {
    setState(() {
      if (_likedHotels.any((h) => h.id == hotel.id)) {
        _likedHotels.removeWhere((h) => h.id == hotel.id);
      } else {
        _likedHotels.add(hotel);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Booking'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Hotels'),
            Tab(text: 'Liked Hotels'),
          ],
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSortDropdown(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHotelList(_filteredHotels),
                _buildHotelList(_likedHotels),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search hotels...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
      ),
    );
  }
  
  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedSort,
        items: ['Recommended', 'Price: Low to High', 'Price: High to Low', 'Rating']
            .map((sort) => DropdownMenuItem(
                  value: sort,
                  child: Text(sort),
                ))
            .toList(),
        onChanged: (value) {
          setState(() => _selectedSort = value!);
          _sortHotels();
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
  
Widget _buildHotelList(List<Hotel> hotels) {
  if (hotels.isEmpty) {
    return const Center(
      child: Text('No hotels found matching your criteria.'),
    );
  }
    
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: hotels.length,
    itemBuilder: (context, index) => _HotelCard(
      hotel: hotels[index],
      onComplete: widget.onComplete,
      initialCheckInDate: _checkInDate,
      initialCheckOutDate: _checkOutDate,
      initialGuests: _guests,
      isLiked: _likedHotels.any((h) => h.id == hotels[index].id),
      onLike: () => _toggleLike(hotels[index]),
      updateDates: (checkIn, checkOut) {
        setState(() {
          _checkInDate = checkIn;
          _checkOutDate = checkOut;
        });
      },
      updateGuests: (guests) {
        setState(() => _guests = guests);
      },
    ),
  );
}
  
  Widget _buildFiltersModal() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$100'),
              Text('\$${_priceRange.round()}'),
              Text('\$1000'),
            ],
          ),
          Slider(
            value: _priceRange,
            min: 100,
            max: 1000,
            divisions: 9,
            label: '\$${_priceRange.round()}',
            onChanged: (value) => setState(() => _priceRange = value),
            activeColor: _primaryColor,
          ),
          const SizedBox(height: 20),
          const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: [
              _buildAmenityChip('WiFi'),
              _buildAmenityChip('Pool'),
              _buildAmenityChip('Spa'),
              _buildAmenityChip('Restaurant'),
              _buildAmenityChip('Room Service'),
              _buildAmenityChip('Prayer'),
              _buildAmenityChip('Gym'),
              _buildAmenityChip('Breakfast'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _secondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAmenityChip(String amenity) {
    final isSelected = _selectedAmenities.contains(amenity);
    return FilterChip(
      label: Text(amenity),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedAmenities.add(amenity);
          } else {
            _selectedAmenities.remove(amenity);
          }
        });
      },
      selectedColor: _primaryColor.withOpacity(0.2),
      labelStyle: TextStyle(color: isSelected ? _primaryColor : Colors.black),
    );
  }
  
  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildFiltersModal(),
        ),
      ),
    );
  }
}

class _HotelCard extends StatefulWidget {
  final Hotel hotel;
  final VoidCallback onComplete;
  final DateTime? initialCheckInDate;
  final DateTime? initialCheckOutDate;
  final int initialGuests;
  final bool isLiked;
  final VoidCallback onLike;
  final Function(DateTime?, DateTime?) updateDates;
  final Function(int) updateGuests;

  const _HotelCard({
    required this.hotel,
    required this.onComplete,
    required this.initialCheckInDate,
    required this.initialCheckOutDate,
    required this.initialGuests,
    required this.isLiked,
    required this.onLike,
    required this.updateDates,
    required this.updateGuests,
  });


  @override
  State<_HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<_HotelCard> {
  late DateTime? _checkInDate;
  late DateTime? _checkOutDate;
  late int _guests;
  String _selectedRoomOption = '1 room 1 bed';

  @override
  void initState() {
    super.initState();
    _checkInDate = widget.initialCheckInDate;
    _checkOutDate = widget.initialCheckOutDate;
    _guests = widget.initialGuests;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.asset(
                  widget.hotel.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: Icon(
                    widget.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: widget.isLiked ? Colors.red : Colors.white,
                  ),
                  onPressed: widget.onLike,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.hotel.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildRatingStars(widget.hotel.rating),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.hotel.location,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: widget.hotel.amenities
                      .map((amenity) => _buildAmenityIcon(amenity))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.hotel.price}/night',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.purple.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showBookingDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade800,
                      ),
                      child: const Text('Book Now', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating.floor() ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        Text(widget.hotel.rates, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAmenityIcon(String amenity) {
    final Map<String, IconData> amenityIcons = {
      'wifi': Icons.wifi,
      'pool': Icons.pool,
      'spa': Icons.spa,
      'restaurant': Icons.restaurant,
      'prayer': Icons.mosque,
      'gym': Icons.fitness_center,
      'roomservice': Icons.room_service,
      'breakfast': Icons.free_breakfast
    };

    return Chip(
      avatar: Icon(amenityIcons[amenity] ?? Icons.hotel, size: 18),
      label: Text(amenity),
      backgroundColor: Colors.grey.shade100,
      labelStyle: const TextStyle(fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  void _showBookingDialog(BuildContext context) {
    // Create local variables for the dialog state
    DateTime? dialogCheckInDate = _checkInDate;
    DateTime? dialogCheckOutDate = _checkOutDate;
    int dialogGuests = _guests;
    String dialogRoomOption = _selectedRoomOption;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text('Booking Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date pickers with local dialog state
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      dialogCheckInDate == null 
                        ? 'Select Check-in Date' 
                        : 'Check-in: ${DateFormat('MMM dd, yyyy').format(dialogCheckInDate!)}'
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
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
                      
                      if (picked != null) {
                        setDialogState(() {
                          dialogCheckInDate = picked;
                          // If check-out date is before check-in date, update it
                          if (dialogCheckOutDate != null && 
                              dialogCheckOutDate!.isBefore(dialogCheckInDate!)) {
                            dialogCheckOutDate = dialogCheckInDate!.add(const Duration(days: 1));
                          }
                        });
                      }
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      dialogCheckOutDate == null 
                        ? 'Select Check-out Date' 
                        : 'Check-out: ${DateFormat('MMM dd, yyyy').format(dialogCheckOutDate!)}'
                    ),
                    onTap: () async {
                      // Don't allow selecting check-out before check-in
                      if (dialogCheckInDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select check-in date first')),
                        );
                        return;
                      }
                      
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: dialogCheckInDate!.add(const Duration(days: 1)),
                        firstDate: dialogCheckInDate!.add(const Duration(days: 1)),
                        lastDate: dialogCheckInDate!.add(const Duration(days: 365)),
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
                      
                      if (picked != null) {
                        setDialogState(() {
                          dialogCheckOutDate = picked;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Guest selector with real-time updates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Guests', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (dialogGuests > 1) {
                                setDialogState(() {
                                  dialogGuests--;
                                });
                              }
                            },
                            color: Colors.purple.shade800,
                          ),
                          Text(
                            '$dialogGuests', 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setDialogState(() {
                                dialogGuests++;
                              });
                            },
                            color: Colors.purple.shade800,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Room selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Room & Beds', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: dialogRoomOption,
                        items: [
                          '1 room 1 bed',
                          '1 room 2 beds',
                          '2 rooms 1 bed',
                          '2 rooms 2 beds',
                          '3 rooms 2 beds',
                          '3 rooms 3 beds',
                        ]
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => dialogRoomOption = value!);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Show booking summary if dates are selected
                  if (dialogCheckInDate != null && dialogCheckOutDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stay: ${dialogCheckOutDate!.difference(dialogCheckInDate!).inDays} nights',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total: \$${(widget.hotel.price * dialogCheckOutDate!.difference(dialogCheckInDate!).inDays).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update the parent widget's state with the dialog values
                  setState(() {
                    _checkInDate = dialogCheckInDate;
                    _checkOutDate = dialogCheckOutDate;
                    _guests = dialogGuests;
                    _selectedRoomOption = dialogRoomOption;
                  });
                  
                  // Update the parent class state
                  widget.updateDates(dialogCheckInDate, dialogCheckOutDate);
                  widget.updateGuests(dialogGuests);
                  
                  Navigator.pop(context);
                  _showBookingConfirmation(context, dialogRoomOption);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade800,
                ),
                child: const Text('Confirm Booking', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
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
    
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          // If check-in date is after check-out date, update check-out date too
          _checkInDate = picked;
          if (_checkOutDate != null && picked.isAfter(_checkOutDate!)) {
            _checkOutDate = picked.add(const Duration(days: 1));
          }
        } else {
          // Ensure check-out is after check-in
          if (_checkInDate != null && picked.isBefore(_checkInDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Check-out date must be after check-in date')),
            );
          } else {
            _checkOutDate = picked;
          }
        }
        
        // Update parent widget's state
        widget.updateDates(_checkInDate, _checkOutDate);
      });
    }
  }

  void _showBookingConfirmation(BuildContext context, String roomOption) {
    final formatter = DateFormat('MMM dd, yyyy');
    final checkInFormatted = _checkInDate != null ? formatter.format(_checkInDate!) : 'Not selected';
    final checkOutFormatted = _checkOutDate != null ? formatter.format(_checkOutDate!) : 'Not selected';
    final nights = _checkInDate != null && _checkOutDate != null
         ? _checkOutDate!.difference(_checkInDate!).inDays
         : 0;
    final totalPrice = nights * widget.hotel.price;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 8),
            const Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmationRow('Hotel', widget.hotel.name),
            _buildConfirmationRow('Location', widget.hotel.location),
            _buildConfirmationRow('Check-in', checkInFormatted),
            _buildConfirmationRow('Check-out', checkOutFormatted),
            _buildConfirmationRow('Guests', '$_guests'),
            _buildConfirmationRow('Room option', roomOption),
            if (nights > 0) _buildConfirmationRow('Total nights', '$nights'),
            if (nights > 0) _buildConfirmationRow('Total price', '\$${totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Thank you for your booking! A confirmation has been sent to your email.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onComplete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade800,
            ),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConfirmationRow(String label, String value) {
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
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class Hotel {
  final String id;
  final String name;
  final String imagePath;
  final double price;
  final double rating;
  final String location;
  final String rates;
  final List<String> amenities;

  Hotel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.location,
    required this.rates,
    required this.amenities,
  });
}
