import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyConverterUI extends StatefulWidget {
  @override
  _CurrencyConverterUIState createState() => _CurrencyConverterUIState();
}

class _CurrencyConverterUIState extends State<CurrencyConverterUI> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'PKR';
  double _amount = 1000.0;
  double _convertedAmount = 0.0;
  bool _isLoading = false;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of supported currencies
  final List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'flag': 'US'},
    {'code': 'PKR', 'name': 'Pakistani Rupee', 'flag': 'PK'},
    {'code': 'INR', 'name': 'Indian Rupee', 'flag': 'IN'},
    {'code': 'GBP', 'name': 'British Pound', 'flag': 'GB'},
    {'code': 'SAR', 'name': 'Saudi Riyal', 'flag': 'SA'},
    {'code': 'AED', 'name': 'UAE Dirham', 'flag': 'AE'},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'flag': 'SG'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'flag': 'JP'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'flag': 'CN'},
  ];

  // Redirect to login page if not logged in
  void checkUserStatus() async {
    User? user = _auth.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(
          context, '/login'); // Replace '/login' with your login route
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }

  Future<void> convertCurrency() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        'https://v6.exchangerate-api.com/v6/87ff51e0b30aae2ad80fa5c4/pair/$_fromCurrency/$_toCurrency';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = data['conversion_rate'];
        setState(() {
          _convertedAmount = _amount * rate;
        });

        // Save the conversion record to Firestore
        saveConversionRecord(
            _fromCurrency, _toCurrency, _amount, _convertedAmount);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> saveConversionRecord(String fromCurrency, String toCurrency,
      double amount, double convertedAmount) async {
    User? user = _auth.currentUser;
    try {
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('conversions')
            .add({
          'fromCurrency': fromCurrency,
          'toCurrency': toCurrency,
          'amount': amount,
          'convertedAmount': convertedAmount,
          'timestamp': FieldValue.serverTimestamp(),
        });
      print('a');
      }
      else{
        print('no user');
      }
    } catch (e) {
      print('error $e ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Currency Converter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Check live rates, set rate alerts, receive notifications and more.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _fromCurrency,
                          items: currencies.map((currency) {
                            return DropdownMenuItem(
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://flagcdn.com/w20/${currency['flag']!.toLowerCase()}.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(currency['code']!),
                                ],
                              ),
                              value: currency['code'],
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _fromCurrency = value!;
                            });
                          },
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: _amount.toString(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _amount = double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Icon(Icons.swap_vert, color: Colors.blue, size: 32),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _toCurrency,
                          items: currencies.map((currency) {
                            return DropdownMenuItem(
                              child: Row(
                                children: [
                                  Image.network(
                                    'https://flagcdn.com/w20/${currency['flag']!.toLowerCase()}.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(currency['code']!),
                                ],
                              ),
                              value: currency['code'],
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _toCurrency = value!;
                            });
                          },
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _isLoading
                                  ? "Converting..."
                                  : _convertedAmount.toStringAsFixed(2),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: convertCurrency,
              child: Text("Convert Currency"),
            ),
          ],
        ),
      ),
    );
  }
}
