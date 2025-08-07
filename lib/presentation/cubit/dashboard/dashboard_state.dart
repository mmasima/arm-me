import 'package:armme/data/model/partition_status_response.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PartitionStatusResponse status;

  DashboardLoaded(this.status);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

class ArmSystemLoading extends DashboardState {}

class ArmSystemSubmit extends DashboardState {}


class ArmSystemError extends DashboardState {}

