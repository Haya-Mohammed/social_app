import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginSuccessState) {
            showToast(
              msg: 'Login Successfully',
              state: ToastStates.SUCCESS,
            );
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            });
          } else if (state is SocialLoginErrorState) {
            showToast(
              msg: state.error,
              state: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          "Login now to communicate with friends",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 50),
                        defaultFormField(
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          controller: emailController,
                          inputType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        defaultFormField(
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          controller: passwordController,
                          inputType: TextInputType.visiblePassword,
                          isPassword: SocialLoginCubit.get(context).isPassword,
                          suffix: SocialLoginCubit.get(context).suffixIcon,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              // SocialLoginCubit.get(context).userLogin(
                              //   email: emailController.text,
                              //   password: passwordController.text,
                              // );
                            }
                          },
                          onSuffixPress: () {
                            SocialLoginCubit.get(context)
                                .changePassVisibility();
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoadingState,
                          builder: (context) => defaultButton(
                            text: 'Login',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            isUpperCase: true,
                            radius: 10,
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account? '),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Register now'.toUpperCase(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
