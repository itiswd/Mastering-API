import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mastering_flutter_api/cache/cache_helper.dart';
import 'package:mastering_flutter_api/core/api/api_consumer.dart';
import 'package:mastering_flutter_api/core/api/end_points.dart';
import 'package:mastering_flutter_api/core/errors/exceptions.dart';
import 'package:mastering_flutter_api/cubit/user_state.dart';
import 'package:mastering_flutter_api/models/signin_model.dart';

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
  //Sign in method
  signIn() async {
    try {
      emit(SignInLoading());
      final response = await api.post(
        EndPoints.signIn,
        data: {
          ApiKeys.eamil: signInEmail.text,
          ApiKeys.password: signInPassword.text,
        },
      );
      signInModel = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(signInModel!.token);
      CacheHelper().saveData(key: ApiKeys.token, value: signInModel!.token);
      CacheHelper().saveData(key: ApiKeys.id, value: decodedToken[ApiKeys.id]);

      emit(SignInSuccess());
    } on ServerException catch (e) {
      emit(SignInError(e.errorModel.errorMessage));
    }
  }
}
