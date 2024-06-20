part of 'home_bloc.dart';

enum HomeStatus { initial , loading, loaded, error}
class HomeState extends Equatable {

  final HomeStatus status;
  final List<DoctorCategory> doctorCategories;
  final List<Doctor> nearbyDoctors;
  final List myappointment;
  const HomeState(
    {
      this.status=HomeStatus.initial,
      this.doctorCategories = const <DoctorCategory>[],
      this.nearbyDoctors = const <Doctor>[],
       this.myappointment = const [], 
    }
  );
  
   HomeState copyWith({
    HomeStatus? status,
    List<DoctorCategory>? doctorCategories,
   List<Doctor> ?nearbyDoctors,
   List ?myappointment

  }){
    return HomeState(
      status: status ?? this.status,
      doctorCategories: doctorCategories ?? this.doctorCategories,
      nearbyDoctors: nearbyDoctors ?? this.nearbyDoctors,
      myappointment: myappointment ?? this.myappointment
    );
  }
  @override
  List<Object> get props => [
    status,
    doctorCategories,
    nearbyDoctors,
    myappointment,
  ];
}


