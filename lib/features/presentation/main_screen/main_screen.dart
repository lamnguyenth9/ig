import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ig/const.dart';
import 'package:ig/features/presentation/cubit/user/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:ig/features/presentation/pages/activity_page.dart';
import 'package:ig/features/presentation/pages/home_page.dart';
import 'package:ig/features/presentation/pages/profile_page.dart';
import 'package:ig/features/presentation/pages/search_page.dart';
import 'package:ig/features/presentation/pages/up_load_page.dart';


class MainScreen extends StatefulWidget {
  final String uid;
  
  const MainScreen({super.key, required this.uid});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex=0;
  late PageController controller;
  @override
  void initState() {
    controller=PageController();
    BlocProvider.of<GetSingleUserCubit>(context).getUsers(uid: widget.uid);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void navigationTapped(int index){
    controller.jumpToPage(index);
  }
  void onPageChanged(int index){
    setState(() {
      _currentIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {

        if(state is GetSingleUserLoaded){
          final currentUser = state.user;
          return Scaffold(
          backgroundColor: backgroundColor,
          bottomNavigationBar: CupertinoTabBar(
            onTap: navigationTapped,
            backgroundColor: backgroundColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home,color: primaryColor,),
                label: ""
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search,color: primaryColor,),
                label: ""
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,color: primaryColor,),
                label: ""
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.favorite,color: primaryColor,),
                label: ""
                ),
                BottomNavigationBarItem(
                icon: Icon(Icons.person,color: primaryColor,),
                label:
                 ""
                ),
                
            ]),
            body: PageView(
              controller: controller,
              onPageChanged: onPageChanged,
              children:  [
                HomePage(),
                SearchPage(),
                UpLoadPage(currentUser: currentUser,),
                ActivityPage(),
                ProfilePage(currentUser: currentUser,)
              ],
            ),
        );
        }
        return Container(child: Text("1",style: TextStyle(color: Colors.white),),);
      },
    );
  }
}