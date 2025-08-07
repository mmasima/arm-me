import 'package:armme/data/model/partition_status_response.dart';
import 'package:armme/data/service/demo_system_api.dart';
import 'package:bloc/bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DemoSystemApi api;

  DashboardCubit(this.api) : super(DashboardInitial());

  Future<void> loadPartitionStatus() async {
    emit(DashboardLoading());
    try {
      PartitionStatusResponse partitionResponse;
      final openConnection = await api.openConnection();
      if (openConnection.succeeded) {
        partitionResponse = await api.getPartitionStatus();

        emit(DashboardLoaded(partitionResponse));
      } else {
        emit(DashboardError('Failed to get Partitiion status'));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<bool> armSystem(String value) async {
    emit(ArmSystemLoading());

    try {
      final response = await api.setPartitionValue(value);
      if (response.succeeded == true) {
        return true;
      } else {
        emit(ArmSystemError());
        return false;
      }
    } catch (e) {
      emit(ArmSystemError());
      return false;
    }
  }
}
