import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_outlined;

  void changePassVisibility() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterChangePassVisibilityState());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
          createUser(name: name, email: email, phone: phone, uId: value.user!.uid);

    }).catchError((error) {
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
    String image = 'https://img.freepik.com/free-photo/social-media-still-life-with-man-shape_23-2149019168.jpg?w=360&t=st=1694266404~exp=1694267004~hmac=264df0effaae6fc398c3edc56d77758599c29a793d0abb6fdb4af52fbe6f81fb',
    String bio = 'write your bio...',
    String cover = 'https://images.ctfassets.net/7thvzrs93dvf/wpImage18643/2f45c72db7876d2f40623a8b09a88b17/linkedin-default-background-cover-photo-1.png?w=790&h=196&q=90&fm=png',
  }) {
    UserModel model = UserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      image: image,
      cover: cover,
      bio: bio,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc()
        .set(
          model.toMap(),
        )
        .then((value) {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error));
    });
  }
}
