import 'package:flutter/material.dart';
import 'package:ig/const.dart';
import 'package:ig/features/domain/entities/app_entity.dart';
import 'package:ig/features/domain/entities/comment/comment_entity.dart';
import 'package:ig/features/domain/entities/posts/post_entity.dart';
import 'package:ig/features/domain/entities/reply/replay_entity.dart';
import 'package:ig/features/domain/entities/user/user_entity.dart';
import 'package:ig/features/presentation/pages/coment_page.dart';
import 'package:ig/features/presentation/pages/credential/sign_in_page.dart';
import 'package:ig/features/presentation/pages/credential/sign_up_page.dart';
import 'package:ig/features/presentation/pages/edit_comment_page.dart';
import 'package:ig/features/presentation/pages/edit_profile_page.dart';
import 'package:ig/features/presentation/pages/edit_replay_page.dart';
import 'package:ig/features/presentation/pages/post_detail_page.dart';
import 'package:ig/features/presentation/pages/single_user_profile_page.dart';
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
        if(args is AppEntity){
          return routeBuilder(ComentPage(appEntity: args,));
        }else{
          return routeBuilder(NoPageFound());
        }
      }
      case PageConst.updateReplayPage: {
        if(args is ReplayEntity){
          return routeBuilder(EditReplayPage(replay: args));
        }else{
          return routeBuilder(NoPageFound());
        }
      }
      case PageConst.singlePostPage: {
        if(args is String){
          return routeBuilder(PostDetailPage(postId: args));
        }else{
          return routeBuilder(NoPageFound());
        }
      }
      case PageConst.singleUserPage: {
        if(args is String){
          return routeBuilder(SingleUserProfilePage(otherUid: args));
        }else{
          return routeBuilder(NoPageFound());
        }
      }
      case PageConst.signInPage: {
        return routeBuilder(SignInPage());
      }
      case PageConst.signUpPage: {
        return routeBuilder(SignUpPage());
      }
      case PageConst.updateCommentPage:{
        if(args is CommentEntity){
          return routeBuilder(EditCommentPage(comment: args));
        }else{
          return routeBuilder(NoPageFound());
        }
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