import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Razorpay'),
        ),
        body: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(onPressed: openCheckout, child: Text('Open'))
                ])),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_gXYZIuQrMoFaJ0',
      'amount': 2000,
      /*'external': {
        'wallets': ['paytm']
      }*/
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(
        "EXTERNAL_WALLET: " + response.walletName,);
  }
}