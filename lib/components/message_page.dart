import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phone_repair_service_199/util.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final TextEditingController _editingController;
  late final FirebaseFirestore _db;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
    _db = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: _editingController,
                  // autofocus: true,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'မက်ဆေ့စာသားဖြည့်ပါ!';
                    }
                    return null;
                  },
                  minLines: 1,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    helperText: 'မက်ဆေ့',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            // TextButton.icon(
            //   onPressed: () {},
            //   icon: const Icon(Icons.send),
            //   label: const Text('Submit'),
            // )
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Connectivity().checkConnectivity().then((value) {
                    if (value == ConnectivityResult.none) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Internet Connection!'),
                        ),
                      );
                    } else {
                      _uploadData();
                    }
                  });
                }
              },
              icon: _isLoading
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ))
                  : const Icon(LineIcons.upload),
              label: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadData() {
    setState(() {
      _isLoading = true;
    });
    final data = {
      'message': _editingController.text,
      'timestamp': FieldValue.serverTimestamp()
    };
    _db
        .collection(Util.collectionNameMessage)
        .add(data)
        .then((value) => _showMessage('မက်ဆေ့ပို့ပြီးပြီ!'))
        .onError((error, stackTrace) => _showMessage('အမှားအယွင်းရှိနေသည်!'))
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
