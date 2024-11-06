import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/customer_app/services/sockets/customer_socket_events.dart';
import 'package:handees/shared/res/uri.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final customerSocketProvider =
    Provider((ref) => CustomerSocket._(AuthService.instance));

class CustomerSocket {
  CustomerSocket._(this._authService) {
    _socket.onConnect((_) => dPrint('customer connected'));

    _socket.onDisconnect((_) => dPrint('customer disconnected'));

    _socket.onAny((event, data) {
      dPrint('Customer update any: Event($event) $data');
    });
  }
  // static final CustomerSockets _instance = CustomerSockets._();
  // static CustomerSockets get instance => _instance;
  final AuthService _authService;

  late final io.Socket _socket = io.io(
    AppUris.customerSocketUri.toString(),
    io.OptionBuilder()
        .setAuth({'access_token': _authService.token}).setTransports(
            ['websocket']).build(),
  );

  void connect() => _socket.connect();

  void disconnect() => _socket.disconnect();

  void cancelOffer(String bookingId) {
    _socket
        .emit(CustomerSocketEmitEvents.cancelOffer, {"booking_id": bookingId});
  }

  void confirmJobDetails({
    required String bookingId,
    required bool isContract,
    required String settlementType,
    required double settlementAmount,
    required int duration,
    required String durationUnit,
  }) {
    _socket.emit(CustomerSocketEmitEvents.confirmJobDetails, {
      'booking_id': bookingId,
      'is_contract': isContract,
      'settlement': {
        'type': settlementType,
        'amount': settlementAmount,
      },
      'duration': duration,
      'duration_unit': durationUnit,
    });
  }

  void rejectJobDetails(String bookingId) {
    _socket.emit(
        CustomerSocketEmitEvents.rejectJobDetails, {"booking_id": bookingId});
  }

  void onBookingOfferAccepted(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.bookingOfferAccepted, handler);
  }

  void onOfferCancelled(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.offerCancelled, handler);
  }

  void onApproveBookingDetails(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.approveBookingDetails, handler);
  }

  void onArtisanArrived(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.artisanArrived, handler);
  }

  void onJobAlreadyConfirmed(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.jobDetailsAlreadyConfirmed, handler);
  }

  void onArtisanLocationUpdate(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.artisanLocationUpdate, handler);
  }

  void onJobStarted(void Function(dynamic) handler) {
    _socket.on(CustomerSocketListenEvents.jobStarted, handler);
  }

  void onError(void Function(dynamic) handler) {
    _socket.on('error', handler);
  }
}
