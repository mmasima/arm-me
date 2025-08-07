import 'package:armme/data/service/demo_system_api.dart';
import 'package:armme/presentation/cubit/dashboard/dashboard_cubit.dart';
import 'package:armme/presentation/cubit/dashboard/dashboard_state.dart';
import 'package:armme/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardCubit dashboardCubit;
  bool isProcessing = false;

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

  Future<void> armSystem(bool shouldArm) async {
    final action = shouldArm ? 'AwayArm' : 'Disarm';

    setState(() => isProcessing = true);

    final result = await dashboardCubit.armSystem(action);

    if (!mounted) return;

    setState(() => isProcessing = false);

    if (result == true) {
      dashboardCubit.loadPartitionStatus();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: Text(
            'System ${shouldArm ? 'armed' : 'disarmed'} successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Failed'),
          content: const Text('Could not update system status.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Logged Out'),
        content: const Text('You have been logged out successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dashboardCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              onPressed: () => dashboardCubit.loadPartitionStatus(),
              icon: const Icon(Icons.refresh),
              tooltip: "Refresh",
            ),
          ],
        ),
        body: Stack(
          children: [
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading || state is ArmSystemLoading) {
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
                          color: data.awayArmed ? Colors.green : Colors.grey,
                          onToggle: () => armSystem(!data.awayArmed),
                        ),
                        buildStatusCard(
                          title: "Stay Armed",
                          value: data.stayArmed,
                          color: data.stayArmed ? Colors.green : Colors.grey,
                        ),
                        buildStatusCard(
                          title: "Exit Delay",
                          value: data.exitDelay,
                          color: data.exitDelay ? Colors.orange : Colors.grey,
                        ),
                        buildStatusCard(
                          title: "Alarmed",
                          value: data.alarmed,
                          color: data.alarmed ? Colors.red : Colors.grey,
                        ),
                        buildStatusCard(
                          title: "Other Alarmed",
                          value: data.otherAlarmed,
                          color: data.otherAlarmed
                              ? Colors.redAccent
                              : Colors.grey,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: logout,
                          label: const Text("Logout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
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
            if (isProcessing)
              Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusCard({
    required String title,
    required bool value,
    required Color color,
    VoidCallback? onToggle,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Switch(
          value: value,
          onChanged: (_) => onToggle?.call(),
          activeColor: color,
        ),
      ),
    );
  }
}
