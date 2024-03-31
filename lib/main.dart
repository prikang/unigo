import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unigo/provider/going_provider.dart';
import 'package:unigo/provider/leaving_provider.dart';
import 'package:unigo/provider/location_provider.dart';
import 'app/app.dart';
import 'app/app_initialize.dart';
import 'package:provider/provider.dart' as pre;


void main() async {
  await AppInitialize.appInitialize();
  runApp(pre.MultiProvider(providers: [
    pre.ChangeNotifierProvider(create: (_) => Locationprovider()),
     pre.ChangeNotifierProvider(create: (_) => GoingProvider()),
      pre.ChangeNotifierProvider(create: (_) => LeavingProvider()),
  ], child: const ProviderScope(child: MyApplication())));
  
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
