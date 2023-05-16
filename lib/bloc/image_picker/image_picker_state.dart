part of 'image_picker_bloc.dart';

@immutable
class ImagePickerState {
  XFile? image;
  ImagePickerState({required this.image});
}

class ImagePickerInitial extends ImagePickerState {
  ImagePickerInitial() : super(image: null);
}
