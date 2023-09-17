import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/cubit/bloc_observer.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var token = FirebaseMessaging.instance.getToken();
  print(token);

  Future<void> firebaseMessagingBackgroundHandler() async{
    print('on-Background Message');
    showToast(msg: 'on-Background Message', state: ToastStates.SUCCESS);
  }

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(msg: 'on message', state: ToastStates.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(msg: 'on-open message', state: ToastStates.SUCCESS);

  });

  FirebaseMessaging.onBackgroundMessage((message) {
    return firebaseMessagingBackgroundHandler();
  });

  await CacheHelper.init();
  await Firebase.initializeApp();

  uId = CacheHelper.getData(key: 'uId');
  print(uId);

  Widget widget;
  if (uId != null) {
    widget = const HomePage();
  } else {
    widget = LoginScreen();
  }

  Bloc.observer = MyBlocObserver();
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit(),),
        BlocProvider(create: (BuildContext context) => SocialCubit()..getUserData()..getPosts()..getUsers(),),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Social App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
