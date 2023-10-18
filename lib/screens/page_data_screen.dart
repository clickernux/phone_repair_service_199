import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PageDataScreen extends StatelessWidget {
  const PageDataScreen({super.key, required this.doc});
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
  
  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: ,
        ),

      ],
    );
  }
}
