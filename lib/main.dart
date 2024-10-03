import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:ig/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:ig/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:ig/features/presentation/cubit/post/single_post/cubit/get_post_single_cubit.dart';
import 'package:ig/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:ig/features/presentation/main_screen/main_screen.dart';
import 'package:ig/features/presentation/pages/credential/sign_up_page.dart';
import 'package:ig/firebase_options.dart';
import 'injection_container.dart' as di;
import 'features/presentation/pages/credential/sign_in_page.dart';
import 'on_generate_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>di.sl<AuthCubit>()..AppStarted(context)),
        BlocProvider(create: (_)=>di.sl<CredentialCubit>()),
        BlocProvider(create: (_)=>di.sl<UserCubit>()),
        BlocProvider(create: (_)=>di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_)=>di.sl<GetPostSingleCubit>()),
        BlocProvider(create: (_)=>di.sl<PostCubit>())
        
      ],
      child: MaterialApp(
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if(state is Authenticated){
                  return MainScreen(uid: state.uid,);
                }else{
                  return SignInPage();
                }
              },
            );
          }
        },
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}
