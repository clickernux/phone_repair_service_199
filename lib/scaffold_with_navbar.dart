import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

import 'util.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: AppBar(
      //     title: Text(Util.appNameMM),
      //     titleTextStyle: Theme.of(context).textTheme.labelLarge,
      //     actions: [
      //       IconButton(onPressed: () {}, icon: const Icon(LineIcons.bell)),
      //     ],
      //   ),
      // ),
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentNavIndex(context),
      onTap: (value) => _onNavChanged(context, value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LineIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.bookReader),
          label: 'ဖတ်စရာ',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.shoppingBag),
          label: 'အပိုပစ္စည်း',
        ),
        BottomNavigationBarItem(
          icon: Icon(LineIcons.infoCircle),
          label: 'အကြောင်း',
        ),
      ],
    );
  }

  int _getCurrentNavIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/main')) {
      return 0;
    } else if (location.startsWith('/blog')) {
      return 1;
    } else if (location.startsWith('/accessories')) {
      return 2;
    } else if (location.startsWith('/about')) {
      return 3;
    } else {
      return 0;
    }
  }

  void _onNavChanged(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed('main');
        break;
      case 1:
        context.goNamed('blog');
        break;
      case 2:
        context.goNamed('accessories');
        break;
      case 3:
        context.goNamed('about');
        break;
      default:
        context.goNamed('main');
    }
  }
}
