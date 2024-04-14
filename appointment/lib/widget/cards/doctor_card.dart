import 'package:flutter/material.dart';
import 'package:models/models.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    this.showAbout = true,
    this.showMoreInformation = true,
  }) : super(key: key);

  final Doctor doctor;
  final bool showAbout;
  final bool showMoreInformation;

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final moreInformation = [
      {
        'icon': Icons.account_circle_outlined,
        'label': 'Patients',
        'value': widget.doctor.patientCount,
      },
      {
        'icon': Icons.star_border,
        'label': 'Experience',
        'value': '3 years',
      },
      {
        'icon': Icons.favorite_border,
        'label': 'Rating',
        'value': widget.doctor.rating,
      },
      {
        'icon': Icons.numbers,
        'label': 'Reviews',
        'value': widget.doctor.reviewCount,
      },
    ];
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //profile
          Row(
            children: [
              CircleAvatar(
                radius: 48.0,
                backgroundColor: colorScheme.background,
                backgroundImage: NetworkImage(widget.doctor.profileImageUrl),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name,
                      style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.doctor.category.name,
                      style: textTheme.bodyMedium!.copyWith(color: colorScheme.onBackground.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: colorScheme.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'New York, USA',
                          style: textTheme.bodyMedium!.copyWith(color: colorScheme.onBackground.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 40.0, color: Colors.grey),
          //about
          if (widget.showAbout)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.doctor.bio,
                  maxLines: showAll ? null : 3,
                  style: textTheme.bodyMedium!.copyWith(color: colorScheme.onBackground.withOpacity(0.5)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(
                    showAll ? 'Show less' : 'Show all',
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.secondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          //more information
          if (widget.showMoreInformation)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: moreInformation
                  .map(
                    (e) => Expanded(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            child: Icon(e['icon'] as IconData),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            e['value'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e['label'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
