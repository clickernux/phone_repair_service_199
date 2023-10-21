import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: InkWell(
      //     onLongPress: () => _login(context),
      //     child: Text(Util.appNameMM),
      //   ),
      //   titleTextStyle: textTheme.labelLarge?.copyWith(fontSize: 18),
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(LineIcons.bell),
      //     ),
      //   ],
      // ),
      body: _buildbody(context, textTheme),
    );
  }

  _buildbody(BuildContext context, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: HeaderWidget(),
            ),
          ),
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
          const SliverToBoxAdapter(
            child: PageSlideView(),
          ),
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
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        InkWell(
          onLongPress: () => _login(context),
          child: SizedBox(
            width: 150,
            height: 120,
            child: Image.asset(
              'assets/images/199Logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          'ဝမ်းနိုင်းနိုင်း ဖုန်းပြုပြင်ရေး',
          style: textTheme.labelLarge,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'ကျွမ်းကျင်မှုဖြင့်သာ ဝန်ဆောင်မှုပေးသည် ..',
          style: textTheme.labelSmall,
        ),
        const SizedBox(height: 12),
        const Divider(
          indent: 120,
          endIndent: 120,
        ),
        const SizedBox(height: 12),
        Text(
          '- ယနေ့ဆိုင်ဖွင့်သည် -',
          style: textTheme.labelSmall,
        ),
        const VerticalDivider(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
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
