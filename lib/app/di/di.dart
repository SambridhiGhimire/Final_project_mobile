import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wastemanagement/app/shared_prefs/onboarding_shared_prefs.dart';
import 'package:wastemanagement/core/common/internet_checker/internet_checker.dart';
import 'package:wastemanagement/features/auth/domain/use_case/fetch_user_profile.dart';
import 'package:wastemanagement/features/auth/domain/use_case/send_reset_link.dart';
import 'package:wastemanagement/features/auth/domain/use_case/sign_up_user.dart';
import 'package:wastemanagement/features/auth/domain/use_case/update_profile.dart';
import 'package:wastemanagement/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:wastemanagement/features/dashboard/domain/usecase/fetch_user_reports.dart';
import 'package:wastemanagement/features/report_waste/data/datasource/report_waste_remote_datasource.dart';
import 'package:wastemanagement/features/report_waste/data/repository/report_waste_repository_impl.dart';
import 'package:wastemanagement/features/report_waste/domain/repository/report_waste_repository.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/create_report.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/delete_report.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/fetch_report.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/update_report.dart';
import 'package:wastemanagement/features/report_waste/presentation/view_model/report_details/report_details_cubit.dart';

import '../../core/network/api_service.dart';
import '../../core/network/hive_service.dart';
import '../../features/auth/data/data_source/remote_datasource/user_remote_data_source.dart';
import '../../features/auth/data/repository/user_remote_repository.dart';
import '../../features/auth/domain/use_case/login_user_usecase.dart';
import '../../features/auth/presentation/view_model/profile/profile_cubit.dart';
import '../../features/auth/presentation/view_model/login/login_bloc.dart';
import '../../features/dashboard/data/repository/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repository/dashboard_repository.dart';
import '../../features/home/presentation/view/bottom_view_model/dashboard_bloc.dart';
import '../../features/home/presentation/view_model/home_cubit.dart';
import '../../features/onboarding/presentation/view_model/onboarding_cubit.dart';
import '../../features/report_waste/presentation/view_model/report_waste/report_waste_cubit.dart';
import '../../features/splash/presentation/view_model/splash_cubit.dart';
import '../shared_prefs/token_shared_prefs.dart';
import '../shared_prefs/user_shared_prefs.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Sequence of Dependencies Matter!!

  await _initInternetChecker();
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();

  // Start with Splash
  await _initSplashScreenDependencies();

  // Onboarding
  await _initOnboardingScreenDependencies();

  // Initialize Authentication Dependencies
  await _initLoginDependencies();
  await _initRegisterDependencies();

  // Initialize Home
  await _initHomeDependencies();

  // Initialize Dashboard and Others
  await _initDashboardDependencies();

  // Initialize Profile
  _initProfileDependencies();

  // Initialize Report Waste
  await _initWasteReportDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(() => ApiService(Dio()).dio);
}

_initInternetChecker() {
  getIt.registerLazySingleton<InternetChecker>(() => InternetChecker());
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initHomeDependencies() async {
  getIt.registerSingleton<HomeCubit>(HomeCubit(tokenSharedPrefs: getIt<TokenSharedPrefs>(), userSharedPrefs: getIt<UserSharedPrefs>()));
}

_initRegisterDependencies() async {
  if (!getIt.isRegistered<UserRemoteDataSource>()) {
    getIt.registerFactory<UserRemoteDataSource>(() => UserRemoteDataSource(getIt<Dio>()));
  }

  if (!getIt.isRegistered<UserRemoteRepository>()) {
    getIt.registerLazySingleton<UserRemoteRepository>(() => UserRemoteRepository(getIt<UserRemoteDataSource>()));
  }
}

// _initProfileDependencies() async {
//   if (!getIt.isRegistered<UserRemoteDataSource>()) {
//     getIt.registerFactory<UserRemoteDataSource>(() => UserRemoteDataSource(getIt<Dio>()));
//   }

//   if (!getIt.isRegistered<UserRemoteRepository>()) {
//     getIt.registerLazySingleton<UserRemoteRepository>(() => UserRemoteRepository(getIt<UserRemoteDataSource>()));
//   }

// FetchUser
// getIt.registerLazySingleton<GetUserByIdUsecase>(() => GetUserByIdUsecase(userRepository: getIt<UserRemoteRepository>()));

// UpdateUserUsecase
// getIt.registerLazySingleton<UpdateUserUsecase>(
//   () => UpdateUserUsecase(
//     userRepository: getIt<UserRemoteRepository>(),
//     tokenSharedPrefs: getIt<TokenSharedPrefs>(),
//     userSharedPrefs: getIt<UserSharedPrefs>(),
//   ),
// );

// Register RegisterBloc
// getIt.registerFactory<ProfileBloc>(
//   () => ProfileBloc(
//     // batchBloc: getIt<BatchBloc>(),
//     // workshopBloc: getIt<WorkshopBloc>(),
//     updateUserUsecase: getIt<UpdateUserUsecase>(),
//     getUserByIdUsecase: getIt<GetUserByIdUsecase>(),
//     userSharedPrefs: getIt<UserSharedPrefs>(),
//     uploadImageUseCase: getIt<UploadImageUseCase>(),
//   ),
// );
// }

_initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(() => TokenSharedPrefs(getIt<SharedPreferences>()));

  if (!getIt.isRegistered<LoginUserUsecase>()) {
    getIt.registerLazySingleton<LoginUserUsecase>(
      () => LoginUserUsecase(
        tokenSharedPrefs: getIt<TokenSharedPrefs>(),
        userRepository: getIt<UserRemoteRepository>(),
        userSharedPrefs: getIt<UserSharedPrefs>(),
        dio: getIt<Dio>(),
      ),
    );
  }

  getIt.registerLazySingleton<SignUpUser>(() => SignUpUser(userRepository: getIt<UserRemoteRepository>()));
  getIt.registerLazySingleton<SendResetLink>(() => SendResetLink(userRepository: getIt<UserRemoteRepository>()));

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      homeCubit: getIt<HomeCubit>(),
      // batchBloc: getIt<BatchBloc>(),
      // workshopBloc: getIt<WorkshopBloc>(),
      loginUserUsecase: getIt<LoginUserUsecase>(),
    ),
  );
}

_initSplashScreenDependencies() async {
  getIt.registerLazySingleton<OnboardingSharedPrefs>(() => OnboardingSharedPrefs(getIt<SharedPreferences>()));
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<TokenSharedPrefs>(), getIt<HomeCubit>(), getIt<LoginBloc>(), getIt<OnboardingSharedPrefs>(), getIt<OnboardingCubit>()),
  );
}

_initOnboardingScreenDependencies() async {
  getIt.registerLazySingleton<UserSharedPrefs>(() => UserSharedPrefs());
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit(getIt<LoginBloc>()));
}

_initDashboardDependencies() {
  getIt.registerLazySingleton<DashboardRemoteDatasource>(() => DashboardRemoteDatasourceImpl(getIt<Dio>()));
  getIt.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(getIt<DashboardRemoteDatasource>(), getIt<InternetChecker>()));
  getIt.registerLazySingleton<FetchUserReports>(() => FetchUserReports(getIt<DashboardRepository>()));
  getIt.registerFactory<DashboardBloc>(() => DashboardBloc(getIt<FetchUserReports>()));
}

_initProfileDependencies() {
  getIt.registerLazySingleton<FetchUserProfile>(() => FetchUserProfile(userSharedPrefs: getIt<UserSharedPrefs>()));
  getIt.registerLazySingleton<UpdateProfile>(
    () => UpdateProfile(userSharedPrefs: getIt<UserSharedPrefs>(), userRepository: getIt<UserRemoteRepository>()),
  );
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt<FetchUserProfile>(), getIt<UpdateProfile>()));
}

_initWasteReportDependencies() {
  getIt.registerLazySingleton<ReportWasteRemoteDatasource>(() => ReportWasteRemoteDatasourceImpl(getIt<Dio>()));
  getIt.registerLazySingleton<ReportWasteRepository>(() => ReportWasteRepositoryImpl(getIt<ReportWasteRemoteDatasource>(), getIt<InternetChecker>()));

  getIt.registerLazySingleton<CreateReport>(() => CreateReport(getIt<ReportWasteRepository>()));
  getIt.registerLazySingleton<UpdateReport>(() => UpdateReport(getIt<ReportWasteRepository>()));
  getIt.registerLazySingleton<DeleteReport>(() => DeleteReport(getIt<ReportWasteRepository>()));
  getIt.registerLazySingleton<FetchReport>(() => FetchReport(getIt<ReportWasteRepository>()));

  getIt.registerFactory<ReportWasteCubit>(() => ReportWasteCubit(getIt<CreateReport>(), getIt<UpdateReport>(), getIt<DeleteReport>()));
  getIt.registerFactory<ReportDetailsCubit>(() => ReportDetailsCubit(getIt<FetchReport>()));
}
