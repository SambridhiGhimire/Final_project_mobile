import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/dashboard/data/model/location.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_details.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/fetch_report.dart';
import 'package:wastemanagement/features/report_waste/presentation/view_model/report_details/report_details_cubit.dart';

class MockFetchReport extends Mock implements FetchReport {}

void main() {
  late ReportDetailsCubit cubit;
  late MockFetchReport fetchReport;

  setUp(() {
    fetchReport = MockFetchReport();
    cubit = ReportDetailsCubit(fetchReport);
  });

  tearDown(() {
    cubit.close();
  });

  final testReportId = '123';
  final testReportDetails = ReportDetails(
    id: '123',
    description: 'Test waste report',
    wasteType: 'plastic',
    imagePath: 'path/to/image.jpg',
    status: 'pending',
    pointsAwarded: 0,
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
    location: Location(lat: 27.7172, lng: 85.3240),
    userObject: User(id: 'user123', name: 'Test User', email: 'test@example.com'),
  );

  test('initial state should be ReportDetailsLoading', () {
    expect(cubit.state, isA<ReportDetailsLoading>());
  });

  blocTest<ReportDetailsCubit, ReportDetailsState>(
    'emits [ReportDetailsLoaded] when loadReportDetails is called successfully',
    build: () {
      when(() => fetchReport(testReportId)).thenAnswer((_) async => Right(testReportDetails));
      return cubit;
    },
    act: (cubit) => cubit.loadReportDetails(testReportId),
    expect: () => [isA<ReportDetailsLoaded>().having((state) => state.reportDetails, 'reportDetails', equals(testReportDetails))],
    verify: (_) {
      verify(() => fetchReport(testReportId)).called(1);
      verifyNoMoreInteractions(fetchReport);
    },
  );

  blocTest<ReportDetailsCubit, ReportDetailsState>(
    'emits [ReportDetailsError] when loadReportDetails fails',
    build: () {
      when(() => fetchReport(testReportId)).thenAnswer((_) async => Left(ApiFailure(message: 'Failed to load report')));
      return cubit;
    },
    act: (cubit) => cubit.loadReportDetails(testReportId),
    expect: () => [isA<ReportDetailsError>().having((state) => state.message, 'error message', equals('Failed to load report'))],
    verify: (_) {
      verify(() => fetchReport(testReportId)).called(1);
      verifyNoMoreInteractions(fetchReport);
    },
  );
}
