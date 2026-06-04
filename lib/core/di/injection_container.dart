import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/models/auth_local_database.dart';
import '../../features/auth/data/repositories/auth_local_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_session_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/datasources/home_local_datasource.dart';
import '../../features/home/data/repositories/home_local_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/tasks/data/datasources/task_local_datasource.dart';
import '../../features/tasks/data/repositories/task_local_repository.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';
import '../config/api_config.dart';
import '../network/network_info.dart';
import '../../network/api_client.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton<Connectivity>(Connectivity());
  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl(sl<Connectivity>()));
  sl.registerSingleton<ApiClient>(ApiClient(baseUrl: ApiConfig.baseUrl));
  sl.registerSingleton<AuthLocalDatabase>(AuthLocalDatabase());

  sl.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(sl<ApiClient>()),
  );
  sl.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerSingleton<AuthLocalRepository>(
    AuthLocalRepository(
      localDataSource: sl<AuthLocalDataSource>(),
      database: sl<AuthLocalDatabase>(),
    ),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localRepository: sl<AuthLocalRepository>(),
      networkInfo: sl<NetworkInfo>(),
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

  sl.registerSingleton<TaskLocalDataSource>(TaskLocalDataSourceImpl());
  sl.registerSingleton<TaskLocalRepository>(
    TaskLocalRepository(localDataSource: sl<TaskLocalDataSource>()),
  );
  sl.registerSingleton<HomeLocalDataSource>(HomeLocalDataSourceImpl());
  sl.registerSingleton<HomeLocalRepository>(
    HomeLocalRepository(localDataSource: sl<HomeLocalDataSource>()),
  );

  sl.registerSingleton<HomeBloc>(HomeBloc());
  sl.registerSingleton<TaskBloc>(TaskBloc());
}
