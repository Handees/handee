import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/customer_app/features/tracker/providers/customer_location.provider.dart';
import 'package:handees/apps/customer_app/services/booking_service.customer.dart';
import 'package:handees/apps/customer_app/services/sockets/customer_socket.dart';
import 'package:handees/shared/data/handees/job_category.dart';
import 'package:location/location.dart';

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>(
    (ref) => BookingNotifier(
        FirebaseAuth.instance,
        ref.watch(bookingServiceProvider),
        ref.watch(customerSocketProvider),
        ref));

class BookingNotifier extends StateNotifier<BookingState> {
  final BookingService _bookingService;
  final FirebaseAuth _auth;
  final CustomerSocket _socket;
  final StateNotifierProviderRef<BookingNotifier, BookingState> _ref;

  late JobCategory _category;
  JobCategory get category => _category;

  BookingNotifier(this._auth, this._bookingService, this._socket, this._ref)
      : super(BookingState.idle) {
    _ref.read(customerLocationProvider.notifier).initLocation();
    _socket.connect();
    _socket.onBookingOfferAccepted((event) {
      state = BookingState.inProgress;
    });
    _socket.onArtisanArrived((event) {
      state = BookingState.arrived;
    });
    // _socket.onApproveBookingDetails((p0) { })
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }

  Future<String> bookService({
    required JobCategory category,
    required LocationData location,
  }) async {
    //TODO: Change below to loading: WIP
    state = BookingState.loading;
    _category = category;

    final token = await _auth.currentUser!.getIdToken();

    return await _bookingService.bookService(
      token: token,
      lat: location.latitude!,
      lon: location.longitude!,
      // lat: 6.548281268456966,
      // lon: 3.332248000980724,
      category: category,
    );
  }
}

enum BookingState { idle, loading, foundArtisan, inProgress, arrived, done }
