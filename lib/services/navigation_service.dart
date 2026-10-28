import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateNamedTo(String routeName, Object? arguments) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateReplacementNamedTo(
      String routeName, Object? arguments) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }
}
