import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VisaProcessingScreen extends StatefulWidget {
  final String visaType;
  final String country;
  final DateTime travelDate;
  final Function? onComplete;

  const VisaProcessingScreen({
    Key? key,
    required this.visaType,
    required this.country,
    required this.travelDate,
    this.onComplete,
  }) : super(key: key);

  @override
  _VisaProcessingScreenState createState() => _VisaProcessingScreenState();
}

class _VisaProcessingScreenState extends State<VisaProcessingScreen> {
  late DateTime _estimatedCompletionDate;
  late Timer _timer;
  late Duration _remainingTime;
  
  // Processing stages
  final List<ProcessingStage> _stages = [
    ProcessingStage(
      title: 'Application Received',
      description: 'Your visa application has been received and is being prepared for processing.',
      isCompleted: true,
      completionDate: DateTime.now(),
    ),
    ProcessingStage(
      title: 'Document Verification',
      description: 'Your documents are being verified for authenticity and completeness.',
      isCompleted: false,
    ),
    ProcessingStage(
      title: 'Embassy Processing',
      description: 'Your application is being processed by the embassy.',
      isCompleted: false,
    ),
    ProcessingStage(
      title: 'Visa Decision',
      description: 'Final decision on your visa application.',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Calculate estimated completion date (5 working days from now)
    _estimatedCompletionDate = _calculateWorkingDays(DateTime.now(), 5);
    
    // Initialize remaining time
    _updateRemainingTime();
    
    // Start timer to update countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
    
    // Simulate document verification completion after 1 minute
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          _stages[1].isCompleted = true;
          _stages[1].completionDate = DateTime.now();
        });
      }
    });
    
    // For demo purposes, we'll complete the process if the user stays on this screen
    // In a real app, this would be handled by backend notifications
    if (widget.onComplete != null) {
      Future.delayed(const Duration(minutes: 2), () {
        if (mounted) {
          widget.onComplete!();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    if (now.isBefore(_estimatedCompletionDate)) {
      setState(() {
        _remainingTime = _estimatedCompletionDate.difference(now);
      });
    } else {
      setState(() {
        _remainingTime = Duration.zero;
      });
      _timer.cancel();
    }
  }

  DateTime _calculateWorkingDays(DateTime startDate, int workingDays) {
    int daysToAdd = 0;
    int workingDaysAdded = 0;
    
    while (workingDaysAdded < workingDays) {
      daysToAdd++;
      final date = startDate.add(Duration(days: daysToAdd));
      
      // Skip weekends (Saturday and Sunday)
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        workingDaysAdded++;
      }
    }
    
    return startDate.add(Duration(days: daysToAdd));
  }

  Future<void> _redirectToWhatsApp() async {
    const String phoneNumber = "+256787018472";
    final String message = Uri.encodeComponent(
        "Hello, I'm inquiring about my visa application status for ${widget.country} (${widget.visaType} visa). My travel date is ${DateFormat('dd MMM yyyy').format(widget.travelDate)}. Can you provide an update?");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Processing'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(),
              const SizedBox(height: 24),
              _buildCountdownSection(),
              const SizedBox(height: 24),
              _buildProcessingStages(),
              const SizedBox(height: 24),
              _buildSupportSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.hourglass_top,
                    color: Colors.purple.shade800,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visa Application in Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your application is being processed',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'Visa Type',
              value: '${widget.visaType} Visa',
            ),
            _buildInfoRow(
              label: 'Destination',
              value: widget.country,
            ),
            _buildInfoRow(
              label: 'Travel Date',
              value: DateFormat('dd MMM yyyy').format(widget.travelDate),
            ),
            _buildInfoRow(
              label: 'Application Date',
              value: DateFormat('dd MMM yyyy').format(DateTime.now()),
            ),
            _buildInfoRow(
              label: 'Expected Completion',
              value: DateFormat('dd MMM yyyy').format(_estimatedCompletionDate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownSection() {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Time Remaining',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade900,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCountdownItem(
              value: days.toString().padLeft(2, '0'),
              label: 'Days',
            ),
            _buildCountdownDivider(),
            _buildCountdownItem(
              value: hours.toString().padLeft(2, '0'),
              label: 'Hours',
            ),
            _buildCountdownDivider(),
            _buildCountdownItem(
              value: minutes.toString().padLeft(2, '0'),
              label: 'Minutes',
            ),
            _buildCountdownDivider(),
            _buildCountdownItem(
              value: seconds.toString().padLeft(2, '0'),
              label: 'Seconds',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.amber.shade800,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Visa processing typically takes 5 working days, but may vary based on embassy workload and requirements.',
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownItem({required String value, required String label}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownDivider() {
    return Text(
      ':',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.purple.shade800,
      ),
    );
  }

  Widget _buildProcessingStages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Processing Stages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade900,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _stages.length,
          itemBuilder: (context, index) {
            final stage = _stages[index];
            // ignore: unused_local_variable
            final isFirst = index == 0;
            final isLast = index == _stages.length - 1;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: stage.isCompleted ? Colors.green : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: stage.isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 50,
                        color: _stages[index + 1].isCompleted || stage.isCompleted
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stage.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: stage.isCompleted ? Colors.green : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stage.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (stage.completionDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Completed on ${DateFormat('dd MMM, HH:mm').format(stage.completionDate!)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Assistance?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade900,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'If you have any questions about your visa application or need to provide additional information, our support team is here to help.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _redirectToWhatsApp,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      color: Colors.green.shade700,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Support via WhatsApp',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Get quick assistance from our visa experts',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.green.shade700,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProcessingStage {
  final String title;
  final String description;
  bool isCompleted;
  DateTime? completionDate;

  ProcessingStage({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.completionDate,
  });
}
