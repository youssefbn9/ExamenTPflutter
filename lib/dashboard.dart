import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/absence_screen.dart';
import 'screens/classe_screen.dart';
import 'screens/departement_screen.dart';
import 'screens/etudiant_screen.dart';
import 'screens/matiere_screen.dart';
import 'screens/moyennes_classe_screen.dart';
import 'screens/moyennes_screen.dart';
import 'screens/note_screen.dart';
import 'screens/top_absences_matieres_screen.dart';
import 'screens/totaux_absences_screen.dart';
import 'screens/user_screen.dart';

// Tableau de bord principal avec tiroir de navigation
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade200,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ISET Nabeul',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'DSI3 - Gestion Scolarite',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _drawerItem(
              context,
              Icons.apartment,
              'Manage departements',
              const DepartementScreen(),
            ),
            _drawerItem(
              context,
              Icons.groups,
              'Manage groups',
              const ClasseScreen(),
            ),
            _drawerItem(
              context,
              Icons.school,
              'Manage students',
              const EtudiantScreen(),
            ),
            _drawerItem(
              context,
              Icons.book,
              'Manage matieres',
              const MatiereScreen(),
            ),
            _drawerItem(
              context,
              Icons.grade,
              'Manage notes',
              const NoteScreen(),
            ),
            _drawerItem(
              context,
              Icons.event_busy,
              'Gestion absences',
              const AbsenceScreen(),
            ),
            _drawerItem(
              context,
              Icons.show_chart,
              'Totaux absences',
              const TotauxAbsencesScreen(),
            ),
            _drawerItem(
              context,
              Icons.calculate,
              'Moyennes',
              const MoyennesScreen(),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text(
                'EXAMEN TP (DSI33)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            _drawerItem(
              context,
              Icons.table_chart,
              'Examen: Moyennes classe',
              const MoyennesClasseScreen(),
            ),
            _drawerItem(
              context,
              Icons.leaderboard,
              'Examen: Top 3 absences',
              const TopAbsencesMatieresScreen(),
            ),
            const Divider(),
            _drawerItem(
              context,
              Icons.person,
              'Manage users',
              const UserScreen(),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Close'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Dashboard',
          style: GoogleFonts.oswald(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
