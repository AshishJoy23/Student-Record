import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:student_record_hive/bloc/list_view/list_view_bloc.dart';
import 'package:student_record_hive/core/constants.dart';
import 'package:student_record_hive/screens/each_student_info.dart';
import 'package:student_record_hive/screens/search_screen.dart';

class ScreenViewStudent extends StatelessWidget {
  const ScreenViewStudent({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ListViewBloc>(context).add(StudentListView());
    return Scaffold(
      backgroundColor: kScaffoldBgColor,
      appBar: AppBar(
        leading: IconButton(
          icon: kLeadingIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Registered Students',
          style: kAppbarTitleStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ScreenSearch()));
            },
            icon: const Icon(
              Icons.search,
              size: 28,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ListViewBloc, ListViewState>(
        builder: (context, state) {
          if (state.studentList.isEmpty) {
            return Center(
              child: Lottie.asset('assets/animations/no_data1.json'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (ctx, index) {
              final data = state.studentList[index];
              return Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(data.image)),
                    radius: 50,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EachStudentInfo(index: index)),
                    );
                  },
                  title: Text(data.name),
                  subtitle: const Text('Click to get Info'),
                  trailing: IconButton(
                    onPressed: () {
                      showAlertDialog(context, index);
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.redAccent,
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return kHeight10;
            },
            itemCount: state.studentList.length,
          );
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, int dbId) {
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = ElevatedButton(
      child: const Text("Ok"),
      onPressed: () {
        BlocProvider.of<ListViewBloc>(context).add(DeleteListView(index: dbId));

        showSnackBarMsg(context, Colors.green, "Item deleted Successfully");
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Do you Want to Delete ?"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
