import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildbody(context),
    );
  }

  _buildbody(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: 320,
            // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/repair_phone2.jpg'),
                  fit: BoxFit.cover),
            ),
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ဝမ်းနိုင်းနိုင်း ဖုန်းပြုပြင်ရေး',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ကျွမ်းကျင်မှုဖြင့်သာ ဝန်ဆောင်မှုပေးသည်',
                    style: textTheme.labelMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
