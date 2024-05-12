import 'package:flutter/material.dart';

void main() {
  runApp(PaymentPage());
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentOptionButton(
                  icon: Icons.money_rounded,
                  label: 'Cash on Delivery',
                  onTap: () {
                    // Handle cash on delivery payment
                  },
                ),
                SizedBox(height: 20),
                PaymentOptionButton(
                  icon: Icons.account_balance,
                  label: 'Internet Banking',
                  onTap: () {
                    // Handle internet banking payment
                  },
                ),
                SizedBox(height: 20),
                PaymentOptionButton(
                  icon: Icons.payment,
                  label: 'UPI Payment',
                  onTap: () {
                    // Handle UPI payment
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PaymentOptionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
