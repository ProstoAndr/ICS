import 'package:flutter/material.dart';

import 'init/app_router_init.dart';

void main() {
  final appRouter = AppRouterInit();
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouterInit appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
    );
  }
}
