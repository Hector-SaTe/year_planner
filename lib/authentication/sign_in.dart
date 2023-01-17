import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/providers.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userController = useTextEditingController();
    final passController = useTextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 0),
        child: Column(
          children: [
            Text(
              "Enter your email address:",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              autocorrect: false,
            ),
            Text(
              "Enter your password:",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            TextField(
              controller: passController,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              autocorrect: false,
              obscureText: true,
            ),
            ElevatedButton(
                onPressed: (() {
                  ref.read(authServiceProvider).signIn(
                      email: userController.text.trim(),
                      password: passController.text.trim());
                }),
                child: const Text("Sign in"))
          ],
        ),
      ),
    );
  }
}
