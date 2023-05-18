import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mm_flutter_app/data/models/user/user.dart';
import 'package:mm_flutter_app/data/models/user/user_provider.dart';
import '../../atoms/text_form_field_widget.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your email'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: YourEmail(),
        ),
      ),
    );
  }
}

class YourEmail extends StatefulWidget {
  const YourEmail({Key? key}) : super(key: key);

  @override
  State<YourEmail> createState() => _YourEmailState();
}

class _YourEmailState extends State<YourEmail> {
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    emailController.text = user!.email!;

    return userProvider.queryUser(
      onLoading: () {
        return const SizedBox.shrink();
      },
      onError: (error) {
        return Text('Error: $error');
      },
      onData: (data) {
        User user = User.fromJson(data);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your email'),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormFieldWidget(
                    textController: emailController,
                    onPressed: (v) {},
                    label: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        emailController.text = user.email!;
                        return '''Email can't be empty''';
                      }
                    },
                    obscureText: false),
                const SizedBox(
                  height: 15,
                ),
                const Expanded(child: SizedBox()),
                Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await userProvider.updateUserData(
                                email: emailController.text);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Your email is updated.'),
                            ));
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'))),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}