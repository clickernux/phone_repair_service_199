import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';
import 'package:phone_repair_service_199/firebase_options.dart';
import 'package:phone_repair_service_199/local_notification_service.dart';
import 'package:phone_repair_service_199/main_router.dart';
import 'package:phone_repair_service_199/theme.dart';
import 'package:phone_repair_service_199/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const String channelIdForBlog = 'fetchBlog';
const String channelNameForBlog = 'FetchingBlog';
const String channelDescForBlog =
    'This channel is used for showing fetching blog posts message';

const String channelIdNoti = 'notification';
const String channelNameNoti = 'Get Notification';
const String channelDescNoti =
    'This channel is used for showing messages send by Admin';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('Native called background task: $taskName');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await dotenv.load(fileName: ".env");
    await Hive.initFlutter();
    LocalNotificationService.initialize();
    if (taskName == 'OneOffFetchBlogPosts' ||
        taskName == 'PeriodicFetchBlogPosts') {
      try {
        final apiKey = dotenv.env['BLOGGER_API'] ?? '';
        final blogId = dotenv.env['BLOG_ID'] ?? '';

        final posts = await FetchBlog.fetchBlog(blogId, apiKey);

        debugPrint('Total Posts: ${posts.length}');

        final box = await Hive.openBox(Util.bloggerPost);
        final previousPostCount = box.length;
        final deletedPostCount = await box.clear();

        debugPrint('Deleted $deletedPostCount posts!');

        for (var post in posts) {
          await box.put(post.id, post.toJson());
        }
        if (box.length != previousPostCount) {
          LocalNotificationService.display(
            title: 'ဖတ်စရာအသစ်ရပါပြီ',
            message:
                'သင့်အတွက် ဖတ်ရှုစရာအကြောင်းအရာများ ${box.length - previousPostCount}ခု ရရှိထားပါသည်။',
            channelId: channelIdForBlog,
            channelName: channelNameForBlog,
            channelDesc: channelDescForBlog,
            importance: Importance.max,
            priority: Priority.max,
          );
        } else {
          debugPrint('Notification Skip Showing!');
        }
      } catch (error) {
        // LocalNotificationService.display(
        //   title: 'အမှား',
        //   message: error.toString(),
        //   channelId: channelIdForBlog,
        //   channelName: channelNameForBlog,
        //   channelDesc: channelDescForBlog,
        //   importance: Importance.max,
        //   priority: Priority.max,
        // );
        // throw Exception(error);
        debugPrint("Error: $error");
      }
    } else {
      final data = await FirebaseFirestore.instance
          .collection(Util.collectionNameMessage)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (data.docs.isEmpty) {
        debugPrint('No Notification!');
      } else {
        final notiBox = await Hive.openBox(Util.notiBox);
        final doc = data.docs.first;

        // if there is no data in notiBox
        // the doc will be saved in notiBox
        // and will show the content as notification
        if (notiBox.isEmpty) {
          final String message = doc.data()['message'];
          notiBox.put('message', message).then((value) {
            LocalNotificationService.display(
              title: 'New Message',
              message: message,
              channelId: channelIdNoti,
              channelName: channelNameNoti,
              channelDesc: channelDescNoti,
              importance: Importance.max,
              priority: Priority.max,
            );
          });
        } else {
          final String message = doc.data()['message'];
          final String oldMessage = await notiBox.get('message');
          if (message != oldMessage) {
            await notiBox.put('message', message);
            LocalNotificationService.display(
              title: 'မင်္ဂလာပါ',
              message: message,
              channelId: channelIdNoti,
              channelName: channelNameNoti,
              channelDesc: channelDescNoti,
              importance: Importance.max,
              priority: Priority.max,
            );
          }
        }
      }
    }

    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await Hive.initFlutter();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  final sharePref = await SharedPreferences.getInstance();
  final bool isFirstLaunch = sharePref.getBool('firstLaunch') ?? true;

  // အကယ်၍ app က ပထမဆုံး စrun တဲ့အချိန်ဖြစ်ခဲ့ရင်
  // app စတာနဲ့ message and blog ကို fetch လုပ်ခိုင်းမယ်
  if (isFirstLaunch) {
    firstLaunchWorkmanager();
    sharePref.setBool('firstLaunch', false);
  }
  // အကယ်၍ app က ပထမဆုံး run တာမဟုတ်ရင်
  // အချိန်အပိုင်းအခြားအလိုက် message and blog ကို fetch ခိုင်းမယ်
  periodicTasks();

  runApp(const PhoneRepairService199App());
}

void periodicTasks() async {
  await Future.delayed(const Duration(seconds: 5));
  Workmanager().registerPeriodicTask(
    'periodic-task',
    'PeriodicFetchBlogPosts',
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
      // requiresDeviceIdle: true,
    ),
    frequency: const Duration(hours: 3),
  );
  Workmanager().registerPeriodicTask(
    'periodic-task-message',
    'PeriodicFetchMessage',
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
      // requiresDeviceIdle: true,
    ),
    frequency: const Duration(hours: 1),
  );
}

void firstLaunchWorkmanager() {
  Workmanager().registerOneOffTask(
    'first-launch-task',
    'OneOffFetchBlogPosts',
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );

  Workmanager().registerOneOffTask(
    'first-launch-fetch-message',
    'OneOffFetchingMessage',
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );
}

class PhoneRepairService199App extends StatelessWidget {
  const PhoneRepairService199App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        fontFamily: 'NotoSansMyanmar',
        brightness: Brightness.light,
        textTheme: MyTheme.textTheme,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'NotoSerifMyanmar',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'NotoSansMyanmar',
        textTheme: MyTheme.textTheme,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'NotoSerifMyanmar',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: MainRouter.router,
    );
  }
}
