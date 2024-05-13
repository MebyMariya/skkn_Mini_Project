import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter

class UpiPaymentPage extends StatelessWidget {
  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionNoteController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Payment'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.jpg'), // Adjust the image path as needed
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UPI Payment Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _upiIdController,
              decoration: InputDecoration(
                labelText: 'Enter UPI ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number, // Set keyboard type to number
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _transactionNoteController,
              decoration: InputDecoration(
                labelText: 'Transaction Note',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String _upiId = _upiIdController.text;
                String _amount = _amountController.text;
                String _transactionNote = _transactionNoteController.text;

                if (_upiId.isEmpty || _amount.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                if (!validateUpiId(_upiId)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid UPI ID format')),
                  );
                  return;
                }

                initiateUpiPayment(
                  context: context,
                  upiId: _upiId,
                  amount: _amount,
                  transactionNote: _transactionNote,
                );
              },
              child: Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initiateUpiPayment({
    required BuildContext context,
    required String upiId,
    required String amount,
    required String transactionNote,
  }) async {
    // Your UPI payment logic here
    // For example:
    // final response = await SomeUpiPlugin.initiateTransaction();
    // Handle the response accordingly
  }

  bool validateUpiId(String upiId) {
    // Simple validation to check if the UPI ID contains '@' symbol
    return upiId.contains('@');
  }
}
