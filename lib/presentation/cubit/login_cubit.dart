import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/service/login_api.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUserApi api;

  LoginCubit(this.api) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    try {
      final response = await api.loginUser(username, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.accessToken);

      emit(LoginSuccess(response.accessToken));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
