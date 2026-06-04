import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_local_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_session_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(),
  );
  sl.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerSingleton<AuthLocalRepository>(
    AuthLocalRepository(localDataSource: sl<AuthLocalDataSource>()),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localRepository: sl<AuthLocalRepository>(),
    ),
  );

  sl.registerSingleton<LoginUseCase>(
    LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<RegisterUseCase>(
    RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<LogoutUseCase>(
    LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<GetCachedSessionUseCase>(
    GetCachedSessionUseCase(sl<AuthRepository>()),
  );

  sl.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCachedSessionUseCase: sl<GetCachedSessionUseCase>(),
    ),
  );

  sl.registerSingleton<HomeBloc>(HomeBloc());
  sl.registerSingleton<TaskBloc>(TaskBloc());
}
