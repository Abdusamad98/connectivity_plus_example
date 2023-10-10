import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_example/connectivity/connectivity_cubit.dart';
import 'package:connectivity_plus_example/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ConnectivityCubit(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state.connectivityResult == ConnectivityResult.none) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NoInternetScreen(voidCallback: () {
                            
                          })));
            }
          },
          child: const Center(
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
