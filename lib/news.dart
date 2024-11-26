import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CurrencyMarketApp());
}

class CurrencyMarketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Market',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: CurrencyMarketPage(),
    );
  }
}

class CurrencyMarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'News & Articles'),
                NewsSection(),
                SectionHeader(title: 'Market Trends'),
                MarketTrendsSection(),
                SectionHeader(title: 'Charts & Analysis'),
                ChartsAnalysisSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class NewsSection extends StatefulWidget {
  @override
  _NewsSectionState createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  List<dynamic> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const String apiUrl =
        'https://newsapi.org/v2/everything?q=stock&apiKey=8e40fe394ce3414690c6e8f74247bdad';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _newsList = data['articles'] ?? [];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching news: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _newsList.isEmpty
              ? Center(
                  child: Text(
                    'No news available',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _newsList.length,
                  itemBuilder: (context, index) {
                    final news = _newsList[index];
                    return NewsCard(
                      title: news['title'] ?? 'No Title',
                      summary: news['description'] ?? 'No Summary',
                      imageUrl: news['urlToImage'] ?? '',
                    );
                  },
                ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String summary;
  final String imageUrl;

  NewsCard({required this.title, required this.summary, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Container(
        width: 180,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 50),
                      )
                    : Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.0),
            Text(
              summary,
              style: TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class MarketTrendsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'USD/EUR',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Trend: Upward'),
              trailing: Text(
                '+0.45%',
                style: TextStyle(color: Colors.green),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'GBP/USD',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Trend: Downward'),
              trailing: Text(
                '-0.30%',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartsAnalysisSection extends StatelessWidget {
  final List<double> marketData = [1.1, 1.2, 1.15, 1.18, 1.25, 1.3, 1.28];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Market Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: marketData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: 1.0,
                  maxY: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
