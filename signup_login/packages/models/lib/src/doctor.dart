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
        name: 'Dr.Anu',
        bio: "Dr. Anu is a cardiologist in New York implies that Dr. Anu is a medical doctor who specializes in cardiology, a branch of medicine that deals with disorders of the heart and blood vessels. Being located in New York suggests that Dr. Anu practices in the city of New York, possibly at a hospital, clinic, or private practice there. This information provides a brief overview of Dr. Anu's profession and location.",
        profileImageUrl: 'https://www.shutterstock.com/image-photo/portrait-pretty-positive-lady-crossed-600nw-2162907825.jpg',
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
        bio: "Dr. Ammu is a dentist in New York indicates that Dr. Ammu is a dental professional who specializes in oral health, including the diagnosis, prevention, and treatment of oral diseases. Being located in New York suggests that Dr. Ammu practices dentistry in the city of New York, likely at a dental clinic or office. This information provides a brief overview of Dr. Ammu's profession and location.",
        profileImageUrl: 'https://img.freepik.com/free-photo/expressive-young-woman-posing-studio_176474-66978.jpg',
        category:DoctorCategory.dentist,
        address: DoctorAddress.sampleAddresses[0],
        package: DoctorPackage.samplePackages,
        workingHours: DoctorWorkingHours.sampleDoctorWorkingHours,
        rating: 4.5,
        reviewCount: 100,
        patientCount: 1000),
        Doctor(
        id: '3',
        name: 'Dr.Arun',
        bio: "Dr. Arun is a dermatologist suggests that Dr. Arun is a medical doctor specializing in dermatology, a branch of medicine focused on the diagnosis and treatment of skin, hair, and nail disorders. This implies that Dr. Arun's expertise lies in addressing a wide range of skin conditions, from acne and eczema to skin cancer and cosmetic dermatology. The statement does not specify Dr. Arun's location or practice setting.",
        profileImageUrl: 'https://m.economictimes.com/photo/62710131.cms',
        category:DoctorCategory.dermatology,
        address: DoctorAddress.sampleAddresses[0],
        package: DoctorPackage.samplePackages,
        workingHours: DoctorWorkingHours.sampleDoctorWorkingHours,
        rating: 4.0,
        reviewCount: 100,
        patientCount: 100),

  ];
}
