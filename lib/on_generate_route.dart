import 'package:flutter/material.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/pages/coment_page.dart';
import 'package:ig/features/presentation/pages/credential/sign_in_page.dart';
import 'package:ig/features/presentation/pages/credential/sign_up_page.dart';
import 'package:ig/features/presentation/pages/edit_profile_page.dart';
import 'package:ig/features/presentation/pages/update_post_page.dart';

class OnGenerateRoute{
  static Route<dynamic>? route(RouteSettings settings){
    final args=settings.arguments;
    switch(settings.name){
      case PageConst.editProfilePage: {
        if(args is UserEntity){
          return routeBuilder(EditProfilePage(currentUser: args,));
        }else{
          return routeBuilder(NoPageFound());
        }
      }
      case PageConst.updatePostPage: {
        if(args is PostEntity){
          return routeBuilder(UpdatePostPage(post: args,));
        }else{
          return routeBuilder(NoPageFound());
        }
      }
      case PageConst.commentPage: {
        return routeBuilder(CommentPage());
      }
      case PageConst.signInPage: {
        return routeBuilder(SignInPage());
      }
      case PageConst.signUpPage: {
        return routeBuilder(SignUpPage());
      }
      default: {  NoPageFound();}
    }
  }
}
dynamic routeBuilder(Widget child){
  return MaterialPageRoute(builder: (_)=>child);
}
class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No Page Found"),
      ),
      
    );
  }
}