import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ig/const.dart';
import 'package:ig/features/presentation/widgets/search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchWidget(controller: _searchController),
                sizeVer(10),
                GridView.builder(
                  itemCount: 12,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,crossAxisSpacing: 5,
                        mainAxisSpacing: 5 ),
                    itemBuilder: (context, index) {
                      return Container(
                          width: 100,
                          height: 100,
                          color: secondaryColor,
                      );
                    },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
