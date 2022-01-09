import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay using Stripe'),
      ),
      body: Center(
        child: InkWell(
          onTap: () async {
            await makePayment();
          },
          child: Container(
            height: 50,
            width: 200,
            color: Colors.green,
            child: Center(
              child: Text(
                'Pay',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData =
          await createPaymentIntent('2', 'USD'); //json.decode(response.body);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          // Customer params
          customerId: paymentIntentData!['customer'],
          // customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          // Extra params
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          testEnv: true,
          merchantCountryCode: 'DE',
        ),
      );

      print('initialised');
      await Stripe.instance.presentPaymentSheet();

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {} on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

//ammar repo
  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51KFcb7EZksxdhUi2iNA1uwK6ECpKYWnh6zRxu6uebIfJtwmLqowCJoMewJ3gu048vy11PSPeKt9o2Z8ldq3txRV400PYbdXjc1',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
