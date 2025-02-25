import 'package:flutter/material.dart';

import 'init/app_router_init.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: AppRouterInit().router.routerDelegate,
      routeInformationParser: AppRouterInit().router.routeInformationParser,
      routeInformationProvider: AppRouterInit().router.routeInformationProvider,
    );
  }
}
