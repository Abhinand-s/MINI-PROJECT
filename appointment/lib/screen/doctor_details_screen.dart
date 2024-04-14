import 'package:appointment/repositories/doctor_repository.dart';
import 'package:appointment/shared/utils/time_of_day_extention.dart';
import 'package:appointment/state/doctor_details/doctor_details_bloc.dart';
import 'package:appointment/widget/buttons/app_icon_button.dart';
import 'package:appointment/widget/cards/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctorId});
  final String doctorId;
  @override
  Widget build(BuildContext context) {
    //create the bloc here
    return BlocProvider(
      create: (context) =>
          DoctorDetailsBloc(doctorRepository: context.read<DoctorRepository>())
            ..add(
              LoadDoctorDetailsEvent(doctorId: doctorId),
            ),
      child: const DoctorDetailsView(),
    );
  }
}

class DoctorDetailsView extends StatelessWidget {
  const DoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.pop(context),
        ),
        title: Text(
          'Doctor Details',
          style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [AppIconButton(icon: Icons.favorite_outline, onTap: () {})],
      ),
      body: BlocBuilder<DoctorDetailsBloc, DoctorDetailsState>(
        builder: (context, state) {
          if(state.status  == DoctorDetailsStatus.initial || state.status == DoctorDetailsStatus.loading){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(state.status == DoctorDetailsStatus.loaded){
            final doctor = state.doctor;

            if(doctor == null){
              return const Center(child: Text('Doctor not found'),);
            }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorCard(
                  doctor:state.doctor!,
                ),
                Divider(height: 32.0, color: colorScheme.surfaceVariant),
                _DoctorWorkingHours(workingHours : doctor.workingHours),
              ],
            ),
          );
          }else{
            return const Center(child: Text('something went wrong'),);
          }
        },
      ),
    );
  }
}

class _DoctorWorkingHours extends StatelessWidget {
  const _DoctorWorkingHours({
    required this.workingHours
  });
 final List<DoctorWorkingHours> workingHours;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Working Hours',
          style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8.0,
        ),
        ListView.separated(
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: Doctor.sampleDoctors[0].workingHours.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 8.0,
          ),
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                    child: Text(
                  workingHours[index].dayOfWeek,
                )),
                const SizedBox(
                  width: 16.0,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.surfaceVariant),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    workingHours[index].startTime
                        .toCustomString(),
                    style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onBackground.withOpacity(.5)),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                const Text("-"),
                const SizedBox(
                  width: 16.0,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.surfaceVariant),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    workingHours[index].endTime
                        .toCustomString(),
                    style: textTheme.bodySmall!.copyWith(
                        color: colorScheme.onBackground.withOpacity(.5)),
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }
}
