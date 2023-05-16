part of 'select_date_bloc.dart';

@immutable
class SelectDateEvent {}

class ChooseDOB extends SelectDateEvent {
  final BuildContext context;

  ChooseDOB({required this.context});
}
