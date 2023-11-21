// import 'package:crud_flutter/services/firebase_service.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'CRUD Firebase',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       ),
//       home: const Home(),
//     );
//   }
// }

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('CRUD Firebase'),
//       ),
//       body: FutureBuilder(
//           future: getTasks(),
//           builder: ((context, snapshot) {
//             return ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (context, index) {
//                 return Text(snapshot.data?[index]['name']);
//               },
//             );
//           })),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase CRUD',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase CRUD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _agregarDatos();
            },
            child: const Text('Agregar'),
          ),
          StreamBuilder(
            stream: _firestore.collection('usuarios').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              var usuarios = snapshot.data!.docs;

              List<Widget> usuariosWidgets = [];
              for (var usuario in usuarios) {
                var nombre = usuario['nombre'];
                var usuarioWidget = ListTile(
                  title: Text(nombre),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _eliminarDatos(usuario.id);
                    },
                  ),
                );
                usuariosWidgets.add(usuarioWidget);
              }

              return Column(
                children: usuariosWidgets,
              );
            },
          ),
        ],
      ),
    );
  }

  void _agregarDatos() {
    String nombre = _controller.text;
    _firestore.collection('usuarios').add({'nombre': nombre});
    _controller.clear();
  }

  void _eliminarDatos(String id) {
    _firestore.collection('usuarios').doc(id).delete();
  }
}
