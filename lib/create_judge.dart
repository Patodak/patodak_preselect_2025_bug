import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateJudgePage extends StatefulWidget {
  @override
  _CreateJudgePageState createState() => _CreateJudgePageState();
}

class _CreateJudgePageState extends State<CreateJudgePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Opciones de categoría para jueces
  final List<String> categoryOptions = ['Breaking', 'All Style'];
  final String defaultImageUrl = 'https://i.imgur.com/dZnDMZX.png';

  // Stream para escuchar los cambios en la colección de jueces
  Stream<QuerySnapshot> get _judgesStream {
    return _firestore.collection('jueces').snapshots();
  }

  // Función para agregar un juez a Firestore
  Future<void> addJudge(String docId, String name, String email,
      String photoUrl, List<String> categories) async {
    print('Intentando agregar juez: $name, $email, $photoUrl, $categories');
    // Asignar la URL predeterminada si el campo de foto está vacío
    String selectedPhotoUrl = photoUrl.isNotEmpty ? photoUrl : defaultImageUrl;
    CollectionReference juecesRef = _firestore.collection('jueces');

    try {
      DocumentReference newJudgeRef = await juecesRef.add({
        'nombre_juez': name.toUpperCase(),
        'email': email.toLowerCase(),
        'foto_url': selectedPhotoUrl,
        'categoria': categories,
        'role': 'jurado',
      });
      print('Juez agregado exitosamente con ID: ${newJudgeRef.id}');
    } catch (error) {
      print('Error al agregar juez: $error');
    }
  }

  // Función para editar un juez existente
  Future<void> editJudge(String docId, String newName, String newEmail,
      String newPhotoUrl, List<String> categories) async {
    await _firestore.collection('jueces').doc(docId).update({
      'nombre_juez': newName.toUpperCase(),
      'email': newEmail.toLowerCase(),
      'foto_url': newPhotoUrl.isEmpty ? defaultImageUrl : newPhotoUrl,
      'categoria': categories,
    });
    print('Juez actualizado');
  }

  // Función para eliminar un juez
  Future<void> removeJudge(String docId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar jurado',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('¿Estás seguro de eliminar este jurado?'),
        actions: [
          TextButton(
            onPressed: () async {
              await _firestore.collection('jueces').doc(docId).delete();
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // Diálogo para crear o editar un juez con un diseño moderno
  void _showEditDialog({
    required String title,
    required Function(String docId, String newName, String newEmail,
            String newPhotoUrl, List<String> newCategories)
        onConfirm,
    String docId = '',
    String originalName = '',
    String originalEmail = '',
    String originalPhotoUrl = '',
    List<String> originalCategories = const [],
  }) {
    _nameController.text = originalName;
    _emailController.text = originalEmail;
    _photoUrlController.text = originalPhotoUrl;

    // Estado local para las categorías seleccionadas
    List<bool> tempSelected = List.generate(
      categoryOptions.length,
      (index) => originalCategories.contains(categoryOptions[index]),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo para nombre
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del juez',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Campo para correo electrónico
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Campo para URL de la foto
                    TextField(
                      controller: _photoUrlController,
                      decoration: InputDecoration(
                        labelText: 'URL de la foto',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Categorías',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: List.generate(categoryOptions.length, (i) {
                        return CheckboxListTile(
                          title: Text(categoryOptions[i]),
                          value: tempSelected[i],
                          onChanged: (value) {
                            setState(() {
                              tempSelected[i] = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    List<String> selectedCategories = [];
                    for (int i = 0; i < tempSelected.length; i++) {
                      if (tempSelected[i]) {
                        selectedCategories.add(categoryOptions[i]);
                      }
                    }
                    onConfirm(
                      docId,
                      _nameController.text,
                      _emailController.text,
                      _photoUrlController.text,
                      selectedCategories,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Construye la tarjeta para cada juez
  Widget _buildJudgeCard(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String photoUrl = data['foto_url'] ?? defaultImageUrl;
    String name = data['nombre_juez'] ?? 'Sin nombre';
    List<String> categories =
        data['categoria'] != null ? List<String>.from(data['categoria']) : [];

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(photoUrl),
          onBackgroundImageError: (_, __) {
            // En caso de error, se puede mostrar la imagen por defecto
          },
        ),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(categories.join(', ')),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => removeJudge(doc.id),
        ),
        onTap: () => _showEditDialog(
          title: 'Editar juez',
          onConfirm: editJudge,
          docId: doc.id,
          originalName: data['nombre_juez'] ?? '',
          originalEmail: data['email'] ?? '',
          originalPhotoUrl: data['foto_url'] ?? '',
          originalCategories: categories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar jueces'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showEditDialog(
              title: 'Crear nuevo juez',
              onConfirm: addJudge,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // Fondo sutil con gradiente para un toque moderno
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _judgesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            final docs = snapshot.data!.docs;
            if (docs.isEmpty)
              return Center(child: Text('No hay jueces registrados.'));
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) => _buildJudgeCard(docs[index]),
            );
          },
        ),
      ),
    );
  }
}
