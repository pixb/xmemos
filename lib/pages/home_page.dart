import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // Tab Navigation
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Center(
                      child: Text('All Lists', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: const Center(child: Text('Watch Lists')),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Center(child: Text('Alarm Lists')),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag),
                  color: Colors.green,
                  onPressed: () {
                    // Handle flag button press
                  },
                ),
              ],
            ),
          ),
          // List View
          Expanded(
            child: ListView(
              children: [
                // Boiler Item
                ListTile(
                  leading: const Icon(Icons.fireplace_outlined),
                  title: const Text('Boiler'),
                  subtitle: const Text('11 items'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(Icons.notifications, 2),
                      _buildStatusIndicator(Icons.flag, 3, color: Colors.green),
                      _buildStatusIndicator(Icons.error, 2, color: Colors.red),
                    ],
                  ),
                ),
                // Bioreactor Item
                ListTile(
                  leading: const Icon(Icons.science_outlined),
                  title: const Text('Bioreactor'),
                  subtitle: const Text('14 items'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(Icons.notifications, 2, color: Colors.orange),
                      _buildStatusIndicator(Icons.flag, 3, color: Colors.green),
                      _buildStatusIndicator(Icons.error, 2, color: Colors.red),
                    ],
                  ),
                ),
                // Boiler Alarms Item
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.red),
                  title: const Text('Boiler Alarms'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(Icons.notifications, 2, color: Colors.red),
                      _buildStatusIndicator(Icons.volume_off, 1, color: Colors.grey),
                      const SizedBox(width: 10),
                      const Text('FIC350112'),
                    ],
                  ),
                ),
                // GMP Alarms Item
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.pink),
                  title: const Text('GMP Alarms'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(Icons.notifications, 1, color: Colors.pink),
                      const SizedBox(width: 10),
                      const Text('AI14532'),
                    ],
                  ),
                ),
                // Utilities Alarms Item
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.grey),
                  title: const Text('Utilities Alarms'),
                ),
                // Safety Alarms Item
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.grey),
                  title: const Text('Safety Alarms'),
                ),
                // DeltaV Hardware Alerts Item
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.pink),
                  title: const Text('DeltaV Hardware Alerts'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(Icons.notifications, 1, color: Colors.pink),
                      const SizedBox(width: 10),
                      const Text('CTRL12-45'),
                    ],
                  ),
                ),
                // Device Alerts Item
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.purple),
                  title: const Text('Device Alerts'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatusIndicator(Icons.notifications, 1, color: Colors.purple),
                      const SizedBox(width: 10),
                      const Text('TT-23154'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(IconData icon, int count, {Color color = Colors.blue}) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 2),
          Text('$count', style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}