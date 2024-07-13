import 'package:go_router/go_router.dart';
import 'package:keys_saver/presentation/pages/add_key.dart';
import 'package:keys_saver/presentation/pages/home.dart';
import 'package:keys_saver/presentation/pages/key_details.dart';
import 'package:keys_saver/presentation/pages/login.dart';

final statelessRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return const Home();
      }
    ),
    GoRoute(
      path: '/addKey',
      name: 'addKey',
      builder: (context, state) {
        return const AddKey();
      }
    ),
    GoRoute(
      path: '/keyDetails/:id',
      name: 'viewKey',
      builder: (context, state) {
        return KeyDetails(entryId: int.parse(state.pathParameters['id'] ?? '1') );
      }
    )
  ]
);