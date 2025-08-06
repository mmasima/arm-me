import 'package:armme/data/service/demo_system_api.dart';
import 'package:armme/presentation/cubit/dashboard/dashboard_cubit.dart';
import 'package:armme/presentation/cubit/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardCubit dashboardCubit;

  @override
  void initState() {
    super.initState();
    dashboardCubit = DashboardCubit(DemoSystemApi());
    dashboardCubit.loadPartitionStatus();
  }

  @override
  void dispose() {
    dashboardCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dashboardCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          backgroundColor: Colors.amber,
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              final data = state.status;

              return RefreshIndicator(
                onRefresh: () => dashboardCubit.loadPartitionStatus(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      "System Status",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    buildStatusCard(
                      title: "Away Armed",
                      value: data.awayArmed,
                      icon: Icons.security,
                      color: data.awayArmed ? Colors.green : Colors.grey,
                    ),
                    buildStatusCard(
                      title: "Stay Armed",
                      value: data.stayArmed,
                      icon: Icons.home,
                      color: data.stayArmed ? Colors.green : Colors.grey,
                    ),
                    buildStatusCard(
                      title: "Exit Delay",
                      value: data.exitDelay,
                      icon: Icons.timer,
                      color: data.exitDelay ? Colors.orange : Colors.grey,
                    ),
                    buildStatusCard(
                      title: "Alarmed",
                      value: data.alarmed,
                      icon: Icons.warning,
                      color: data.alarmed ? Colors.red : Colors.grey,
                    ),
                    buildStatusCard(
                      title: "Other Alarmed",
                      value: data.otherAlarmed,
                      icon: Icons.report_problem,
                      color: data.otherAlarmed ? Colors.redAccent : Colors.grey,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => dashboardCubit.loadPartitionStatus(),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Refresh"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is DashboardError) {
              return Center(
                child: Text(
                  "Error: Failed to load data, please try again",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text("Idle"));
            }
          },
        ),
      ),
    );
  }

  Widget buildStatusCard({
    required String title,
    required bool value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Switch(value: value, onChanged: null, activeColor: color),
      ),
    );
  }
}
