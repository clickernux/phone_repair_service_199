import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';

import '../util.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onLongPress: () => _login(context),
          child: Text(Util.appNameMM),
        ),
        titleTextStyle: textTheme.labelLarge?.copyWith(fontSize: 18),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed('notifications');
            },
            icon: const Icon(LineIcons.bell),
          ),
        ],
      ),
      body: _buildbody(context, textTheme),
    );
  }

  _buildbody(BuildContext context, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: CustomScrollView(
        slivers: [
          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: 16),
          //     child: HeaderWidget(),
          //   ),
          // ),
          const SliverToBoxAdapter(
            child: BannerScroll(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                'သင့်အတွက်',
                style: textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // const SliverToBoxAdapter(
          //   child: PageSlideView(),
          // ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverGrid.count(
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.red,
                child: const Center(
                  child: Text('MPT'),
                ),
              ),
              Container(
                width: 200,
                height: 200,
                color: Colors.green,
                child: const Center(
                  child: Text('ATOM'),
                ),
              ),
              Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: const Center(
                  child: Text('MyTEL'),
                ),
              ),
              Container(
                width: 200,
                height: 200,
                color: Colors.black38,
                child: const Center(
                  child: Text('Oredoo'),
                ),
              ),
            ],
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      context.goNamed('login');
    } else {
      context.goNamed('admin_panel');
    }
  }
}
