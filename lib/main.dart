import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expense_traker/data_base/category.dart';
import 'package:flutter_expense_traker/data_base/db.dart';
import 'package:flutter_expense_traker/data_base/transactions.dart';
import 'package:flutter_expense_traker/layouts/bottom_sheet.dart';
import 'package:flutter_expense_traker/layouts/home.dart';
import 'package:flutter_expense_traker/layouts/login_page.dart';
import 'package:flutter_expense_traker/layouts/profile.dart';
import 'package:flutter_expense_traker/layouts/sign_up_page.dart';
import 'package:flutter_expense_traker/layouts/statistic.dart';
import 'package:flutter_expense_traker/provider/category_provider.dart';
import 'package:flutter_expense_traker/provider/trrasaction_provider.dart';
import 'package:flutter_expense_traker/provider/user_provider.dart';
import 'package:flutter_expense_traker/theme/theme_extension.dart';
import 'package:flutter_expense_traker/theme/theme_widget.dart';
import 'package:flutter_expense_traker/widgets/bottom_appBar_icon.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async operations before runApp

  // Initialize Hive
  await DbService().initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider(),),
        FutureProvider<List<Categories>>(
          create: (context) => DbService().getAllCategories(),
          initialData: [], // Provide an initial empty list
        ),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        //it can found the theme  in theme_widget.dart in theme folder
        theme: AppTheme.lightTheme,
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        home: const AuthWrapper(),
        checkerboardOffscreenLayers: true,
        showSemanticsDebugger: false,
      ),
    );
  }
}

// --- AuthWrapper: Decides which screen to show ---
enum AuthMode { login, signup } // Define authentication modes

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // This will store the initial page index to show in HomeScreen after authentication.
  int _initialPageIndexAfterAuth = 0;
  AuthMode _authMode = AuthMode.login; // Initial mode is login

  @override
  void initState() {
    super.initState();
    // Simulate checking authentication status on app start.
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    // Check initial login status using the UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      // If the user is already logged in (e.g., from a previous session)
      if (userProvider.isLoggedIn) {
        _initialPageIndexAfterAuth = 0; // Default to home if already logged in
      }
      // If not logged in, LoginScreen will be shown by default via _authMode
    });
  }

  // Callback for successful authentication (login or signup)
  void _onAuthSuccess(int initialPage) {
    // This will trigger AuthWrapper's build method to re-evaluate
    // and show HomeScreen because UserProvider's isLoggedIn will be true.
    setState(() {
      _initialPageIndexAfterAuth = initialPage;
    });
  }

  // Callback to switch between login and signup modes
  void _switchAuthMode(AuthMode mode) {
    setState(() {
      _authMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the UserProvider for changes in login status
    final userProvider = Provider.of<UserProvider>(context);
    
   

    // Conditionally render based on authentication status from UserProvider
    if (userProvider.isLoggedIn) {
      return MainPageWithNav(initialPageIndex: _initialPageIndexAfterAuth);
    } else {
      // Show either LoginScreen or SignUpScreen based on _authMode
      if (_authMode == AuthMode.login) {
        return AnimatedLoginPage(
          onAuthSuccess: _onAuthSuccess,
          onSwitchToSignUp: () => _switchAuthMode(AuthMode.signup),
        );
      } else {
        return SignUpPage(
          onAuthSuccess: _onAuthSuccess,
          onSwitchToLogin: () => _switchAuthMode(AuthMode.login),
        );
      }
    }
  }
}

class MainPageWithNav extends StatefulWidget {
  const MainPageWithNav({super.key, required this.initialPageIndex});
  final int initialPageIndex;

  @override
  State<MainPageWithNav> createState() => _MainPageWithNavState();
}

class _MainPageWithNavState extends State<MainPageWithNav> {
  GlobalKey<SliverAnimatedListState > listKey = GlobalKey<SliverAnimatedListState>();
  
  
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[];

  @override
  void didChangeDependencies() {
    _widgetOptions = <Widget>[
      HomePage(animatedListKey: listKey,),
      StatisticPage(),
      ProfilePage(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).colorTheme.iconColor;
    var selectedIconColor = Theme.of(context).colorScheme.primary;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: MyFloatingActionButton(
        
        ),
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: Colors.transparent,
          color: Theme.of(context).colorTheme.lightGreyColor,
          notchMargin: 12,
          elevation: 12,
          shape: CircularNotchedRectangle(),
          height: 65,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  _onItemTapped(0);
                },
                icon: BottomAppbarIcon(
                  icon: Icons.home,
                  color: iconColor,
                  selectedColor: selectedIconColor,
                  isfocused: _selectedIndex == 0,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: () {
                  _onItemTapped(1);
                },
                icon: BottomAppbarIcon(
                  icon: Icons.stacked_bar_chart_outlined,
                  color: iconColor,
                  selectedColor: selectedIconColor,
                  isfocused: _selectedIndex == 1,
                  size: 28,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  _onItemTapped(2);
                },
                icon: BottomAppbarIcon(
                  icon: Icons.person,
                  color: iconColor,
                  selectedColor: selectedIconColor,
                  isfocused: _selectedIndex == 2,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({super.key,});
  


  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  void onAddTap() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      elevation: 8,
      isScrollControlled: true,
      isDismissible: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.decelerate,
        duration: Duration(milliseconds: 300),
        reverseCurve: Curves.bounceOut,
        reverseDuration: Duration(milliseconds: 200),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: BottomSheetDialogForAddingTransaction(
              
            ),
          ),
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onAddTap,
      child: const Icon(Icons.add),
    );
  }
}


// todays Tasks

/** first yar Color Scheme set kr 
 * 
 * bottom appbar icons 
 * profile page set krna h
 * card ko adjust krna h
 * end connect with database
 * create provider for catergory , transaction ,
 * 5
 */