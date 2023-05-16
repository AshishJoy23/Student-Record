part of 'search_view_bloc.dart';

@immutable
class SearchViewState {
  List<StudentModel> studentList;
  List<StudentModel> filteredList;
  SearchViewState({required this.studentList, required this.filteredList});
}

class SearchViewInitial extends SearchViewState {
  SearchViewInitial() : super(studentList: [], filteredList: List.from(Hive.box<StudentModel>('student-db').values.toList()));
}
