import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/layouts/bottom_sheet.dart';
import 'package:flutter_expense_traker/layouts/home.dart';
import 'package:flutter_expense_traker/layouts/profile.dart';
import 'package:flutter_expense_traker/layouts/statistic.dart';
import 'package:flutter_expense_traker/theme/theme_widget.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //it can found the theme  in theme_widget.dart in theme folder
      theme: getThemeData,
      home: const MainPageWithNav(),
      checkerboardOffscreenLayers: true,
      showSemanticsDebugger: false,
    );
  }
}

class MainPageWithNav extends StatefulWidget {
  const MainPageWithNav({super.key});

  @override
  State<MainPageWithNav> createState() => _MainPageWithNavState();
}

class _MainPageWithNavState extends State<MainPageWithNav> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    StatisticPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MyFloatingActionButton(),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 12,
        shape: CircularNotchedRectangle(),
        height: 65,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                _onItemTapped(0);
              },
              icon: const Icon(Icons.home, size: 28),
            ),
            IconButton(
              onPressed: () {
                _onItemTapped(1);
              },
              icon: const Icon(Icons.stacked_bar_chart_outlined, size: 28),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                _onItemTapped(2);
              },
              icon: const Icon(Icons.person, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({super.key});

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  void onAddTap() {
    showBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: const BottomSheetDialogForAddingTransaction(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onAddTap,
      child: const Icon(Icons.add),
    );
  }
}
