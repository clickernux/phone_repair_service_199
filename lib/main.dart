import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:phone_repair_service_199/fetch_blog.dart';
import 'package:phone_repair_service_199/firebase_options.dart';
import 'package:phone_repair_service_199/main_router.dart';
import 'package:phone_repair_service_199/util.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('Native called background task: $taskName');
    await dotenv.load(fileName: ".env");
    await Hive.initFlutter();
    try {
      final apiKey = dotenv.env['BLOGGER_API'] ?? '';
      final blogId = dotenv.env['BLOG_ID'] ?? '';

      final posts = await FetchBlog.fetchBlog(blogId, apiKey);

      debugPrint('Total Posts: ${posts.length}');

      final box = await Hive.openBox(Util.bloggerPost);

      for (var post in posts) {
        box.put(post.id, post.toJson());
      }
      // debugPrint('Posts in box: ${box.length}');
    } catch (error) {
      throw Exception(error);
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask(
    'task-identifier',
    'FetchBloggerPost',
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
