import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay In Flutter Test Mode'),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () async {
                openCheckout();
              },
              child: Text('Pay 10 Rupees'))),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'Your Key Id',
      'amount': 1000,
      'name': 'Product Name',
      'description': 'Product Description',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '0123456789', 'email': 'flutter@developer.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error:' + e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment Successfull Completed'),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    print('Error Response Code: ' + response.code.toString());
    print('Error Response Message: ' + response.message.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error Response Message:" + response.message.toString()),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    print('External SDK Response Wallate Name: $response' +
        response.walletName.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('External Wallet Response'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}
