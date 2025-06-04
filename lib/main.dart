import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

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

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
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
        _result =
        'Monthly Dividend: RM ${monthlyDividend.toStringAsFixed(2)}\n'
            'Total Dividend for $months month(s): RM ${totalDividend.toStringAsFixed(2)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Unit Trust Dividend Calculator'),
        backgroundColor: Colors.white54.withAlpha(204),
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
                    Image.asset('assets/logo.png', height: 80),
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
      body: BackgroundContainer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/logo.png', height: 100),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter Investment Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 15),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 0),
                  if (_result.isNotEmpty)
                    Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        color: Colors.teal[50],
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            _result,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[900]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse('https://github.com/Afif0765/unit-trust-app.git');
    if (await launcher.canLaunchUrl(url)) {
      await launcher.launchUrl(url, mode: launcher.LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                  child: Image.asset('assets/logo.png', height: 120),
                ),
                SizedBox(height: 20),
                Text(
                  'Unit Trust Dividend Calculator',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                Text('Author: Afif', style: TextStyle(fontSize: 18, color: Colors.black)),
                Text('Matric No: 2023367671', style: TextStyle(fontSize: 18, color: Colors.black)),
                Text('Course: Netsentric Computing', style: TextStyle(fontSize: 18, color: Colors.black)),
                SizedBox(height: 20),
                Text('© 2025 Afif. All rights reserved.', style: TextStyle(color: Colors.black)),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: _launchGitHub,
                  icon: Icon(Icons.open_in_new),
                  label: Text('GitHub Repository'),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
