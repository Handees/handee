import 'package:flutter/material.dart';
import 'package:handees/customer_app/models/complete_profile_link_model.dart';

class CompleteProfileLinkCard extends StatelessWidget {
  const CompleteProfileLinkCard(this.completeProfileLink, {super.key});

  final CompleteProfileLink completeProfileLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                completeProfileLink.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                completeProfileLink.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(completeProfileLink.routerLink);
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
              ))
        ],
      ),
    );
  }
}