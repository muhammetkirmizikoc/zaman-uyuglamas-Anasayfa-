import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sayaç Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Geri sayımın bitiş tarihi
  final DateTime targetDate = DateTime(2025, 5, 27, 20, 26, 0);
  
  // Geri sayımı başlatmak için Timer
  late Timer _timer;
  late Duration _remainingTime;

  final Color arkaplanRengi = Color.fromRGBO(32, 178, 170, 1.0); // Belirtilen renk

  @override
  void initState() {
    super.initState();
    _remainingTime = targetDate.difference(DateTime.now());
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = targetDate.difference(DateTime.now());
        if (_remainingTime.isNegative) {
          _timer.cancel();  // Zaman bitince geri sayımı durdur
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);

    String daysText = days > 0 ? '$days Gün ' : '';
    String hoursText = '$hours Saat';
    String minutesText = '$minutes Dakika';
    String secondsText = '$seconds Saniye';

    return '$daysText$hoursText $minutesText $secondsText';
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı dispose etmek
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sayaç Kartı
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: arkaplanRengi, // Kart arka planını seçilen renkle yapıyoruz
              elevation: 8,
              shadowColor: Colors.tealAccent,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori Başlığı: Üst köşeye yerleştiriliyor
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Kategori: Toplantı",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Sayaç Adı
                    Text("Sayaç Eklendi: mdıofpgk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 10),
                    // Tarih ve Saat
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.white, size: 18),
                        SizedBox(width: 5),
                        Text("Tarih ve Saat: ${targetDate.toString()}", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Not kısmı
                    Row(
                      children: [
                        Icon(Icons.note, color: Colors.white, size: 18),
                        SizedBox(width: 5),
                        Expanded(child: Text("Not: mdsogpskdpl", style: TextStyle(fontSize: 16, color: Colors.white))),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Geri sayım kutusu
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _remainingTime.isNegative ? 'Zaman Doldu!' : formatDuration(_remainingTime),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
