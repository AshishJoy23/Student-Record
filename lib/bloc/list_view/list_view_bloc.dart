import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:student_record_hive/database/functions/db_functions.dart';
import 'package:student_record_hive/database/model/db_model.dart';

part 'list_view_event.dart';
part 'list_view_state.dart';

class ListViewBloc extends Bloc<ListViewEvent, ListViewState> {
  ListViewBloc() : super(ListViewInitial()) {
    on<StudentListView>((event, emit) {
      List<StudentModel> studentViewList =
          studentBox.values.toList();
      return emit(ListViewState(studentList: studentViewList));
    });

    on<DeleteListView>((event, emit) {
      studentBox.deleteAt(event.index);
      List<StudentModel> studentViewList =
          studentBox.values.toList();
      return emit(ListViewState(studentList: studentViewList));
    });
  }
}
