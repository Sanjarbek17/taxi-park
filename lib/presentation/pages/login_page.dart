import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taxi_park/core/custom_colors.dart';
import 'package:taxi_park/data/repository/data_repo.dart';
import 'package:taxi_park/depency_injection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Login', style: context.textTheme.displaySmall),
            const SizedBox(height: 30),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: isObscure,
              decoration: InputDecoration(
                suffix: InkWell(
                  onTap: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  child: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                ),
                hintText: 'Password',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await locator<DataRepo>().login(
                        usernameController.text,
                        passwordController.text,
                      );
                    } on DioException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.response?.data['errors'].first['details'] ?? e.message),
                          ),
                        );
                      }
                      return;
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                      return;
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login successful'),
                        ),
                      );
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(100, 60),
                  ),
                  child: Text(
                    'Login',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
