import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipemovie/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://zgkjyvdakcikbyqrnbjt.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpna2p5dmRha2Npa2J5cXJuYmp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3NzAzNjEsImV4cCI6MjA3MzM0NjM2MX0.2o4QOo7QloklH4tVKOEmOcTRDYTCOrnBmUAngDn9LOc",
  );

  runApp(const MyApp());
}
