import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mastering_flutter_api/cache/cache_helper.dart';
import 'package:mastering_flutter_api/core/api/api_consumer.dart';
import 'package:mastering_flutter_api/core/api/end_points.dart';
import 'package:mastering_flutter_api/core/errors/exceptions.dart';
import 'package:mastering_flutter_api/core/functions/upload_image_to_api.dart';
import 'package:mastering_flutter_api/cubit/user_state.dart';
import 'package:mastering_flutter_api/models/signin_model.dart';
import 'package:mastering_flutter_api/models/signup_model.dart';
import 'package:mastering_flutter_api/models/user_model.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.api) : super(UserInitial());
  final ApiConsumer api;
  //Sign in Form key
  GlobalKey<FormState> signInFormKey = GlobalKey();
  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  //Sign Up Form key
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  //Profile Pic
  XFile? profilePic;
  //Sign up name
  TextEditingController signUpName = TextEditingController();
  //Sign up phone number
  TextEditingController signUpPhoneNumber = TextEditingController();
  //Sign up email
  TextEditingController signUpEmail = TextEditingController();
  //Sign up password
  TextEditingController signUpPassword = TextEditingController();
  //Sign up confirm password
  TextEditingController confirmPassword = TextEditingController();
  SignInModel? signInModel;
  //Upload profile pic
  Future<void> uploadProfilePic(XFile? image) async {
    profilePic = image;
    emit(UploadProfilePic());
  }

  //Sign up method
  signUp() async {
    try {
      emit(SignUpLoading());
      final response = await api.post(
        EndPoints.signUp,
        isFormData: true,
        data: {
          ApiKeys.name: signUpName.text,
          ApiKeys.phone: signUpPhoneNumber.text,
          ApiKeys.email: signUpEmail.text,
          ApiKeys.password: signUpPassword.text,
          ApiKeys.confirmPassword: confirmPassword.text,
          ApiKeys.profilePic: await uploadImageToApi(profilePic!),
          ApiKeys.location:
              '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
        },
      );
      final signUpModel = SignUpModel.fromJson(response);
      emit(SignUpSuccess(message: signUpModel.message));
    } on ServerException catch (e) {
      emit(SignUpError(errorMessage: e.errorModel.errorMessage));
    }
  }

  //Sign in method
  signIn() async {
    try {
      emit(SignInLoading());
      final response = await api.post(
        EndPoints.signIn,
        data: {
          ApiKeys.email: signInEmail.text,
          ApiKeys.password: signInPassword.text,
        },
      );
      signInModel = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(signInModel!.token);
      CacheHelper().saveData(key: ApiKeys.token, value: signInModel!.token);
      CacheHelper().saveData(key: ApiKeys.id, value: decodedToken[ApiKeys.id]);

      emit(SignInSuccess());
    } on ServerException catch (e) {
      emit(SignInError(errorMessage: e.errorModel.errorMessage));
    }
  }

  //Get user data
  getUserData() async {
    try {
      emit(UserProfileLoading());
      final response = await api.get(
        EndPoints.getUserProfileEndpoint(
          CacheHelper().getData(key: ApiKeys.id),
        ),
      );
      emit(UserProfileSuccess(userModel: UserModel.fromJson(response)));
    } on ServerException catch (e) {
      emit(UserProfileError(errorMessage: e.errorModel.errorMessage));
    }
  }
}
