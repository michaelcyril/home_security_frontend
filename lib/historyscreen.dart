import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  String formatDateTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    // Format the date as needed, e.g., 'yyyy-MM-dd HH:mm:ss'
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intruder History'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService.fetchIntruderAttempts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load history'));
          } else {
            final attempts = snapshot.data!;
            return ListView.builder(
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                final attempt = attempts[index];
                return myCard('Door: ${attempt['pir']}', attempt['status'],
                    formatDateTime(attempt['created_at']));
              },
            );
          }
        },
      ),
    );
  }

  Column myCard(title, subtitle, createdAt) {
    return Column(
      children: [
        Card(
          color: Colors.white,
          shadowColor: Colors.black12,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.add)),
            title: Text(title),
            subtitle:
                Text(subtitle == 1 ? "Attempt  at ${createdAt}" : "No attempt"),
            trailing: Icon(
              Icons.warning,
              color: Colors.red,
            ),
          ),
        ),
        const Divider(
          //*iki eleman arasini bolen cizgi
          color: Colors.red,
          thickness: 1,
          height: 10,
          indent: 20, //*soldan bosluk
          endIndent: 20, //*sagdan bosluk
        )
      ],
    );
  }
}

class HistoryDetailScreen extends StatelessWidget {
  final dynamic attempt;

  const HistoryDetailScreen({required this.attempt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Detail'),
      ),
      body: Center(
        child: Text(
          'PIR: ${attempt['pir']}\nStatus: ${attempt['status']}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
