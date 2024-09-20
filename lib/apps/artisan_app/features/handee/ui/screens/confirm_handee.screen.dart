import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/handee/providers/handee-details.provider.dart';
import 'package:handees/apps/artisan_app/features/handee/ui/widgets/handee_detail_selection.dart';
import 'package:handees/apps/artisan_app/features/home/providers/current-offer.provider.dart';
import 'package:handees/apps/artisan_app/services/sockets/artisan_socket.dart';
import 'package:handees/apps/artisan_app/services/sockets/artisan_socket_events.dart';
import 'package:handees/shared/data/handees/handee_options.dart';
import 'package:handees/shared/routes/routes.dart';
import 'package:handees/shared/utils/utils.dart';

class ConfirmHandeeScreen extends ConsumerStatefulWidget {
  const ConfirmHandeeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmHandeeScreenState();
}

class _ConfirmHandeeScreenState extends ConsumerState<ConfirmHandeeScreen> {
  final List<HandeeOption> workDurations = [
    HandeeOption(
      title: WorkDurationTypes.oneTime,
      description:
          'The one-time time duration is for handee services that may be completed under 24hrs',
    ),
    HandeeOption(
      title: WorkDurationTypes.contract,
      description:
          'The contract time duration is for handee services that may not be completed under 24hrs',
    ),
  ];

  final List<HandeeOption> paymentOptions = [
    HandeeOption(
      title: PaymentOptionTypes.hourly,
      description:
          'Payment shall be made based on the number of hours used to complete the handee',
    ),
    HandeeOption(
      title: PaymentOptionTypes.negotiated,
      description: 'Payment will be made based on the agreed negotiated price',
    ),
  ];

  void verifyHandeeHandler(BuildContext context) {
    final result = ref
        .read(handeeApprovalDetailsProvider.notifier)
        .validateHandeeApproval();

    if (result.isNotEmpty) {
      displaySnackbar(context, result);
    } else {
      setState(() {
        isLoading = true;
      });
      ref.read(artisanSocketProvider.notifier).requestCustomerApproval(
            ref.read(handeeApprovalDetailsProvider),
          );
      ref.read(artisanSocketProvider.notifier).registerEventHandler(
          ArtisanSocketListenEvents.jobDetailsConfirmed, () {
        setState(() {
          isVerified = true;
          isLoading = false;
        });
      });
      ref.read(artisanSocketProvider.notifier).registerEventHandler(
          ArtisanSocketListenEvents.jobDetailsRejected, () {
        setState(() {
          isLoading = false;
          displaySnackbar(
              context, 'The handee was not verified by the customer');
        });
      });
    }
  }

  bool isLoading = false;
  bool isVerified = -1 < 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
        title: Text(
          'Confirm Handee Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight - safeAreaInsets.top - kToolbarHeight,
          child: Column(
            children: [
              HandeeDetailSelection(
                type: HandeeOptionTypes.workDuration,
                title: 'Work Duration',
                titleIcon: Icon(
                  Icons.alarm,
                  color: getHexColor('B9B9BB'),
                ),
                options: workDurations,
              ),
              const SizedBox(
                height: 20,
              ),
              HandeeDetailSelection(
                type: HandeeOptionTypes.paymentOption,
                title: 'Payment Preference',
                titleIcon: Icon(
                  Icons.payment,
                  color: getHexColor('B9B9BB'),
                ),
                options: paymentOptions,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0, 0, 0, 40
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: FilledButton(
                          onPressed: () {
                            ref
                                .read(artisanSocketProvider.notifier)
                                .cancelOffer(
                                    ref.read(currentOfferProvider).bookingId);

                            ref.invalidate(handeeApprovalDetailsProvider);

                            Navigator.of(context).pop();
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromRGBO(249, 22, 22, 0.05)),
                          ),
                          child: Text(
                            'Cancel Handee',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: getHexColor('e63946'),
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: isVerified
                            ? FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      ArtisanAppRoutes
                                          .contractHandeeInProgress);
                                },
                                child: Text(
                                  'Begin Handee',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              )
                            : FilledButton(
                                onPressed: isLoading
                                    ? () {}
                                    : () => verifyHandeeHandler(context),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Verify Handee',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                              ),
                      ),
                    ),
                  ],
                ),
              )
                    ]
                  ),
                )
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
