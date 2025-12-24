import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import '../models/sensor_detail.dart';

class SensorDetailPage extends StatefulWidget {
  final String sensorId;
  final String title;

  const SensorDetailPage({Key? key, required this.sensorId, required this.title}) : super(key: key);

  @override
  State<SensorDetailPage> createState() => _SensorDetailPageState();
}

class _SensorDetailPageState extends State<SensorDetailPage> {
  TimeRange _selectedTimeRange = TimeRange.oneHour;
  late SensorDetail _sensorDetail;

  @override
  void initState() {
    super.initState();
    // Generate 24 hours of minute-by-minute data (1440 points)
    final List<double> pvData = [];
    final List<double> spData = [];
    final List<double> outData = [];
    
    // Base values
    double pvBase = 101.0;
    double spBase = 114.0;
    double outBase = 71.0;
    
    final random = Random();
    
    for (int i = 0; i < 1440; i++) {
      // PV: Fluctuate around 100-105
      double pvVariation = (random.nextDouble() - 0.5) * 2.0; // -1.0 to 1.0
      pvBase += pvVariation;
      // Keep within reasonable range
      if (pvBase < 95.0) pvBase = 95.0;
      if (pvBase > 110.0) pvBase = 110.0;
      pvData.add(double.parse(pvBase.toStringAsFixed(1)));
      
      // SP: More stable, minor adjustments
      double spVariation = (random.nextDouble() - 0.5) * 0.5; // -0.25 to 0.25
      spBase += spVariation;
      if (spBase < 112.0) spBase = 112.0;
      if (spBase > 116.0) spBase = 116.0;
      spData.add(double.parse(spBase.toStringAsFixed(1)));
      
      // OUT: Fluctuate around 70-75, somewhat correlated to PV
      double outVariation = (random.nextDouble() - 0.5) * 1.5 + pvVariation * 0.3;
      outBase += outVariation;
      if (outBase < 65.0) outBase = 65.0;
      if (outBase > 80.0) outBase = 80.0;
      outData.add(double.parse(outBase.toStringAsFixed(1)));
    }
    
    // Mock data for sensor detail
    _sensorDetail = SensorDetail(
      id: widget.sensorId,
      title: widget.title,
      description: 'Header Master Description',
      deltaVSystem: 'BOILER_AREA',
      casAuto: 'CAS/AUTO',
      parameters: [
        SensorParameter(
          name: 'PV',
          value: 101.0,
          color: Colors.blue,
          type: SensorParameterType.pv,
        ),
        SensorParameter(
          name: 'SP',
          value: 114.0,
          color: Colors.green,
          type: SensorParameterType.sp,
        ),
        SensorParameter(
          name: 'OUT',
          value: 71.0,
          color: Colors.black,
          type: SensorParameterType.out,
        ),
      ],
      pvScale: '0 - 200 psig',
      chartData: {
        SensorParameterType.pv: pvData,
        SensorParameterType.sp: spData,
        SensorParameterType.out: outData,
      },
      conditions: ['Abnormal Mode'],
    );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Information
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _sensorDetail.description,
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.sensorId,
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'DeltaV System : ${_sensorDetail.deltaVSystem}',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  // CAS/AUTO label
                  Text(
                    _sensorDetail.casAuto,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Parameters Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PV, SP, OUT Parameters
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var param in _sensorDetail.parameters)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: param.color,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(param.name, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          param.value.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: param.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Tab indicators
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var i = 0; i < _sensorDetail.parameters.length; i++)
                                  Container(
                                    width: 80,
                                    height: 4,
                                    margin: const EdgeInsets.only(right: 16),
                                    color: i == 0 ? Colors.blue : Colors.grey[200],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // PV Scale
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('PV Scale', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          Text(_sensorDetail.pvScale, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),

            // Time Range Selector
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time Range Tabs
                  Row(
                    children: [
                      for (var range in TimeRange.values)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTimeRange = range;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _selectedTimeRange == range ? Colors.grey[300] : Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectedTimeRange == range ? Colors.black : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              range.label,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Settings Icon
                  const Icon(Icons.settings, color: Colors.grey),
                ],
              ),
            ),

            // Chart Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: _buildChart(),
            ),

            // Conditions Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  for (var condition in _sensorDetail.conditions)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(condition, style: const TextStyle(fontSize: 14, color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.save, size: 24),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 24),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final List<LineChartBarData> lines = [];

    // Create line for each parameter type
    for (var entry in _sensorDetail.chartData.entries) {
      final color = entry.key == SensorParameterType.pv 
          ? Colors.blue 
          : entry.key == SensorParameterType.sp 
              ? Colors.green 
              : Colors.black;

      lines.add(LineChartBarData(
        spots: entry.value.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value);
        }).toList(),
        isCurved: true,
        curveSmoothness: 0.2,
        color: color,
        barWidth: 1.5,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ));
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                interval: 120, // Show a label every 120 minutes (2 hours)
                getTitlesWidget: (value, meta) {
                  // Generate time labels for 24 hours
                  final hour = (value.toInt() / 60).floor(); // Convert minutes to hours
                  return Text('$hour:00', style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 10, // Show a label every 10 units
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[300]!)),
          lineBarsData: lines,
          minX: 0,
          maxX: (lines.first.spots.length - 1).toDouble(),
          minY: 60,
          maxY: 120,
          clipData: const FlClipData.all(),
        ),
      ),
    );
  }
}
