import '../datasources/task_local_datasource.dart';

/// Offline task logic. Add Drift models under data/models/ when implementing tasks.
class TaskLocalRepository {
  const TaskLocalRepository({required TaskLocalDataSource localDataSource});
}
