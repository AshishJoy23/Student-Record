//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<CaptureImage>((event, emit) async{
     XFile? result = await pickSelectedImage(ImageSource.camera);
      return emit(ImagePickerState(image: result));
    });

    on<ChooseImage>((event, emit) async{
     XFile? result = await pickSelectedImage(ImageSource.gallery);
      return emit(ImagePickerState(image: result));
    });

    on<RemoveImage>((event, emit) {
      return emit(ImagePickerState(image: null));
    });

  }
}

Future<XFile?> pickSelectedImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    var imageFile = pickedFile;
    return imageFile;
  }

