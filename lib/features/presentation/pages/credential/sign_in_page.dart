import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ig/const.dart';
import 'package:ig/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:ig/features/presentation/pages/credential/sign_up_page.dart';
import 'package:ig/features/presentation/widgets/button_container_widget.dart';
import 'package:ig/features/presentation/widgets/form_container_widget.dart';

import '../../cubit/auth/cubit/auth_cubit.dart';
import '../../main_screen/main_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = false;
  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocConsumer<CredentialCubit,CredentialState>(
        builder: (context, state) {
          if(state is CredentialSuccess){
            return BlocBuilder<AuthCubit,AuthState>(
              builder: (context, state) {
                if(state is Authenticated){
                  return MainScreen(uid: state.uid);
                }else{
                  return _body();
                }
              }, );
          }
          return _body();
          
        }, 
        listener: (context, state) {
          if(state is CredentialSuccess){
            BlocProvider.of<AuthCubit>(context).loggedIn(); 
          }
          if(state is CredentialFailure){
            
            toast("Invalid Email and Password");
          }
        },)
    );
  }
  _body(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(flex: 2, child: Container()),
            Center(child: Image.asset("assets/Instagram.png")),
            sizeVer(30),
             FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            sizeVer(15),
             FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            sizeVer(15),
            ButtonContainerWidget(
              color: blueColor,
              text: "Sign In",
              onTapListener: () {
                _signIn();
              },
            ),
            Flexible(flex: 2, child: Container()),
            const Divider(
              color: secondaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have account?",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.signUpPage);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                )
              ],
            )
          ],
        ),
      );
  }
  _signIn(){
    BlocProvider.of<CredentialCubit>(context).signInUser(email: _emailController.text, password: _passwordController.text).then((a){
        _clear();
    });
  }
   _clear(){
    setState(() {
      _emailController.clear();
      
      _passwordController.clear();
      _isSignIn=false;
    });
  }
}
