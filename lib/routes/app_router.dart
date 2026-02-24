import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/notes/screens/upload_notes_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/screens/sign_in_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/settings/screens/manage_account_screen.dart';
import '../features/settings/screens/language_screen.dart';
import '../features/settings/screens/privacy_screen.dart';
import '../features/settings/screens/terms_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.fullPath == '/signin';

    // If user NOT logged in and trying to access dashboard
    if (user == null && state.fullPath == '/dashboard') {
      return '/signin';
    }

    // If user logged in and tries to go to signin page
    if (user != null && isLoggingIn) {
      return '/dashboard';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/upload-notes',
      builder: (context, state) => const UploadNotesScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/manage-account',
      builder: (context, state) => const ManageAccountScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsScreen(),
    ),


  ],
);
