import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController imgUrlController;
  late final FirebaseFirestore db;

  final formKey = GlobalKey<FormState>();

  final List<String> imgUrlList = [];
  String? urlEmpty;
  bool showSheet = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    imgUrlController = TextEditingController();
    db = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    imgUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(tabs: [
            Text('Announce'),
            Text('Activity'),
            Text('Accessory'),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => context.pop())
                    .onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error.toString(),
                      ),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.logout_sharp),
            ),
          ],
        ),
        body: _buildTabbarView(),
      ),
    );
  }

  Widget _buildTabbarView() {
    return TabBarView(children: [
      const MessagePage(),
      const ActivityCreator(),
      Container(
        color: Colors.green,
      ),
    ]);
  }
}
