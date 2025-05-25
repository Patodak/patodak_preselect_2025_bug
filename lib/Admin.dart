import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_participant.dart';
import 'create_judge.dart';
import 'add_crew.dart'; // Importa la página add_crew.dart

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _passwordController = TextEditingController();

  // Updated _buildAdminButton to use ElevatedButton.icon for Material 3 consistency.
  Widget _buildAdminButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color seedColor, // Changed from 'color' to 'seedColor'
    required VoidCallback onPressed,
  }) {
    // Determine foreground color based on seedColor brightness for better contrast if needed.
    // For simplicity here, using Colors.white as it was the previous intent.
    // A more sophisticated approach might use:
    // final bool isDark = seedColor.computeLuminance() < 0.5;
    // final Color foregroundColor = isDark ? Colors.white : Colors.black;
    final Color foregroundColor = Colors.white;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: seedColor,
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Adjusted padding
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4, // Retaining some elevation
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28), // Adjusted icon size
        label: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: buttonStyle,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Administrador'),
      ),
      // Usamos un Container con un gradiente de fondo para un aspecto más moderno.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // These colors might need adjustment if they clash with M3 theme.
            // For now, leaving them as per instructions.
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            _buildAdminButton(
              context: context,
              icon: Icons.person_add,
              label: 'Agregar Participante',
              seedColor: Colors.green, // Changed to seedColor
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateParticipantPage(),
                  ),
                );
              },
            ),
            _buildAdminButton(
              context: context,
              icon: Icons.person_add_alt_1,
              label: 'Agregar Juez',
              seedColor: Colors.blue, // Changed to seedColor
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateJudgePage(),
                  ),
                );
              },
            ),
            _buildAdminButton(
              context: context,
              icon: Icons.group_add,
              label: 'Agregar Crew',
              seedColor: Colors.orange, // Changed to seedColor
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCrewPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
