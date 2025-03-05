import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/dashboard/data/model/location.dart';
import 'package:wastemanagement/features/dashboard/data/model/user_report.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_request.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_response.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/create_report.dart';

import '../../mock_waste_repository.dart';

void main() {
  late CreateReport usecase;
  late MockReportWasteRepository repository;

  setUp(() {
    repository = MockReportWasteRepository();
    usecase = CreateReport(repository);
  });

  final testFile = File('test_path.jpg');
  final testRequest = ReportWasteRequest(description: 'Test waste report', wasteType: 'plastic', lat: 27.7172, lng: 85.3240, imageFile: testFile);

  final testResponse = ReportWasteResponse(
    message: 'Report created successfully',
    report: UserReport(
      id: '123',
      user: 'user123',
      description: 'Test waste report',
      wasteType: 'plastic',
      imagePath: 'path/to/image.jpg',
      status: 'pending',
      pointsAwarded: 0,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
      location: Location(lat: 27.7172, lng: 85.3240),
    ),
  );

  test('should call the [ReportWasteRepository.reportWaste] and return success message', () async {
    // Arrange
    when(() => repository.reportWaste(testRequest)).thenAnswer((_) async => testResponse);

    // Act
    final result = await usecase(testRequest);

    // Assert
    expect(result, Right('Report created successfully'));

    // Verify
    verify(() => repository.reportWaste(testRequest)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return ApiFailure when repository throws an exception', () async {
    // Arrange
    when(() => repository.reportWaste(testRequest)).thenThrow(Exception('Network error'));

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
    verify(() => repository.reportWaste(testRequest)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
