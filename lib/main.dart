import 'package:flutter/material.dart';
import 'SelectJudge.dart';
import 'Puntajes.dart';
import 'Admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('Firebase inicializado correctamente.');
  } catch (e) {
    print('Error al inicializar Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(),
        ),
        ChangeNotifierProvider<AppState>(
          create: (context) => AppState(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

final Color myColor = Color(0xFFffd808);

ThemeData get _darkTheme => ThemeData.dark().copyWith(
      primaryColor: myColor,
      sliderTheme: ThemeData.dark().sliderTheme.copyWith(
            activeTrackColor: myColor,
            thumbColor: myColor,
            overlayColor: myColor.withOpacity(0.2),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: myColor,
        titleTextStyle: ThemeData.dark()
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.black, fontSize: 15),
      ),
    );

ThemeData get _pinkTheme => ThemeData.light().copyWith(
      primaryColor: Color.fromARGB(255, 252, 156, 198),
      scaffoldBackgroundColor: Colors.pink.shade100,
      sliderTheme: ThemeData.light().sliderTheme.copyWith(
            activeTrackColor: Color.fromARGB(255, 252, 156, 198),
            thumbColor: Color.fromARGB(255, 252, 156, 198),
            overlayColor: Color.fromARGB(255, 252, 156, 198).withOpacity(0.2),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255, 252, 156, 198),
        titleTextStyle: ThemeData.light()
            .textTheme
            .headlineSmall!
            .copyWith(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 15),
      ),
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: Color.fromARGB(255, 0, 0, 0),
            displayColor: Colors.white,
          ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'PATODAK APP',
      theme: ThemeData(
        primaryColor: myColor,
        sliderTheme: SliderThemeData(
          activeTrackColor: myColor,
          thumbColor: myColor,
          overlayColor: myColor.withOpacity(0.2),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: myColor,
          titleTextStyle: ThemeData.light()
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.black, fontSize: 15),
        ),
      ),
      darkTheme: _darkTheme,
      themeMode: themeNotifier.themeMode,
      home: MainMenuPage(),
      initialRoute: '/',
      builder: (context, child) {
        return themeNotifier.customThemeMode == CustomThemeMode.pink
            ? Theme(data: _pinkTheme, child: child!)
            : child!;
      },
    );
  }
}

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Nombre del evento : Box 8', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              final themeNotifier =
                  Provider.of<ThemeNotifier>(context, listen: false);
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                ),
                SizedBox(height: 8.0),
                Text('PatoDak Preselect',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                SizedBox(height: 30),

                // Puntajes y CompleteProfile siempre están disponibles.º
                _buildMenuButton(
                  context,
                  title: 'Puntaje Filtros',
                  onPressed: () {
                    _navigateToPage(context, Puntajes());
                  },
                ),

                _buildMenuButton(
                  context,
                  title: 'Administración',
                  onPressed: () {
                    _navigateToPage(context,
                        AdminPage()); // Asegúrate de que la clase Admin esté definida
                  },
                ),

                _buildMenuButton(
                  context,
                  title: 'Seleccionar Juez',
                  onPressed: () {
                    _navigateToPage(context,
                        SelectJudgePage()); // Asegúrate de que la clase SelectJudge esté definida
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('By PatoDak',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodySmall!.color)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        child: Text(title),
        onPressed: onPressed,
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget targetPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => targetPage,
      ),
    );
  }
}
