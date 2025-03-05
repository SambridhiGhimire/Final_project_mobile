import 'package:dartz/dartz.dart';
import 'package:wastemanagement/app/usecase/usecase.dart';
import 'package:wastemanagement/core/error/failure.dart';
import 'package:wastemanagement/features/report_waste/domain/repository/report_waste_repository.dart';

class DeleteReport implements UsecaseWithParams<bool, String> {
  final ReportWasteRepository repository;

  DeleteReport(this.repository);

  @override
  Future<Either<Failure, bool>> call(String id) async {
    try {
      final res = await repository.deleteReport(id);
      return Right(res);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
