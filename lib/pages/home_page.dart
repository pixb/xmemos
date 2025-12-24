import 'package:flutter/material.dart';
import '../models/home_item.dart';
import 'preferences_page.dart';
import 'sensor_list_page.dart';

enum TabType {
  all,
  watch,
  alarm,
  flag,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabType _selectedTab = TabType.all;
  final TextEditingController _searchController = TextEditingController();

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

  // Mock data
  final List<HomeItem> _homeItems = [
    // Watch type items
    HomeItem(
      id: '1',
      title: 'Boiler',
      subtitle: '11 items',
      icon: Icons.fireplace_outlined,
      type: HomeItemType.watch,
      indicators: [
        StatusIndicator(icon: Icons.notifications, count: 2, type: StatusIndicatorType.notification),
        StatusIndicator(icon: Icons.flag, count: 3, color: Colors.green, type: StatusIndicatorType.flag),
        StatusIndicator(icon: Icons.error, count: 2, color: Colors.red, type: StatusIndicatorType.error),
      ],
    ),
    HomeItem(
      id: '2',
      title: 'Bioreactor',
      subtitle: '14 items',
      icon: Icons.science_outlined,
      type: HomeItemType.watch,
      indicators: [
        StatusIndicator(icon: Icons.notifications, count: 2, color: Colors.orange, type: StatusIndicatorType.notification),
        StatusIndicator(icon: Icons.flag, count: 3, color: Colors.green, type: StatusIndicatorType.flag),
        StatusIndicator(icon: Icons.error, count: 2, color: Colors.red, type: StatusIndicatorType.error),
      ],
    ),
    // Alarm type items
    HomeItem(
      id: '3',
      title: 'Boiler Alarms',
      icon: Icons.notifications,
      iconColor: Colors.red,
      type: HomeItemType.alarm,
      indicators: [
        StatusIndicator(icon: Icons.notifications, count: 2, color: Colors.red, type: StatusIndicatorType.notification),
        StatusIndicator(icon: Icons.volume_off, count: 1, color: Colors.grey, type: StatusIndicatorType.volumeOff),
      ],
      additionalText: 'FIC350112',
    ),
    HomeItem(
      id: '4',
      title: 'GMP Alarms',
      icon: Icons.notifications,
      iconColor: Colors.pink,
      type: HomeItemType.alarm,
      indicators: [
        StatusIndicator(icon: Icons.notifications, count: 1, color: Colors.pink, type: StatusIndicatorType.notification),
      ],
      additionalText: 'AI14532',
    ),
    HomeItem(
      id: '5',
      title: 'Utilities Alarms',
      icon: Icons.notifications,
      iconColor: Colors.grey,
      type: HomeItemType.alarm,
    ),
    HomeItem(
      id: '6',
      title: 'Safety Alarms',
      icon: Icons.notifications,
      iconColor: Colors.grey,
      type: HomeItemType.alarm,
    ),
    HomeItem(
      id: '7',
      title: 'DeltaV Hardware Alerts',
      icon: Icons.notifications,
      iconColor: Colors.pink,
      type: HomeItemType.alarm,
      indicators: [
        StatusIndicator(icon: Icons.notifications, count: 1, color: Colors.pink, type: StatusIndicatorType.notification),
      ],
      additionalText: 'CTRL12-45',
    ),
    HomeItem(
      id: '8',
      title: 'Device Alerts',
      icon: Icons.notifications,
      iconColor: Colors.purple,
      type: HomeItemType.alarm,
      indicators: [
        StatusIndicator(icon: Icons.notifications, count: 1, color: Colors.purple, type: StatusIndicatorType.notification),
      ],
      additionalText: 'TT-23154',
    ),
  ];

  List<HomeItem> get _filteredItems {
    // Get search text and make it case-insensitive
    final searchText = _searchController.text.toLowerCase();
    
    // First filter by tab type
    List<HomeItem> filteredByTab;
    switch (_selectedTab) {
      case TabType.watch:
        filteredByTab = _homeItems.where((item) => item.type == HomeItemType.watch).toList();
        break;
      case TabType.alarm:
        filteredByTab = _homeItems.where((item) => item.type == HomeItemType.alarm).toList();
        break;
      case TabType.flag:
        filteredByTab = _homeItems.where((item) => 
          item.indicators.any((indicator) => indicator.type == StatusIndicatorType.flag)
        ).toList();
        break;
      default:
        filteredByTab = _homeItems;
        break;
    }
    
    // Then filter by search text
    if (searchText.isNotEmpty) {
      filteredByTab = filteredByTab.where((item) => 
        item.title.toLowerCase().contains(searchText)
      ).toList();
    }
    
    return filteredByTab;
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesPage()),
              );
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
          // Tab Navigation
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // All Lists Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = TabType.all;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == TabType.all ? Colors.grey : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                          left: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'All Lists',
                          style: TextStyle(
                            color: _selectedTab == TabType.all ? Colors.white : Colors.grey,
                            fontWeight: _selectedTab == TabType.all ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Watch Lists Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = TabType.watch;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == TabType.watch ? Colors.grey : Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Watch Lists',
                          style: TextStyle(
                            color: _selectedTab == TabType.watch ? Colors.white : Colors.grey,
                            fontWeight: _selectedTab == TabType.watch ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Alarm Lists Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = TabType.alarm;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == TabType.alarm ? Colors.grey : Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Alarm Lists',
                          style: TextStyle(
                            color: _selectedTab == TabType.alarm ? Colors.white : Colors.grey,
                            fontWeight: _selectedTab == TabType.alarm ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Flag Tab
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = TabType.flag;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedTab == TabType.flag ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Icon(
                      Icons.flag,
                      color: _selectedTab == TabType.flag ? Colors.white : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List View
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1.0)),
                  ),
                  child: ListTile(
                    leading: Icon(item.icon, color: item.iconColor),
                    title: Text(item.title),
                    subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...item.indicators.map((indicator) => _buildStatusIndicator(
                              indicator.icon,
                              indicator.count,
                              color: indicator.color,
                            )),
                        if (item.additionalText != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(item.additionalText!),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SensorListPage(title: item.title),
                        ),
                      );
                    },
                  ),
                );
              },
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