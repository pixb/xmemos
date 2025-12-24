import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_device.dart';
import 'sensor_detail_page.dart';

class SensorListPage extends StatefulWidget {
  final String title;

  const SensorListPage({Key? key, required this.title}) : super(key: key);

  @override
  State<SensorListPage> createState() => _SensorListPageState();
}

class _SensorListPageState extends State<SensorListPage> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data for sensor devices
  final List<SensorDevice> _sensorDevices = [
    SensorDevice(
      id: 'PIC-10-101',
      title: 'Header Master',
      value: '139.0',
      unit: 'psig',
      statusColor: Colors.red,
      chartType: SensorChartType.line,
      chartData: [135.0, 138.0, 136.0, 139.0, 137.0, 140.0, 139.0, 138.0],
    ),
    SensorDevice(
      id: 'AIC-10-401',
      title: 'O2 Control',
      value: '0.6',
      unit: '%',
      statusColor: Colors.green,
      chartType: SensorChartType.line,
      chartData: [0.5, 0.7, 0.6, 0.8, 0.5, 0.6, 0.7, 0.6],
    ),
    SensorDevice(
      id: 'LIC-10-501',
      title: 'Drum Level',
      value: '-1.2',
      unit: 'in',
      statusColor: Colors.green,
      chartType: SensorChartType.line,
      chartData: [-1.0, -1.3, -1.1, -1.4, -1.2, -1.5, -1.3, -1.2],
    ),
    SensorDevice(
      id: 'LIC-10-501/PID1/OUT',
      title: 'Drum Level Valve',
      value: '49.6',
      unit: '%',
      statusColor: Colors.grey,
      chartType: SensorChartType.line,
      chartData: [48.0, 50.0, 49.0, 51.0, 48.5, 49.6, 50.2, 49.6],
    ),
    SensorDevice(
      id: 'MTR-10-501',
      title: 'Boiler Feed Pump',
      value: '1.0',
      unit: 'RUNNING',
      statusColor: Colors.grey,
      chartType: SensorChartType.horizontal,
      chartData: [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
    ),
    SensorDevice(
      id: 'FIC-10-201',
      title: 'Fuel Flow',
      value: '132.2',
      unit: 'SCF',
      statusColor: Colors.red,
      chartType: SensorChartType.line,
      chartData: [130.0, 135.0, 132.0, 137.0, 134.0, 136.0, 138.0, 132.2],
    ),
    SensorDevice(
      id: 'FIC-10-202',
      title: 'Air Flow',
      value: '67.9',
      unit: '%',
      statusColor: Colors.green,
      chartType: SensorChartType.line,
      chartData: [65.0, 70.0, 68.0, 72.0, 66.0, 69.0, 71.0, 67.9],
    ),
  ];

  List<SensorDevice> get _filteredSensors {
    final searchText = _searchController.text.toLowerCase();
    return searchText.isEmpty
        ? _sensorDevices
        : _sensorDevices.where((sensor) =>
            sensor.title.toLowerCase().contains(searchText)).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
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
          // Sensor List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSensors.length,
              itemBuilder: (context, index) {
                final sensor = _filteredSensors[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SensorDetailPage(
                        sensorId: sensor.id,
                        title: sensor.title,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            // Status Indicator
                            Container(
                              width: 40,
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.circle,
                                color: sensor.statusColor,
                                size: 16,
                              ),
                            ),
                            // Sensor Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sensor.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    sensor.id,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Chart and Value
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Chart
                                  _buildChart(sensor),
                                  const SizedBox(width: 10),
                                  // Value and Unit
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        sensor.value,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        sensor.unit,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(SensorDevice sensor) {
    return SizedBox(
      width: 80,
      height: 40,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: sensor.chartData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 1,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          minX: 0,
          maxX: (sensor.chartData.length - 1).toDouble(),
          minY: sensor.chartData.reduce((a, b) => a < b ? a : b) - 0.5,
          maxY: sensor.chartData.reduce((a, b) => a > b ? a : b) + 0.5,
        ),
      ),
    );
  }
}
