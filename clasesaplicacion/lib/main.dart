import 'package:clasesaplicacion/controllers/servicio_back/modelo/Comentario.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Noticia.dart';
import 'package:clasesaplicacion/controllers/servicio_back/modelo/Persona.dart';
import 'package:clasesaplicacion/views/EditProfile.dart';
import 'package:clasesaplicacion/views/GeolocatorView.dart';
import 'package:clasesaplicacion/views/MapOneNotice.dart';
import 'package:clasesaplicacion/views/addNoticiaView.dart';
import 'package:clasesaplicacion/views/administracionView.dart';
import 'package:clasesaplicacion/views/commentView.dart';
import 'package:clasesaplicacion/views/commentViewAdmin.dart';
import 'package:clasesaplicacion/views/editerView.dart';
import 'package:clasesaplicacion/views/exception/Page404.dart';
import 'package:clasesaplicacion/views/noticiasView.dart';
import 'package:clasesaplicacion/views/perfilView.dart';
import 'package:clasesaplicacion/views/registerView.dart';
import 'package:clasesaplicacion/views/sessionView.dart';
import 'package:clasesaplicacion/views/usersView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Noticia noticia = new Noticia.vacio();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SessionView(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const SessionView(),
        '/register': (context) => const RegisterView(),
        '/noticias': (context) => const NoticiasView(),
        '/noticiasEditor': (context) => const EditerView(),
        '/geolocator': (context) => const GeolocatorView(),
        '/administracion': (context) => const AdministracionView(),
        '/perfil': (context) => const PerfilView(),
        '/users': (context) => const UsersView(),
        '/addNoticia': (context) => const AddNoticiaView()
      },
      onGenerateRoute: (settings) {
        // print(settings.toString());
        if (settings.name == "/comentarios") {
          final Noticia noticia = settings.arguments as Noticia;
          return MaterialPageRoute(
            builder: (context) => CommentView(noticia),
          );
        }
        if (settings.name == "/comentariosAdmin") {
          final Noticia noticia = settings.arguments as Noticia;
          return MaterialPageRoute(
            builder: (context) => CommentViewAdmin(noticia),
          );
        }
        if (settings.name == "/editarPerfil") {
          final Persona persona = settings.arguments as Persona;
          return MaterialPageRoute(
            builder: (context) => EditProfileView(persona),
          );
        }
        if (settings.name == "/mapOneNotice") {
          final List<Comentario> comentarios =
              settings.arguments as List<Comentario>;
          return MaterialPageRoute(
            builder: (context) => MapOneNotice(comentarios),
          );
        }
        return MaterialPageRoute(builder: (context) => const Page404());
      },
    );
  }
}
