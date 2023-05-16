//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:student_record_hive/database/model/db_model.dart';

part 'search_view_event.dart';
part 'search_view_state.dart';

class SearchViewBloc extends Bloc<SearchViewEvent, SearchViewState> {
  SearchViewBloc() : super(SearchViewInitial()) {

    on<SearchViewList>((event, emit) {
      List<StudentModel> studentList =
          Hive.box<StudentModel>('student-db').values.toList();
      List<StudentModel> filteredList = studentList
          .where((element) =>
              element.name.toLowerCase().contains(event.searchedQuery.toLowerCase()))
          .toList();
      if (filteredList.isEmpty) {
        return emit(SearchViewState(studentList: studentList, filteredList: const []));
      } else {
        return emit(SearchViewState(studentList: studentList, filteredList: filteredList));
      }
    });

    on<IdleViewList>((event, emit) {
      List<StudentModel> studentList =
          Hive.box<StudentModel>('student-db').values.toList();
      List<StudentModel> filteredList = List.from(studentList);
      return emit(SearchViewState(studentList: studentList, filteredList: filteredList));
    });
  }
}
