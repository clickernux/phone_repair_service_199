
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/model/data_layer.dart';
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
              routes: [
                GoRoute(
                  // parentNavigatorKey: _rootNavigatorKey,
                  path: 'ussd/:operatorName',
                  name: 'ussd',
                  builder: (context, state) {
                    final String name = state.pathParameters['operatorName'] ??
                        'Unknown Operator';
                    return UssdScreen(operatorName: name);
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'login',
                  name: 'login',
                  builder: (context, state) => const LoginScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'admin_panel',
                  name: 'admin_panel',
                  builder: (context, state) => const AdminPanelScreen(),
                ),
                GoRoute(
                  // parentNavigatorKey: _rootNavigatorKey,
                  path: 'page_data',
                  name: 'page_data',
                  builder: (context, state) {
                    final data = state.extra
                        as QueryDocumentSnapshot<Map<String, dynamic>>;
                    return PageDataScreen(
                      doc: data,
                    );
                  },
                ),
                GoRoute(
                    path: 'notifications',
                    name: 'notifications',
                    builder: (context, state) => const NotificationScreen(),
                    routes: [
                      GoRoute(
                        path: 'noti',
                        name: 'noti',
                        builder: (context, state) {
                          final data = state.extra
                              as QueryDocumentSnapshot<Map<String, dynamic>>;
                          return PageDataScreen(doc: data);
                        },
                      ),
                    ]),
              ]),
          GoRoute(
              path: '/blog',
              name: 'blog',
              builder: (context, state) => const BlogScreen(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'post/:postId',
                  name: 'post',
                  builder: (context, state) {
                    final Map<String, dynamic> json =
                        state.extra as Map<String, dynamic>;
                    final post = BloggerPost.fromJson(json);
                    return BlogPostScreen(
                      post: post,
                    );
                  },
                ),
              ]),
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
