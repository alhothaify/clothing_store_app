import 'package:ecommerce/presentation/home/bloc/profile_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/auth/usecases/get_user.dart';
import '../../../service_locator.dart';

class ProfileImageDisplayCubit extends Cubit<ProfileImageState> {
  ProfileImageDisplayCubit() : super(ProfileImageLoading());

  void displayImage() async {
    var returnedData = await sl<GetUserUseCase>().call();
    returnedData.fold(
            (error){
          emit(
              ProfileImageFailure()
          );
        },
            (data){
          emit(
              ProfileImageLoaded(
                  user: data
              )
          );
        }
    );
  }

}