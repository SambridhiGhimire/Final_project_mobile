import 'package:dartz/dartz.dart';
import 'package:wastemanagement/app/usecase/usecase.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/report_waste/domain/repository/report_waste_repository.dart';

import '../../data/model/report_details.dart';

class FetchReport implements UsecaseWithParams<ReportDetails, String> {
  final ReportWasteRepository repository;

  FetchReport(this.repository);

  @override
  Future<Either<Failure, ReportDetails>> call(String id) async {
    try {
      final res = await repository.getReportDetails(id);
      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
