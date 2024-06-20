import 'package:models/models.dart';
class DoctorRepository{
  const DoctorRepository(
    //todo: inject the required dependencies
    // eg. class to connect with the db
  );

  Future<List<DoctorCategory>> fetchDoctorCategories() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    return DoctorCategory.values;
    //todo:inject the required dependencie
  }
  Future<List<Doctor>> fetchDoctors() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    return Doctor.sampleDoctors;
  }
  Future<List<Doctor>> fetchDoctorsByCategory(String catergoryId) async{
    throw UnimplementedError();
  }
  Future<Doctor?> fetchDoctorById(String doctorId) async{
    await Future.delayed(const Duration(milliseconds: 1000));
    return Doctor.sampleDoctors.firstWhere((doctor) => doctor.id == doctorId);
  }
}