import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';
import 'package:phone_repair_service_199/firebase_options.dart';
import 'package:phone_repair_service_199/local_notification_service.dart';
import 'package:phone_repair_service_199/main_router.dart';
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
        throw Exception(error);
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
  await Hive.initFlutter();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  final sharePref = await SharedPreferences.getInstance();
  final bool isFirstLaunch = sharePref.getBool('firstLaunch') ?? true;

  if (isFirstLaunch) {
    Workmanager().registerOneOffTask(
      'first-launch-task',
      'OneOffFetchBlogPosts',
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    Workmanager().registerOneOffTask(
      'first-launch-fetch-message',
      'OneOffFetchingMessage',
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
    sharePref.setBool('firstLaunch', false);
  }

  Workmanager().registerPeriodicTask(
    'periodic-task',
    'PeriodicFetchBlogPosts',
    constraints: Constraints(networkType: NetworkType.connected),
    frequency: const Duration(hours: 5),
  );
  Workmanager().registerPeriodicTask(
    'periodic-task-message',
    'PeriodicFetchMessage',
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    frequency: const Duration(hours: 1),
  );
  runApp(const PhoneRepairService199App());
}

class PhoneRepairService199App extends StatelessWidget {
  const PhoneRepairService199App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: MainRouter.router,
    );
  }
}
