import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:year_planner/providers.dart';
import 'package:year_planner/theme/custom_colors.dart';
import 'package:year_planner/utils/snackbar_messages.dart';

class ForgotPass extends HookConsumerWidget {
  const ForgotPass({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double titleWidth = 90;
    final userController = useTextEditingController();

    void tryReset() {
      final validEmail = userController.text.isValidEmail();
      if (!validEmail) return;
      ref
          .read(authServiceProvider)
          .resetPass(email: userController.text.trim())
          .then((value) => showSnackBarMessage(context, value,
              value[0] == " " ? SnackBarType.info : SnackBarType.error));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: greyBG,
          title: Text(
            'Reset Password?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 32),
                child: Text("Receive an email to reset your password"),
              ),
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
              ElevatedButton.icon(
                  onPressed: tryReset,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text("Reset Password")),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
