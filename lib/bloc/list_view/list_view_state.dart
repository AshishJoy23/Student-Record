part of 'list_view_bloc.dart';

@immutable
class ListViewState {
  List<StudentModel> studentList;
  ListViewState({required this.studentList});
}

class ListViewInitial extends ListViewState {
  ListViewInitial() : super(studentList: []);
}
