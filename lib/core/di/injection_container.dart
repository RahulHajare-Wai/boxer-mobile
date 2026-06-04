import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_local_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';
import '../database/app_database.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Register Database
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // Register DataSources
  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(),
  );
  sl.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(),
  );

  // Register Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );
  sl.registerSingleton<AuthLocalRepository>(
    AuthLocalRepository(
      database: sl<AppDatabase>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Register UseCases
  sl.registerSingleton<LoginUseCase>(
    LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<RegisterUseCase>(
    RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<LogoutUseCase>(
    LogoutUseCase(sl<AuthRepository>()),
  );

  // Register BLoC (last, after all dependencies)
  sl.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      authLocalRepository: sl<AuthLocalRepository>(),
    ),
  );

  // Register Home BLoC
  sl.registerSingleton<HomeBloc>(HomeBloc());

  // Register Task BLoC
  sl.registerSingleton<TaskBloc>(TaskBloc());
}