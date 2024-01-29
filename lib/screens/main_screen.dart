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
          child: Text(Util.appNameMM,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              )),
        ),
        titleTextStyle: textTheme.labelLarge?.copyWith(fontSize: 18),
        actions: [
          IconButton(
            onPressed: () {
              context.goNamed('all_noti');
            },
            icon: const Icon(LineIcons.bullhorn),
          ),
        ],
      ),
      body: _buildbody(context, textTheme),
    );
  }

  Widget _buildbody(BuildContext context, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: BannerScroll(),
          ),

          // Marquee Text
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                color: Colors.yellow,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(width: 4),
                    Icon(
                      LineIcons.bullhorn,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Flexible(child: MarqueeText()),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Activity Slideshow
          const SliverToBoxAdapter(
            child: ActivitySlideHost(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // USSD Code
          SliverToBoxAdapter(
            child: Text(
              'USSD Code',
              style: textTheme.labelLarge,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverGrid.count(
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            children: [
              OperatorCard(
                label: 'MPT',
                onTap: () {
                  context
                      .goNamed('ussd', pathParameters: {'operatorName': 'MPT'});
                },
              ),
              OperatorCard(
                label: 'ATOM',
                onTap: () {
                  context.goNamed('ussd',
                      pathParameters: {'operatorName': 'ATOM'});
                },
              ),
              OperatorCard(
                label: 'MyTel',
                onTap: () {
                  context.goNamed('ussd',
                      pathParameters: {'operatorName': 'MYTEL'});
                },
              ),
              OperatorCard(
                label: 'Ooredoo',
                onTap: () {
                  context.goNamed('ussd',
                      pathParameters: {'operatorName': 'Ooredoo'});
                },
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
