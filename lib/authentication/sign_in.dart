import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/authentication/forgot_pass.dart';
import 'package:year_planner/authentication/register.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/utils/snackbar_messages.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double titleWidth = 90;
    const int passLength = 10;

    final userController = useTextEditingController();
    final passController = useTextEditingController();

    var currentPassLength = useState<int>(0);
    passController.addListener(
        () => currentPassLength.value = passController.text.length);

    void trySignIn() {
      final validEmail = userController.text.isValidEmail();
      final validPass = currentPassLength.value > 5;
      if (!validPass || !validEmail) return;

      ref
          .read(authServiceProvider)
          .signIn(
              email: userController.text.trim(),
              password: passController.text.trim())
          .then((value) => showSnackBarMessage(context, value,
              value[0] == " " ? SnackBarType.info : SnackBarType.error));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: titleWidth,
                    child: Text(
                      "Email",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: base),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: userController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Enter your Email address',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) =>
                          (input != null && input.isValidEmail())
                              ? null
                              : "Enter a valid email",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: titleWidth,
                    child: Text(
                      "Password",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: base),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: passController,
                      maxLength: passLength,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        counterText: "",
                        suffixText:
                            '${currentPassLength.value.toString()}/${passLength.toString()}',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        suffixStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      autocorrect: false,
                      obscureText: true,
                      onFieldSubmitted: (_) => trySignIn(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => (input != null && input.length > 5)
                          ? null
                          : "Enter min. 6 characters",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                  onPressed: trySignIn,
                  icon: const Icon(Icons.lock_open),
                  label: const Text("Sign in")),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("forgot password?"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPass()),
                    ),
                    icon: const Icon(Icons.lock_reset),
                    label: const Text("Reset"),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("no account yet?"),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Register()),
                    ),
                    icon: const Icon(Icons.verified_user_outlined),
                    label: const Text("Register"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
