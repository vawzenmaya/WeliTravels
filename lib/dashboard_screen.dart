import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final currencyFormatter = NumberFormat.currency(symbol: '\$');
  final double totalAmount = 1500.0;
  final double paidAmount = 500.0;
  
  @override
  Widget build(BuildContext context) {
    final double remainingAmount = totalAmount - paidAmount;
    final double progressPercentage = paidAmount / totalAmount;
    
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(progressPercentage, remainingAmount),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF4527A0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: const Text(
        'Payment Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Show notifications
          },
        ),
      ],
    );
  }
  
  Widget _buildBody(double progressPercentage, double remainingAmount) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCreditCard(),
            const SizedBox(height: 20),
            _buildBalanceWidget(remainingAmount),
            const SizedBox(height: 24),
            _buildProgressSection(progressPercentage),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildPaymentSummaryCard(),
            _buildPaymentSchedule(),
            _buildDepositHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFF4527A0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Money Saved",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Image.asset(
                'assets/images/visa_logo.png', 
                height: 30,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.credit_card, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            currencyFormatter.format(paidAmount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "**** **** **** 1234",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "CARD HOLDER",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Vawzen",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "EXPIRES",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "12/25",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceWidget(double remainingAmount) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Remaining Balance",
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Next payment due in 15 days",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            "-${currencyFormatter.format(remainingAmount)}",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(double progressPercentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 12.0,
            percent: progressPercentage,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${(progressPercentage * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                const Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            progressColor: const Color(0xFF6A1B9A),
            backgroundColor: Colors.grey[200]!,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1200,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment Progress",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildProgressLegendItem(
                  "${(progressPercentage * 100).toStringAsFixed(0)}% Paid",
                  const Color(0xFF6A1B9A),
                ),
                const SizedBox(height: 8),
                _buildProgressLegendItem(
                  "${(100 - progressPercentage * 100).toStringAsFixed(0)}% Remaining",
                  Colors.grey[400]!,
                ),
                const SizedBox(height: 15),
                Text(
                  "Total: ${currencyFormatter.format(totalAmount)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            "Make Deposit",
            Icons.account_balance_wallet,
            const Color(0xFF6A1B9A),
            () {
              _showDepositDialog();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            "Payment Plan",
            Icons.calendar_today,
            const Color(0xFF4527A0),
            () {
              // Show payment plan
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Make a Deposit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixText: "\$",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              "Choose payment method:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentMethodButton(Icons.credit_card, "Card"),
                _buildPaymentMethodButton(Icons.account_balance, "Bank"),
                _buildPaymentMethodButton(Icons.phone_android, "Mobile"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              // Process deposit
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A1B9A),
            ),
            child: const Text("DEPOSIT"),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: const Color(0xFF6A1B9A)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDepositHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Deposit History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full history page
                },
                child: const Text(
                  "See All",
                  style: TextStyle(color: Color(0xFF6A1B9A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDepositHistoryItem(
            amount: 250.0,
            date: "May 15, 2023",
            status: "Completed",
            percentage: 0.25,
          ),
          _buildDepositHistoryItem(
            amount: 150.0,
            date: "Apr 15, 2023",
            status: "Completed",
            percentage: 0.15,
          ),
          _buildDepositHistoryItem(
            amount: 100.0,
            date: "Mar 15, 2023",
            status: "Completed",
            percentage: 0.10,
          ),
        ],
      ),
    );
  }

  Widget _buildDepositHistoryItem({
    required double amount,
    required String date,
    required String status,
    required double percentage,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormatter.format(amount),
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Payment Date: $date",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: percentage,
            backgroundColor: Colors.grey[200],
            progressColor: const Color(0xFF6A1B9A),
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 6),
          Text(
            "${(percentage * 100).toStringAsFixed(0)}% of total payment",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                "Total Amount",
                currencyFormatter.format(totalAmount),
                Colors.white70,
                Colors.white,
              ),
              _buildSummaryItem(
                "Paid Amount",
                currencyFormatter.format(paidAmount),
                Colors.white70,
                Colors.white,
              ),
              _buildSummaryItem(
                "Remaining",
                currencyFormatter.format(totalAmount - paidAmount),
                Colors.white70,
                Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: paidAmount / totalAmount,
            backgroundColor: Colors.white.withOpacity(0.3),
            progressColor: Colors.white,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          Text(
            "Next payment: ${currencyFormatter.format(totalAmount / 6)} due on June 15, 2023",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, String value, Color labelColor, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSchedule() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Schedule",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildScheduleItem(
            date: "June 15, 2023",
            amount: totalAmount / 6,
            isUpcoming: true,
          ),
          _buildScheduleItem(
            date: "July 15, 2023",
            amount: totalAmount / 6,
            isUpcoming: false,
          ),
          _buildScheduleItem(
            date: "August 15, 2023",
            amount: totalAmount / 6,
            isUpcoming: false,
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Show full schedule
              },
              icon: const Icon(
                Icons.calendar_month,
                color: Color(0xFF6A1B9A),
                size: 18,
              ),
              label: const Text(
                "View Full Schedule",
                style: TextStyle(color: Color(0xFF6A1B9A)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem({
    required String date,
    required double amount,
    required bool isUpcoming,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUpcoming ? const Color(0xFFF3E5F5) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isUpcoming ? const Color(0xFF6A1B9A) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: isUpcoming ? const Color(0xFF6A1B9A) : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  fontWeight: isUpcoming ? FontWeight.w600 : FontWeight.normal,
                  color: isUpcoming ? const Color(0xFF6A1B9A) : Colors.grey[800],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                currencyFormatter.format(amount),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isUpcoming ? const Color(0xFF6A1B9A) : Colors.grey[800],
                ),
              ),
              const SizedBox(width: 8),
              if (isUpcoming)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A1B9A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Upcoming",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

  void _makeDeposit(double amount) {
    setState(() {
      double newPaidAmount = paidAmount + amount;
      if (newPaidAmount > totalAmount) {
        newPaidAmount = totalAmount;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully deposited ${currencyFormatter.format(amount)}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}
class DepositItem {
  final double amount;
  final DateTime date;
  final String status;
  final double percentage;

  DepositItem({
    required this.amount,
    required this.date,
    required this.status,
    required this.percentage,
  });
}
