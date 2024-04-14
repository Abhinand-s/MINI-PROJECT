import 'package:appointment/repositories/doctor_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:models/models.dart';

part 'doctor_details_event.dart';
part 'doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  final DoctorRepository _doctorRepository;
  DoctorDetailsBloc({
    required DoctorRepository doctorRepository,

  }) :_doctorRepository=doctorRepository,
   super(const DoctorDetailsState()) {
    on<DoctorDetailsEvent>(_onLoadDoctorDetails);
 }

 void _onLoadDoctorDetails(
  DoctorDetailsEvent event,
  Emitter<DoctorDetailsState> emit,

 ) async {
  emit(state.copyWith(status: DoctorDetailsStatus.loading));
try {
  if (event.doctorId == null) {
    debugPrint('Doctor ID is null');
    emit(state.copyWith(status: DoctorDetailsStatus.error));
  } else {
    final doctor = await _doctorRepository.fetchDoctorById(event.doctorId!);

    if(doctor == null){
      emit(state.copyWith(status: DoctorDetailsStatus.error));
    } else {
      emit(state.copyWith(
        status: DoctorDetailsStatus.loaded,
        doctor: doctor
      ));
    }
  }
} catch(err) {
  debugPrint('Error occurred: $err');
  emit(state.copyWith(status: DoctorDetailsStatus.error));
}
 }
}
