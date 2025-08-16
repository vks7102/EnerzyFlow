import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/articles_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EnerzyflowApp());
}

class EnerzyflowApp extends StatelessWidget {
  const EnerzyflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticlesProvider()..bootstrap()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enerzyflow News',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontWeight: FontWeight.w700),
            titleMedium: TextStyle(fontWeight: FontWeight.w600),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),

        home: const HomeScreen(),
      ),
    );
  }
}
