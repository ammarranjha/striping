import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mystripe/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TextEditingController txtController = TextEditingController();

  Stripe.publishableKey =
      'pk_test_51KFcb7EZksxdhUi2cePYZhBPDSo3maQqaOwbHHEK52TrrBibabNQ4p7v0e1SbDx5cn3uD15vEN7ZE0zaZqhvYTru00hJ0ygw1a';
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
