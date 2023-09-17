import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNavBar(int index) {
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavBarSuccessState());
    }
  }

  UserModel? userModel;
  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        // TODO: solve uId problem
        // .doc(uId)
        .doc('JsGhPmJ7YOJqfgHGvey8')
        .get()
        .then(
      (value) {
        userModel = UserModel.fromJson(value.data()!);
        emit(SocialGetUserSuccessState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(SocialGetUserErrorState(error.toString()));
      },
    );
  }

  File? profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? profileCover;
  Future<void> getProfileCover() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileCover = File(pickedFile.path);
      emit(SocialProfileCoverPickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileCoverPickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then((value) {
          updateUser(
            name: name,
            phone: phone,
            bio: bio,
            image: value,
          );
        }).catchError((error) {
          emit(SocialUploadProfileErrorState());
        });
      },
    ).catchError(
      (error) {
        emit(SocialUploadProfileErrorState());
      },
    );
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileCover!.path).pathSegments.last}')
        .putFile(profileCover!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    UserModel model = UserModel(
      name: name,
      bio: bio,
      phone: phone,
      email: userModel!.email,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then(
      (value) {
        getUserData();
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(SocialUpdateUserErrorState());
      },
    );
  }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel postModel = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    emit(SocialGetPostsLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetPostsSuccessState());
    }).catchError((error) => emit(SocialGetPostsErrorState(error.toString())));
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  List<UserModel> users = [];
  void getUsers() {
    emit(SocialGetAllUsersLoadingState());
    if (users.length == 0) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }

  MessageModel? messageModel;
  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    messageModel = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel!.toMap())
        .then(
          (value) => emit(SocialSendMessageSuccessState()),
        )
        .catchError(
          (error) => emit(SocialSendMessageErrorState(error.toString())),
        );

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chat')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel!.toMap())
        .then(
          (value) => emit(SocialSendMessageSuccessState()),
        )
        .catchError(
          (error) => emit(SocialSendMessageErrorState(error.toString())),
        );
  }

  List<MessageModel> messages = [];
  void getMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
    .orderBy('dateTime')
        .snapshots()
        .listen(
          (event) {
            messages = [];
            event.docs.forEach((element) {
              messages.add(MessageModel.fromJson(element.data()));
            });
            emit(SocialGetMessagesSuccessState());
          }
        );
  }
}

//'JsGhPmJ7YOJqfgHGvey8'
