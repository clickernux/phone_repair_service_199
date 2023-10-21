import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
