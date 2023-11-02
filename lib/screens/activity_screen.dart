import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/components/component_layer.dart';
import 'package:phone_repair_service_199/util.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        bottom: _isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: LinearProgressIndicator())
            : null,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(Util.collectionName)
            .orderBy('timestamp', descending: true)
            .get(),
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
              final imgUrl = data.data()['imgList'] as List<dynamic>;
              return SizedBox(
                height: 250,
                child: Dismissible(
                  key: Key(data.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _deleteData(data.id);
                  },
                  child: InkWell(
                    onTap: () {
                      context.goNamed('noti', extra: data);
                    },
                    child: PageCard(doc: data),
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
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection(Util.collectionName)
        .doc(id)
        .delete()
        .then((value) {
      showSnackbarMsg('Item Deleted!');
    }).onError((error, stackTrace) {
      showSnackbarMsg(error.toString());
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showSnackbarMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
