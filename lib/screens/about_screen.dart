import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../components/component_layer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ဆက်သွယ်ရန်'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LineIcons.phone),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 280,
          child: Placeholder(),
        ),
        InfoCard(
            title: '199 Phone Repair Service',
            desc:
                'တန့်ယန်းမြို့တွင် ဖုန်းပြုပြင်ရေး သီးသန့်ဖြင့် နှစ်ပေါင်းများစွာ  ရပ်တည်ခဲ့ပြီးဖြစ်သည်။\nဖုန်းအရောင်းဆိုင်များမှ ကိုယ်တိုင်ပြုပြင်ရန်ခက်ခဲသည့် ဖုန်းများကို ဆိုင်ဈေးသီးသန့်ဖြင့် လက်ခံပြုပြင်ပေးနေသည်။'),
        InfoCard(
          title: 'လိပ်စာ',
          desc:
              'ရပ်ကွက်(၃)၊ မြို့နယ်ခန်းမအနီး၊ ရွှင်ပျော်ပျော် စားသောက်ဆိုင်ကပ်လျက်၊ ဝမ်းနိုင်းနိုင်း ဖုန်းပြုပြင်ရေး၊ တန့်ယန်းမြို့။',
        ),
        InfoCard(
          title: 'ဖုန်းနံပါတ်',
          desc: '09 256343863',
        ),
        InfoCard(
          title: 'Social Media',
          desc:
              'ဖုန်းနှင့်ပတ်သက်သော အကြောင်းအရာအများကို ဆက်သွယ်မေးမြန်းနိုင်ရန် အထက်ဖော်ပြပါ ဆိုင်ဖုန်းနံပါတ်နှင့် WeChat, Viber အကောင့်ဖွင့်ထားပါသည်။',
        ),
      ],
    );
  }
}
