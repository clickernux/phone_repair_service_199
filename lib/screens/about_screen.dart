import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
            onPressed: () => _launchPhoneCall('09256343863'),
            icon: const Icon(LineIcons.phone),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 280,
          child: Image.asset(
            'assets/images/repair_phone2.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const InfoCard(
            title: '199 Phone Repair Service',
            desc:
                'တန့်ယန်းမြို့တွင် ဖုန်းပြုပြင်ရေး သီးသန့်ဖြင့် နှစ်ပေါင်းများစွာ  ရပ်တည်ခဲ့ပြီးဖြစ်သည်။\nဖုန်းအရောင်းဆိုင်များမှ ကိုယ်တိုင်ပြုပြင်ရန်ခက်ခဲသည့် ဖုန်းများကို ဆိုင်ဈေးသီးသန့်ဖြင့် လက်ခံပြုပြင်ပေးနေသည်။'),
        const InfoCard(
          title: 'လိပ်စာ',
          desc:
              'ရပ်ကွက်(၃)၊ မြို့နယ်ခန်းမအနီး၊ ရွှင်ပျော်ပျော် စားသောက်ဆိုင်ကပ်လျက်၊ ဝမ်းနိုင်းနိုင်း ဖုန်းပြုပြင်ရေး၊ တန့်ယန်းမြို့။',
        ),
        const InfoCard(
          title: 'ဖုန်းနံပါတ်',
          desc: '09 256343863',
        ),
        const InfoCard(
          title: 'ဆက်သွယ်ရန်',
          desc:
              'ဖုန်းနှင့်ပတ်သက်သော အကြောင်းအရာအများကို ဆက်သွယ်မေးမြန်းနိုင်ရန် အထက်ဖော်ပြပါ ဆိုင်ဖုန်းနံပါတ်နှင့် WeChat, Viber အကောင့်ဖွင့်ထားပါသည်။',
        ),
        ListTile(
          title: Text(
            'Facebook Page',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: const Text('fb://phoneservice199'),
          trailing: IconButton(
              onPressed: () {
                _launchFacebook('www.facebook.com/phoneservice199');
              },
              icon: const Icon(
                Icons.launch,
                size: 32,
              )),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _launchFacebook(String s) async {
    final rawUrl = 'fb://facewebmodal/f?href=https://$s';
    final url = Uri.parse(rawUrl);
    if (!await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Unable to launch $url');
    }
  }

  void _launchPhoneCall(String s) async {
    final uri = Uri.parse('tel:$s');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Unable to make phone call to $s');
    }
  }
}
