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

  // Función reutilizable para crear botones estilizados con Cards.
  Widget _buildAdminButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 32),
        title: Text(
          label,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        tileColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onPressed,
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
              color: Colors.green,
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
              color: Colors.blue,
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
              color: Colors.orange,
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
