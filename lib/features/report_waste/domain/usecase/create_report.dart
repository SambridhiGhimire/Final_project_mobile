import 'package:dartz/dartz.dart';
import 'package:wastemanagement/app/usecase/usecase.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/report_waste/data/model/report_waste_request.dart';
import 'package:wastemanagement/features/report_waste/domain/repository/report_waste_repository.dart';

class CreateReport implements UsecaseWithParams<String, ReportWasteRequest> {
  final ReportWasteRepository repository;

  CreateReport(this.repository);

  @override
  Future<Either<Failure, String>> call(ReportWasteRequest request) async {
    try {
      final res = await repository.reportWaste(request);
      return Right(res.message);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
