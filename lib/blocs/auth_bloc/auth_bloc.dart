import 'package:bloc/bloc.dart';
import 'package:jkblog/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthRegisterRequested>(_onAuthRegisteredRequested);

    on<AuthLoginRequested>(_onAuthLoginRequested);

    on<AuthGoogleRegisterRequested>(_onAuthGoogleRegisterRequested);

    on<ShowPassword>(_onShowPassword);

    on<AuthSignOut>(_onAuthSignOut);
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print("AuthBloc: $change");
  }

  void _onAuthRegisteredRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthSLoading());

    try {
      final name = event.name;
      final email = event.email;
      final password = event.password;

      await AuthServices().signUpUserwithEmailandPassword(name, email, password).then((value) {
        emit(AuthSuccess());
      });
    } catch (e) {
      emit(AuthFailure(error: "Please enter valid Email or Password!"));
    }
  }

  void _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthSLoading());

    try {
      final email = event.email;
      final password = event.password;

      await AuthServices().loginwithEmailAndPassword(email, password).then((value) {
        emit(AuthSuccess());
      });
    } catch (e) {
      emit(AuthFailure(error: "Please enter valid Email or Password!"));
    }
  }

  void _onAuthGoogleRegisterRequested(AuthGoogleRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthSLoading());
    try {
      await AuthServices().googlesignInMethod().then((value) async {
        if (value == true) {
          emit(AuthSuccess());
        } else if (value == null) {
          emit(AuthFailure(error: "Google account is not selected!"));
        } else {
          emit(AuthFailure(error: value));
        }
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onAuthSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthSLoading());

    try {
      await AuthServices().signOutMethod().then((value) {
        if (value) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(error: value.toString()));
        }
      });
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onShowPassword(ShowPassword event, Emitter<AuthState> emit) {
    event.isPassShowed = !event.isPassShowed;

    if (event.isPassShowed) {
      emit(AuthInitial());
    } else {
      emit(PasswordShown());
    }
  }
}
