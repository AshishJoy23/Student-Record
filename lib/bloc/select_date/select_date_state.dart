part of 'select_date_bloc.dart';

@immutable
class SelectDateState {
  DateTime? date;
  SelectDateState({required this.date});
}

class SelectDateInitial extends SelectDateState {
  SelectDateInitial():super(date: null);
}
