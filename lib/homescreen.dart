// ignore_for_file: unused_field, prefer_is_empty, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:home_security/detailsscreen.dart';
import 'package:home_security/historyscreen.dart';
import 'package:home_security/profilescreen.dart';
import 'api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAlarmEnabled = false;
  int _normalStatus = 1;
  var sensorStatuses = [];

  @override
  void initState() {
    super.initState();
    _fetchAlarmStatus();
    _fetchSensorStatuses();
  }

  Future<void> _fetchAlarmStatus() async {
    try {
      final alarmStatus = await ApiService.getAlarmStatus();
      setState(() {
        _isAlarmEnabled = alarmStatus['status'] == 1;
        _normalStatus = alarmStatus['normal_status'];
      });
    } catch (e) {
      print('Failed to fetch alarm status: $e');
    }
  }

  Future<void> _fetchSensorStatuses() async {
    try {
      final alarmStatus = await ApiService.fetchSensorStatuses();
      setState(() {
        sensorStatuses = alarmStatus;
      });
    } catch (e) {
      print('Failed to fetch alarm status: $e');
    }
  }

  Future<void> _toggleAlarm() async {
    try {
      final apiService = ApiService();
      await apiService.toggleAlarm();
      await _fetchAlarmStatus();
    } catch (e) {
      print('Failed to toggle alarm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fetchAlarmStatus();
              _fetchSensorStatuses();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                DoorCard(
                    title:
                        'Door 1 : ${sensorStatuses.length == 0 ? 'No attempt' : sensorStatuses[0]['status'] == 0 ? 'No attempt' : 'Attempt'}',
                    icon: Icons.door_front_door,
                    onTap: () => _navigateToDetailScreen(context, 1)),
                DoorCard(
                    title:
                        'Door 2 : ${sensorStatuses.length == 0 ? 'No attempt' : sensorStatuses[1]['status'] == 0 ? 'No attempt' : 'Attempt'}',
                    icon: Icons.door_front_door,
                    onTap: () => _navigateToDetailScreen(context, 2)),
                DoorCard(
                    title:
                        'Door 3 : ${sensorStatuses.length == 0 ? 'No attempt' : sensorStatuses[2]['status'] == 0 ? 'No attempt' : 'Attempt'}',
                    icon: Icons.door_front_door,
                    onTap: () => _navigateToDetailScreen(context, 3)),
                DoorCard(
                    title:
                        'Door 4 : ${sensorStatuses.length == 0 ? 'No attempt' : sensorStatuses[3]['status'] == 0 ? 'No attempt' : 'Attempt'}',
                    icon: Icons.door_front_door,
                    onTap: () => _navigateToDetailScreen(context, 4)),
                DoorCard(
                    title: 'History',
                    icon: Icons.history,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()))),
                DoorCard(
                  title: 'Profile',
                  icon: Icons.person,
                  onTap: () {},
                  // onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ProfileScreen()))
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _isAlarmEnabled ? Colors.red : Colors.green,
                ),
                onPressed: _toggleAlarm,
                child: Text(
                  _isAlarmEnabled ? 'Disable Alarm' : 'Enable Alarm',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Alarm Is: ${_isAlarmEnabled ? 'Enabled' : 'Disabled'}',
              style: TextStyle(
                  fontSize: 20,
                  color: _isAlarmEnabled ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailScreen(BuildContext context, int doorNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(doorNumber: doorNumber),
      ),
    );
  }
}

class DoorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DoorCard(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDisableAlarmDialog(context),
      child: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48.0),
              SizedBox(height: 16.0),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  void _showDisableAlarmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disable Alarm'),
        content: Text('Do you want to disable the alarm?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement disable alarm logic here
              Navigator.pop(context);
            },
            child: Text('Disable'),
          ),
        ],
      ),
    );
  }
}
