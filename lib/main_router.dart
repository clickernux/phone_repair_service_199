import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/scaffold_with_navbar.dart';
import 'package:phone_repair_service_199/screens/screen_layer.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class MainRouter {
  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/main',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/main',
            name: 'main',
            builder: (context, state) => const MainScreen(),
          ),
          GoRoute(
            path: '/blog',
            name: 'blog',
            builder: (context, state) => const BlogScreen(),
          ),
          GoRoute(
            path: '/accessories',
            name: 'accessories',
            builder: (context, state) => const AccessoriesScreen(),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            builder: (context, state) => const AboutScreen(),
          ),
        ],
      ),
    ],
  );
}
