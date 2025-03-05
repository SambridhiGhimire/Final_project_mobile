import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/dashboard/data/model/location.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_details.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/fetch_report.dart';

import '../../mock_waste_repository.dart';

void main() {
  late FetchReport usecase;
  late MockReportWasteRepository repository;

  setUp(() {
    repository = MockReportWasteRepository();
    usecase = FetchReport(repository);
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

  test('should call the [ReportWasteRepository.getReportDetails] and return report details', () async {
    // Arrange
    when(() => repository.getReportDetails(testReportId)).thenAnswer((_) async => testReportDetails);

    // Act
    final result = await usecase(testReportId);

    // Assert
    expect(result, Right(testReportDetails));

    // Verify
    verify(() => repository.getReportDetails(testReportId)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return ApiFailure when repository throws an exception', () async {
    // Arrange
    when(() => repository.getReportDetails(testReportId)).thenThrow(Exception('Network error'));

    // Act
    final result = await usecase(testReportId);

    // Assert
    expect(
      result,
      isA<Left>().having(
        (left) => left.value,
        'failure',
        isA<ApiFailure>().having((failure) => failure.message, 'message', contains('Network error')),
      ),
    );

    // Verify
    verify(() => repository.getReportDetails(testReportId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
