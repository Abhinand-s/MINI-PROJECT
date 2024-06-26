// ignore: file_names
import 'package:flutter/services.dart';
import 'package:signup_login/appointment/state/home/home_bloc.dart';

import 'package:signup_login/appointment/widget/list_title/doctor_list_title.dart';
import 'package:signup_login/appointment/widget/title/section_title.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //create a bloc and provide it to the homeview
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //create the homeview ui
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            SystemNavigator.pop(); // This will force quit the app
          },
        ),
      
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 4.0,
            ),
          ],
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading ||
              state.status == HomeStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == HomeStatus.loaded) {
            return const SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  
                  _NearbyDoctor()
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Error loading data'),
            );
          }
        },
      ),
      
    );
  }
}

class _NearbyDoctor extends StatelessWidget {
  const _NearbyDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            SectionTitle(
              title: 'Nearby Doctors',
              action: 'See all',
              onPressed: () {},
            ),
            const SizedBox(
              height: 8.0,
            ),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 24.0,
                    color: colorScheme.surfaceVariant,
                  );
                },
                itemCount: state.nearbyDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = state.nearbyDoctors[index];
                  return DoctorListTile(
                    doctor: doctor,
                  );
                })
          ],
        );
      },
    );
  }
}

// class _MySchedule extends StatelessWidget {
//   const _MySchedule({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             SectionTitle(
//               title: 'My Schedule',
//               action: 'See all',
//               onPressed: () {},
//             ),
//             AppointmentPreviewCard(appointment: state.myappointment.firstOrNull)
//           ],
//         );
//       },
//     );
//   }
// }

// class _DoctorCategories extends StatelessWidget {
//   const _DoctorCategories();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         return Column(
//           children: [
//             SectionTitle(
//               title: 'Categories',
//               action: 'See all',
//               onPressed: () {},
//             ),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: state.doctorCategories
//                     //take 5 could be added in the bloc calculation
//                     .take(5)
//                     .map((category) => Expanded(
//                           child: CircleAvatarWithTextLabel(
//                               icon: category.icon, label: category.name),
//                         ))
//                     .toList())
//           ],
//         );
//       },
//     );
//   }
// }
