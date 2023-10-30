import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

import '../model/slide_data.dart';
import '../util.dart';

class ActivityCreator extends StatefulWidget {
  const ActivityCreator({super.key});

  @override
  State<ActivityCreator> createState() => _ActivityCreatorState();
}

class _ActivityCreatorState extends State<ActivityCreator> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _urlController;
  late final FirebaseFirestore _db;

  final _formKey = GlobalKey<FormState>();
  final List<String> _imgUrlList = [];
  bool _showSheet = false;
  bool _isLoading = false;

  String? _urlEmpty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _urlController = TextEditingController();
    _db = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: titleField(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: contentField(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: urlField(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: onUpload,
                icon: const Icon(LineIcons.upload),
                label: const Text('Submit'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverList.builder(
              itemCount: _imgUrlList.length,
              itemBuilder: (context, index) {
                final imgUrlText = _imgUrlList[index];
                return Dismissible(
                  key: Key(imgUrlText),
                  onDismissed: (direction) {
                    setState(() {
                      _imgUrlList.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          imgUrlText,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                                Icons.image_not_supported_outlined);
                          },
                          filterQuality: FilterQuality.low,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(child: Text('Loading'));
                          },
                        ),
                      ),
                      subtitle: Text(
                        '${index + 1}. $imgUrlText',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget urlField() {
    return TextFormField(
      controller: _urlController,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'ပုံurl',
        errorText: _urlEmpty,
        suffix: IconButton(
          onPressed: () {
            Connectivity().checkConnectivity().then((value) {
              if (value == ConnectivityResult.none) {
                return ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No Internet Connection'),
                  ),
                );
              } else {
                if (_urlController.text.isNotEmpty) {
                  setState(() {
                    _imgUrlList.add(_urlController.text);
                    _urlController.clear();
                    _urlEmpty = null;
                  });
                } else {
                  setState(() {
                    _urlEmpty = 'ပုံ url ဖြည့်ပါ!';
                  });
                }
              }
            });
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget contentField() {
    return TextFormField(
      controller: _contentController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 8,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'အကြောင်းရာ',
        suffix: _contentController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    _contentController.clear();
                  });
                },
                icon: const Icon(Icons.clear),
              ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'အကြောင်းအရာဖြည့်ပါ!';
        }
        return null;
      },
    );
  }

  Widget titleField() {
    return TextFormField(
      controller: _titleController,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'ခေါင်းစဉ်',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ခေါင်းစီးစာသားဖြည့်ပါ!';
        }
        return null;
      },
    );
  }

  Widget sheetWidget(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListView(
        children: [
          if (_isLoading)
            const CircularProgressIndicator()
          else
            TextButton.icon(
              onPressed: _uploadData,
              icon: const Icon(Icons.done),
              label: const Text('ပို့စ်တင်ရန်'),
            ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleController.text,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(_contentController.text),
                const SizedBox(height: 8),
                Image.network(
                  _imgUrlList.first,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onUpload() {
    if (_formKey.currentState!.validate()) {
      if (_imgUrlList.isNotEmpty) {
        Connectivity().checkConnectivity().then(
          (value) {
            if (value == ConnectivityResult.none) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No Internet Connection'),
                ),
              );
            } else {
              showModalBottomSheet<bool>(
                context: context,
                enableDrag: true,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (context) {
                  final textTheme = Theme.of(context).textTheme;
                  return SafeArea(child: sheetWidget(textTheme));
                },
              ).then((value) {
                if (value == null) {
                  return;
                } else if (value) {
                  context.pop();
                } else if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('အမှားအယွင်းရှိနေသည်!'),
                    ),
                  );
                }
              });
            }
          },
        );
      } else {
        setState(() {
          _urlEmpty = 'အနည်းဆုံး ပုံurl တစ်ခုထည့်ပါ!';
        });
      }
    }
  }

  void _uploadData() {
    setState(() {
      _isLoading = true;
    });
    final data = SlideData(
      title: _titleController.text,
      content: _contentController.text,
      imgUrlList: _imgUrlList,
    );

    _db.collection(Util.collectionName).add(data.toMap()).then((value) {
      debugPrint('Data: ${value.id} has been uploaded!');
      context.pop(true);
    }).onError((error, stackTrace) {
      context.pop(false);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
