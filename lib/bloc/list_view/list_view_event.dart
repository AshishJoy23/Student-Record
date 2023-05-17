part of 'list_view_bloc.dart';

@immutable
abstract class ListViewEvent {}

class StudentListView extends ListViewEvent {}

class DeleteListView extends ListViewEvent {
  int index;
  DeleteListView({required this.index});
}
