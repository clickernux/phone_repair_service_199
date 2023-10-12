import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _showPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Image.asset('assets/images/199PhoneServiceLogo.png'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              autofillHints: const [
                '199phoneservice@gmail.com',
                'clickernux@gmail.com',
              ],
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                // helperText: 'yourname@gmail.com',
                label: Text('Email'),
                icon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please! Provides an email';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !_showPassword,
              decoration: const InputDecoration(
                label: Text('Password'),
                icon: Icon(Icons.key),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password must not be empty';
                }
                return null;
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(value: _showPassword, onChanged: _onChanged),
                const Text('Show Password'),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then(
                    (value) {
                      debugPrint(value.user?.email);
                      context.goNamed('admin_panel');
                    },
                  ).whenComplete(() {
                    setState(() {
                      _isLoading = false;
                    });
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.toString(),
                        ),
                      ),
                    );
                  });
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _onChanged(bool? value) {
    setState(() {
      _showPassword = value ?? false;
    });
  }
}
