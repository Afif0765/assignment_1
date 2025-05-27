import 'package:flutter/material.dart';

void main() => runApp(DividendCalculatorApp());

class DividendCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Trust Dividend Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.transparent,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: true,
          fillColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _fundController = TextEditingController();
  final _rateController = TextEditingController();
  final _monthsController = TextEditingController();

  String _result = '';

  void _calculateDividend() {
    if (_formKey.currentState!.validate()) {
      final fund = double.parse(_fundController.text);
      final rate = double.parse(_rateController.text);
      final months = int.parse(_monthsController.text);

      final monthlyDividend = (rate / 100) / 12 * fund;
      final totalDividend = monthlyDividend * months;

      setState(() {
        _result = 'Total Dividend: RM ${totalDividend.toStringAsFixed(2)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Unit Trust Dividend Calculator'),
        backgroundColor: Colors.teal.withOpacity(0.8),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Center(
                child: Column(
                  children: [
                    Image.asset('assets/logo.png', height: 80), // Larger logo
                    SizedBox(height: 20),
                    Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/logo.png', height: 120), // Larger logo
                  ),
                  SizedBox(height: 20),
                  Text('Enter Investment Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _fundController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Invested Fund Amount (RM)'),
                    validator: (value) => value!.isEmpty ? 'Please enter fund amount' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Annual Dividend Rate (%)'),
                    validator: (value) => value!.isEmpty ? 'Please enter rate' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _monthsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Number of Months (1-12)'),
                    validator: (value) {
                      final val = int.tryParse(value!);
                      if (val == null || val < 1 || val > 12) {
                        return 'Enter valid months (1-12)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _calculateDividend,
                      icon: Icon(Icons.calculate),
                      label: Text('Calculate'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_result.isNotEmpty)
                    Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: Colors.teal[50],
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            _result,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[900]),
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
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120), // Larger logo
            SizedBox(height: 20),
            Text('Unit Trust Dividend Calculator', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Author: Afif', style: TextStyle(fontSize: 16)),
            Text('Matric No: [Your Matric Number]', style: TextStyle(fontSize: 16)),
            Text('Course: Netsentric Computing', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('© 2025 Afif. All rights reserved.'),
            SizedBox(height: 20),
            InkWell(
              onTap: () {},
              child: Text(
                'GitHub Repository',
                style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
