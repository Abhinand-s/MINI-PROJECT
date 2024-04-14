import 'package:equatable/equatable.dart';


import 'doctor_address.dart';
import 'doctor_category.dart';
import 'doctor_package.dart';
import 'doctor_working_hours.dart';


class Doctor extends Equatable {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final DoctorCategory category;
  final DoctorAddress address;
  final List<DoctorPackage> package;
  final List<DoctorWorkingHours> workingHours;
  final double rating;
  final int reviewCount;
  final int patientCount;

  const Doctor({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.category,
    required this.address,
    required this.package,
    required this.workingHours,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.patientCount = 0,
  });

  @override
  List<Object> get props => [
        id,
        name,
        bio,
        profileImageUrl,
        category,
        address,
        package,
        workingHours,
        rating,
        reviewCount,
        patientCount,
      ];

  static final sampleDoctors = [
    Doctor(
        id: '1',
        name: 'Dr.Abhinand',
        bio: 'DR.ABHI is a cardiologist in new york',
        profileImageUrl: 'https://images.hdqwalls.com/download/doctor-strange-2016-sd-2932x2932.jpg',
        category:DoctorCategory.familyMedicine,
        address: DoctorAddress.sampleAddresses[0],
        package: DoctorPackage.samplePackages,
        workingHours: DoctorWorkingHours.sampleDoctorWorkingHours,
        rating: 4.5,
        reviewCount: 100,
        patientCount: 1000),
         Doctor(
        id: '2',
        name: 'Dr.Ammu',
        bio: 'DR.AMMU is a dentist in new york',
        profileImageUrl: 'https://images.hdqwalls.com/download/christine-palmer-doctor-strange-in-the-multiverse-of-madness-q6-750x1334.jpg',
        category:DoctorCategory.dentist,
        address: DoctorAddress.sampleAddresses[0],
        package: DoctorPackage.samplePackages,
        workingHours: DoctorWorkingHours.sampleDoctorWorkingHours,
        rating: 4.5,
        reviewCount: 100,
        patientCount: 1000),

  ];
}
