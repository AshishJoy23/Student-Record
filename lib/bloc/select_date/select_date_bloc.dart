//import 'package:bloc/bloc.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'select_date_event.dart';
part 'select_date_state.dart';

class SelectDateBloc extends Bloc<SelectDateEvent, SelectDateState> {
  SelectDateBloc() : super(SelectDateInitial()) {
    on<ChooseDOB>((event, emit) async {
      DateTime? selectedDOB = await chooseDate(context: event.context);
      log("${selectedDOB.toString()}------*****");
      return emit(SelectDateState(date: selectedDOB));
    });
    on<RemoveDOB>((event, emit) {
      return emit(SelectDateState(date: null));
    });
  }
}

chooseDate({required BuildContext context}) async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
    lastDate: DateTime.now(),
  );
  return selectedDate;
}
