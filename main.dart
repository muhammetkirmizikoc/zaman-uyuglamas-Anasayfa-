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
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
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

  // Renk şeması (Siyah-Mavi)
  final Color backgroundColor = Colors.black87;
  final Color headingColor = Colors.blue;
  final Color accentColor = Colors.blue.shade400;
  final Color textColor = Colors.white;
  final Color separatorColor = Colors.white70;
  final Color cardBackground = Colors.grey.shade900;
  final Color timeBoxColor = Colors.blue.shade800;

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
    int hours = (duration.inHours % 24);
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);
    
    return '${days}g ${hours}s ${minutes}d ${seconds}s';
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı dispose etmek
    super.dispose();
  }

  // Düzenleme/Silme fonksiyonları için diyalog gösterici
  void _showEditDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          title: Text("Sayaç İşlemleri", style: TextStyle(color: headingColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: accentColor),
                title: Text("Düzenle", style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                  // Burada düzenleme sayfasına yönlendirme yapılacak
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Düzenleme sayfası açılıyor...")),
                  );
                },
              ),
              Divider(color: separatorColor),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Sil", style: TextStyle(color: textColor)),
                onTap: () {
                  Navigator.pop(context);
                  // Burada silme onayı sorulacak
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("İptal", style: TextStyle(color: accentColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Silme onayı diyaloğu
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cardBackground,
          title: Text("Sayacı Sil", style: TextStyle(color: Colors.red)),
          content: Text(
            "Bu sayacı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.",
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              child: Text("İptal", style: TextStyle(color: textColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sil", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                // Burada gerçek silme işlemi yapılacak
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sayaç silindi")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sayaç Kartı
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.white24, width: 1),
              ),
              color: cardBackground,
              elevation: 8,
              shadowColor: Colors.black54,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  // Kart Başlığı ve Kategori
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: headingColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event, color: textColor),
                            SizedBox(width: 8),
                            Text(
                              "Toplantı",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Aktif",
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Kart İçeriği
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sayaç Adı ve Düzenle/Sil Çubuğu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Sayaç: Önemli Toplantı",
                                style: TextStyle(
                                  fontSize: 22, 
                                  fontWeight: FontWeight.bold,
                                  color: accentColor
                                )
                              ),
                            ),
                            // Düzenle/Sil Çubuğu
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.more_vert, color: textColor),
                                onPressed: () => _showEditDeleteDialog(context),
                                tooltip: "Düzenle veya Sil",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Tarih ve Saat
                        Row(
                          children: [
                            Icon(Icons.calendar_today, color: accentColor, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "${targetDate.day}/${targetDate.month}/${targetDate.year} - ${targetDate.hour}:${targetDate.minute}",
                              style: TextStyle(
                                fontSize: 16, 
                                color: textColor,
                                fontWeight: FontWeight.w500
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        
                        // Not
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade700),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.note_alt, color: accentColor, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Hazırlık materyalleri tamamlanmalı",
                                  style: TextStyle(fontSize: 16, color: textColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Geri sayım göstergesi
                        _buildCountdownTimer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    if (_remainingTime.isNegative) {
      return _buildTimerExpired();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kalan Süre",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, 
            color: accentColor
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade300.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeBox(_remainingTime.inDays, "GÜN"),
              _buildSeparator(),
              _buildTimeBox((_remainingTime.inHours % 24), "SAAT"),
              _buildSeparator(),
              _buildTimeBox((_remainingTime.inMinutes % 60), "DAKİKA"),
              _buildSeparator(),
              _buildTimeBox((_remainingTime.inSeconds % 60), "SANİYE"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBox(int value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: timeBoxColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Center(
              child: Text(
                value.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Text(
      ":",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: separatorColor,
      ),
    );
  }

  Widget _buildTimerExpired() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade700, width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.alarm_off, size: 40, color: Colors.red),
          SizedBox(height: 10),
          Text(
            "ZAMAN DOLDU!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
