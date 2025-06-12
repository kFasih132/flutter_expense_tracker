import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_traker/provider/user_provider.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:flutter_expense_traker/widgets/round_container.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedSegment = 2;
  void onValueChanged(int? value) {
    setState(() {
      _selectedSegment = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userPrrovider = Provider.of<UserProvider>(context, listen: false);
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              const SizedBox(height: 80),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8YW5pbWV8ZW58MHx8MHx8fDA%3D',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userPrrovider.currentUser.name ?? 'Unknown',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(userPrrovider.currentUser.email ?? 'Unknown'),
              const SizedBox(height: 60),
              RoundContainer(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                radius: 16,
                color: Theme.of(context).colorTheme.lightGreyColor,
                border: BoxBorder.all(
                  color: Theme.of(context).colorTheme.darkGreyColor,
                  width: 1,
                ),

                width: double.infinity,
                padding: 4,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onTap: () {
                        // Navigate to settings page
                      },
                    ),
                    Divider(endIndent: 16, indent: 16, thickness: 1.5),
                    const SizedBox(height: 12),
                    CupertinoSlidingSegmentedControl<int>(
                      backgroundColor: Colors.transparent,
                      children: segmentedControlChildren,
                      groupValue: _selectedSegment,
                      onValueChanged: onValueChanged,
                    ),
                    const SizedBox(height: 12),
                    Divider(endIndent: 16, indent: 16, thickness: 1.5),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: Text(
                        'LogOut',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onTap: () {
                        // Navigate to settings page
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final Map<int, Widget> segmentedControlChildren = {
  0: const Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
    child: Text('Dark', style: TextStyle(color: CupertinoColors.black)),
  ),
  1: const Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
    child: Text('Light', style: TextStyle(color: CupertinoColors.black)),
  ),
  2: const Padding(
    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
    child: Text('System', style: TextStyle(color: CupertinoColors.black)),
  ),
};
