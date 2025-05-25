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

const Color myColor = Color(0xFFffd808); // Primary seed color
const Color pinkSeedColor = Color.fromARGB(255, 252, 156, 198);

// Dark Theme using Material 3
ThemeData get _darkTheme {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: myColor,
    brightness: Brightness.dark,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withOpacity(0.2),
    ),
    // ElevatedButtonTheme will use M3 defaults
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurfaceVariant, // For icons and actions
      titleTextStyle: ThemeData.dark() // Base dark theme for text
          .textTheme
          .titleLarge!
          .copyWith(color: colorScheme.onSurfaceVariant, fontSize: 20),
    ),
  );
}

// Pink Theme using Material 3
ThemeData get _pinkTheme {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: pinkSeedColor,
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    sliderTheme: SliderThemeData(
      activeTrackColor: colorScheme.primary,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withOpacity(0.2),
    ),
    // ElevatedButtonTheme will use M3 defaults
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurfaceVariant, // For icons and actions
      titleTextStyle: ThemeData.light() // Base light theme for text
          .textTheme
          .titleLarge!
          .copyWith(color: colorScheme.onSurfaceVariant, fontSize: 20),
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: colorScheme.onBackground,
          displayColor: colorScheme.onBackground,
        ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    
    // Base Light Theme using Material 3
    final lightThemeColorScheme = ColorScheme.fromSeed(
      seedColor: myColor,
      brightness: Brightness.light,
    );
    final baseLightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightThemeColorScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: lightThemeColorScheme.primary,
        thumbColor: lightThemeColorScheme.primary,
        overlayColor: lightThemeColorScheme.primary.withOpacity(0.2),
      ),
      // ElevatedButtonTheme will use M3 defaults
      appBarTheme: AppBarTheme(
        backgroundColor: lightThemeColorScheme.surfaceContainerHighest,
        foregroundColor: lightThemeColorScheme.onSurfaceVariant, // For icons and actions
        titleTextStyle: ThemeData.light() // Base light theme for text
            .textTheme
            .titleLarge!
            .copyWith(color: lightThemeColorScheme.onSurfaceVariant, fontSize: 20),
      ),
    );

    return MaterialApp(
      title: 'PATODAK APP',
      theme: baseLightTheme,
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
    // Removed: WidgetsBinding.instance.addPostFrameCallback((_) {});
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
