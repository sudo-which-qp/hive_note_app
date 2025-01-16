import 'package:get_it/get_it.dart';
import 'package:note_app/data/network/network_services_api.dart';
import 'package:note_app/data/repositories/auth_repository.dart';
import 'package:note_app/data/repositories/cloud_note_repository.dart';
import 'package:note_app/helpers/hive_manager.dart';
import 'package:note_app/state/cubits/auth_cubit/auth_cubit.dart';
import 'package:note_app/state/cubits/cloud_note_cubit/cloud_note_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  getIt.registerLazySingleton<NetworkServicesApi>(() => NetworkServicesApi());
  getIt.registerLazySingleton<HiveManager>(() => HiveManager());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepository(
      api: getIt<NetworkServicesApi>(),
      hiveManager: getIt<HiveManager>(),
    ),
  );

  getIt.registerLazySingleton<CloudNoteRepository>(
        () => CloudNoteRepository(
      api: getIt<NetworkServicesApi>(),
      hiveManager: getIt<HiveManager>(),
    ),
  );

  // Cubits
  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<CloudNoteCubit>(
        () => CloudNoteCubit(
      repository: getIt<CloudNoteRepository>(),
    ),
  );
}