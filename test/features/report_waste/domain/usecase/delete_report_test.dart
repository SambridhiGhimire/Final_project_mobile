import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/report_waste/domain/usecase/delete_report.dart';

import '../../mock_waste_repository.dart';

void main() {
  late DeleteReport usecase;
  late MockReportWasteRepository repository;

  setUp(() {
    repository = MockReportWasteRepository();
    usecase = DeleteReport(repository);
  });

  final testReportId = '123';

  test('should call the [ReportWasteRepository.deleteReport] and return true on success', () async {
    // Arrange
    when(() => repository.deleteReport(testReportId)).thenAnswer((_) async => true);

    // Act
    final result = await usecase(testReportId);

    // Assert
    expect(result, const Right(true));

    // Verify
    verify(() => repository.deleteReport(testReportId)).called(1);
    verifyNoMoreInteractions(repository);
  });

  test('should return ApiFailure when repository throws an exception', () async {
    // Arrange
    when(() => repository.deleteReport(testReportId)).thenThrow(Exception('Network error'));

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
    verify(() => repository.deleteReport(testReportId)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
