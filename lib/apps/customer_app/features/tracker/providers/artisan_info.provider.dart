import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/shared/data/handees/booking.dart';

final currentBookingProvider =
    StateNotifierProvider<CurrentBookingStateNotifier, Booking>(
        (ref) => CurrentBookingStateNotifier());

class CurrentBookingStateNotifier extends StateNotifier<Booking> {
  CurrentBookingStateNotifier() : super(Booking.empty());

  void updateCurrentBooking(Booking newBooking) {
    state = newBooking;
  }
}
