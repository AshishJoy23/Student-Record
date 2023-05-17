import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:student_record_hive/Screens/each_student_info.dart';
import 'package:student_record_hive/bloc/search_view/search_view_bloc.dart';
import 'package:student_record_hive/core/constants.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log('search screen build>>>><<<<<<');
    return Scaffold(
      backgroundColor: kScaffoldBgColor,
      appBar: AppBar(
          leading: IconButton(
            icon: kLeadingIcon,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                onChanged: (value) => BlocProvider.of<SearchViewBloc>(context)
                    .add(SearchViewList(searchedQuery: value)),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: textController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          textController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                          BlocProvider.of<SearchViewBloc>(context)
                              .add(IdleViewList());
                        }),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )),
      body: BlocBuilder<SearchViewBloc, SearchViewState>(
        builder: (context, state) {
          return (state.filteredList.isEmpty)
              ? Center(
                  child: Lottie.asset('assets/animations/search2.json'),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.separated(
                    itemBuilder: (ctx, index) {
                      final data = state.filteredList[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              final currentIndex = state.studentList.indexWhere(
                                  (element) => element.name == data.name);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EachStudentInfo(index: currentIndex)),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                File(data.image),
                              ),
                              radius: 40,
                            ),
                            title: Text(data.name),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider();
                    },
                    itemCount: state.filteredList.length,
                  ),
                );
        },
      ),
    );
  }
}
