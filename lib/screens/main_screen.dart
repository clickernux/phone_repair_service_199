import 'package:flutter/material.dart';
import 'package:phone_repair_service_199/util.dart';
import 'package:line_icons/line_icons.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Util.appNameMM),
        titleTextStyle: Theme.of(context).textTheme.labelLarge,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LineIcons.bell)),
        ],
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return const Placeholder();
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // currentIndex: 0,
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
}
