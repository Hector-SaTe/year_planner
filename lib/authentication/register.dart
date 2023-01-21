import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/utils/snackbar_messages.dart';

class Register extends HookConsumerWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double titleWidth = 90;
    const int passLength = 10;

    final userController = useTextEditingController();
    final passController = useTextEditingController();
    final confirmationController = useTextEditingController();

    var currentPassLength = useState<int>(0);
    passController.addListener(
        () => currentPassLength.value = passController.text.length);

    void tryRegister() {
      final validEmail = userController.text.isValidEmail();
      final validPass = currentPassLength.value > 5;
      final validConfirmation =
          confirmationController.value == passController.value;
      if (!validPass || !validEmail || !validConfirmation) return;

      ref
          .read(authServiceProvider)
          .signUp(
              email: userController.text.trim(),
              password: passController.text.trim())
          .then((value) {
        showSnackBarMessage(context, value,
            value[0] == " " ? SnackBarType.info : SnackBarType.error);
        //if (value[0] == " ") Navigator.pop(context);
        Navigator.pop(context);
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: greyBG,
          title: Text(
            'Register?',
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
                      //obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) => (input != null && input.length > 5)
                          ? null
                          : "Enter min. 6 characters",
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
                      "Confirm password",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: base),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: confirmationController,
                      maxLength: passLength,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Confirm your password',
                        counterText: "",
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      autocorrect: false,
                      //obscureText: true,
                      onFieldSubmitted: (_) => tryRegister(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) =>
                          (input != null && input == passController.text)
                              ? null
                              : "Passwords do not match",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                  onPressed: tryRegister,
                  icon: const Icon(Icons.lock_open),
                  label: const Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
