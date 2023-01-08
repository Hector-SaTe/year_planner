import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<bool?> getPassword(BuildContext context, String pass) async {
  if (pass.isEmpty) return true;
  return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: ((context) =>
          HookConsumer(builder: (context, WidgetRef ref, child) {
            final passController = useTextEditingController();
            return AlertDialog(
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              actionsPadding: const EdgeInsets.all(16),
              title: Text(
                "Password required:",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              content: TextField(
                controller: passController,
                maxLength: 10,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 3)),
                    labelText: "password"),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Cancel'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (passController.text == pass) {
                            Navigator.of(context).pop(true);
                          } else {
                            passController.clear();
                            const message = SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Wrong password'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(message);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Accept'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          })));
}
