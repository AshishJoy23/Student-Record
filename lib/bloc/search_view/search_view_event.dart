part of 'search_view_bloc.dart';

@immutable
abstract class SearchViewEvent {}

class SearchViewList extends SearchViewEvent {
  String searchedQuery;
  SearchViewList({required this.searchedQuery});
}

class IdleViewList extends SearchViewEvent {}
