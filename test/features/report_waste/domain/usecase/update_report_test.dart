import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/dashboard/data/model/location.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_request.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_response.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/update_report.dart';

import '../../mock_waste_repository.dart';

void main() {
  late UpdateReport usecase;
  late MockReportWasteRepository repository;

  setUp(() {
    repository = MockReportWasteRepository();
    usecase = UpdateReport(repository);
  });

  final testFile = File('test_path.jpg');
  final testRequest = ReportWasteRequest(
    id: '123',
    description: 'Updated waste report',
    wasteType: 'paper',
    lat: 27.7172,
    lng: 85.3240,
    imageFile: testFile,
  );

  final testResponse = ReportWasteResponse(
    message: 'Report updated successfully',
    report: UserReport(
      id: '123',
      user: 'user123',
      description: 'Updated waste report',
      wasteType: 'paper',
      imagePath: 'path/to/image.jpg',
      status: 'pending',
      pointsAwarded: 0,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-02',
      location: Location(lat: 27.7172, lng: 85.3240),
    ),
  );

  test('should call the [ReportWasteRepository.updateReport] and return success message', () async {
    // Arrange
    when(() => repository.updateReport(testRequest)).thenAnswer((_) async => testResponse);

    // Act
    final result = await usecase(testRequest);

    // Assert
    expect(result, Right('Report updated successfully'));

    // Verify
    verify(() => repository.updateReport(testRequest)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return ApiFailure when repository throws an exception', () async {
    // Arrange
    when(() => repository.updateReport(testRequest)).thenThrow(Exception('Network error'));

    // Act
    final result = await usecase(testRequest);

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
    verify(() => repository.updateReport(testRequest)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
