import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/authentication/splash.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/utils/snackbar_messages.dart';

/// TODO: validator for email and password not empty
/// navigation to sign up page and forgot password.

class SignIn extends HookConsumerWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userController = useTextEditingController();
    final passController = useTextEditingController();

    return Theme(
      data: ThemeData(colorSchemeSeed: base),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: greyBG,
            title: Text(
              'Sign in?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  "Enter your email address:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: base),
                ),
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  autocorrect: false,
                ),
                const SizedBox(height: 24),
                Text(
                  "Enter your password:",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: base),
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
                ElevatedButton.icon(
                    onPressed: (() async {
                      ref
                          .read(authServiceProvider)
                          .signIn(
                              email: userController.text.trim(),
                              password: passController.text.trim())
                          .then((value) => showSnackBarMessage(
                              context,
                              value,
                              value[0] == " "
                                  ? SnackBarType.info
                                  : SnackBarType.error));
                    }),
                    icon: const Icon(Icons.lock_open),
                    label: const Text("Sign in")),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("forgot password?"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.lock_reset),
                      label: const Text("Reset"),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("no account yet?"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.verified_user_outlined),
                      label: const Text("Register"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
