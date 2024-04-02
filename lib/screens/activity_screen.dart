import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';
import 'package:phone_repair_service_199/util.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Util.collectionName)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('အမှားအယွင်းရှိနေပါသည်'),
            );
          }
          final doc = snapshot.data;
          if (doc == null || doc.docs.isEmpty) {
            return const Center(
              child: Text('ဒေတာမရှိပါ'),
            );
          }

          return ListView.builder(
            itemCount: doc.size,
            itemBuilder: (context, index) {
              final data = doc.docs[index];
              return SizedBox(
                height: 250,
                child: InkWell(
                  // TODO: Will be implement later
                  // onLongPress: FirebaseAuth.instance.currentUser == null
                  //     ? null
                  //     : () => _deleteData(data.id),
                  onTap: () {
                    context.goNamed('noti', extra: data);
                  },
                  child: PageCard(
                    doc: data,
                    onTapItem: () {
                      context.goNamed('subActivity', extra: data);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteData(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection(Util.collectionName)
              .doc(id)
              .delete(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).cardColor,
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Error deleting data!'),
                ),
              );
            }

            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Done Deleting Data!'),
              ),
            );
          },
        );
      },
    );
  }

  void showSnackbarMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
