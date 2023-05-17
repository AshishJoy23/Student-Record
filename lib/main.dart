import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_record_hive/bloc/image_picker/image_picker_bloc.dart';
import 'package:student_record_hive/bloc/list_view/list_view_bloc.dart';
import 'package:student_record_hive/bloc/search_view/search_view_bloc.dart';
import 'package:student_record_hive/bloc/select_date/select_date_bloc.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';
import 'package:student_record_hive/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
    Hive.registerAdapter(StudentModelAdapter());
  }
  openStudentBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ImagePickerBloc();
          },
        ),
        BlocProvider(
          create: (context) {
            return SelectDateBloc();
          },
        ),
        BlocProvider(
          create: (context) {
            return SearchViewBloc();
          },
        ),
        BlocProvider(
          create: (context) {
            return ListViewBloc();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const ScreenSplash(),
      ),
    );
  }
}
