import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_repair_service_199/model/slide_data.dart';
import 'package:phone_repair_service_199/util.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
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
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (imgUrlList.isNotEmpty) {
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
                          isScrollControlled: true,
                          builder: (context) {
                            final textTheme = Theme.of(context).textTheme;
                            return sheetWidget(textTheme);
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
                    urlEmpty = 'အနည်းဆုံး ပုံurl တစ်ခုထည့်ပါ!';
                  });
                }
              }
            },
            icon: const Icon(Icons.publish),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget sheetWidget(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
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
                  titleController.text,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(contentController.text),
                const SizedBox(height: 8),
                Image.network(
                  imgUrlList.first,
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Form(
        key: formKey,
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
            SliverList.builder(
              itemCount: imgUrlList.length,
              itemBuilder: (context, index) {
                final imgUrlText = imgUrlList[index];
                return Dismissible(
                  key: Key(imgUrlText),
                  onDismissed: (direction) {
                    setState(() {
                      imgUrlList.removeAt(index);
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
      controller: imgUrlController,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'ပုံurl',
        errorText: urlEmpty,
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
                if (imgUrlController.text.isNotEmpty) {
                  setState(() {
                    imgUrlList.add(imgUrlController.text);
                    imgUrlController.clear();
                    urlEmpty = null;
                  });
                } else {
                  setState(() {
                    urlEmpty = 'ပုံ url ဖြည့်ပါ!';
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
      controller: contentController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 8,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'အကြောင်းရာ',
        suffix: contentController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    contentController.clear();
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

  TextFormField titleField() {
    return TextFormField(
      controller: titleController,
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

  void _uploadData() {
    setState(() {
      isLoading = true;
    });
    final data = SlideData(
      title: titleController.text,
      content: contentController.text,
      imgUrlList: imgUrlList,
    );

    db.collection(Util.collectionName).add(data.toMap()).then((value) {
      debugPrint('Data: ${value.id} has been uploaded!');
      context.pop(true);
    }).onError((error, stackTrace) {
      context.pop(false);
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }
}
