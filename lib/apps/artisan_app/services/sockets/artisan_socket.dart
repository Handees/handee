import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/apps/artisan_app/features/home/providers/artisan-location.provider.dart';
import 'package:handees/apps/artisan_app/services/sockets/artisan_socket_events.dart';
import 'package:handees/apps/customer_app/features/home/providers/user.provider.dart';
import 'package:handees/shared/data/handees/handee_approval.dart';
import 'package:handees/shared/data/handees/job_category.dart';
import 'package:handees/shared/res/uri.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/utils/utils.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final artisanSocketProvider =
    StateNotifierProvider<ArtisanSocketNotifier, io.Socket>(
        (ref) => ArtisanSocketNotifier(ref));

class ArtisanSocketNotifier extends StateNotifier<io.Socket> {
  StateNotifierProviderRef<ArtisanSocketNotifier, io.Socket> ref;

  ArtisanSocketNotifier(this.ref)
      : super(io.io(
          AppUris.artisanSocketUri.toString(),
          io.OptionBuilder()
              .setTransports(['websocket'])
              .setAuth({"access_token": AuthService.instance.token})
              .disableAutoConnect()
              .build(),
        )) {
    state.onAny((event, data) {
      dPrint('Artisan update any: Event($event) $data');
      if (event == "connect_error") {
        connectArtisan();
      }
    });
    state.onDisconnect((_) => dPrint("Socket Disconnected"));
    state.onConnect((_) async {
      dPrint("Socket Connected");

      // When socket first connects, immediately send the user's current location

      final location = ref.read(locationProvider);
      updateArtisanLocation(
          location, ref.read(userProvider).artisanProfile!.jobCategory);
    });
  }

  void connectArtisan() => state.connect();
  void disconnectArtisan() => state.disconnect();

  void updateArtisanLocation(LocationData location, JobCategory? jobCategory) {
    if (jobCategory == null) {
      throw 'updateArtisanLocation called on for an artisan that has no jobCategory';
    }

    dPrint(
        "lat:${location.latitude} , lon:${location.longitude} emitted through sockets");
    // state.emit(
    //   ArtisanSocketEmitEvents.locationUpdate,
    //   {
    //     "lat": 6.548281268456966,
    //     "lon": 3.332248000980724,
    //     "job_category": jobCategory.id,
    //   },
    // );

    //TODO: This is the correct code but we're using the above to test things out
    state.emit(
      ArtisanSocketEmitEvents.locationUpdate,
      {
        "lat": location.latitude,
        "lon": location.longitude,
        "artisan_id": AuthService.instance.user.uid,
        "job_category": "carpentry",
      },
    );
  }

  void emitArtisanArrival(String bookingId) {
    state.emit(
      ArtisanSocketEmitEvents.artisanArrived,
      {
        "booking_id": bookingId,
      },
    );
  }

  void acceptOffer(String bookingId, LocationData location) {
    state.emit(ArtisanSocketEmitEvents.acceptOffer, {
      "booking_id": bookingId,
      "artisan_lat": location.latitude,
      "artisan_lon": location.longitude,
    });
  }

  void cancelOffer(String bookingId) {
    state.emit(ArtisanSocketEmitEvents.cancelOffer, {
      "booking_id": bookingId,
    });
  }

  void requestCustomerApproval(HandeeApproval approval) {
    state.emit(
        ArtisanSocketEmitEvents.requestCustomerApproval, approval.toJson());
  }

  void registerEventHandler(String event, Function eventHandler) {
    state.on(event, (data) {
      eventHandler(data);
    });
  }

  Stream<T> onArtisanEvent<T>(String event) {
    if (state.disconnected) throw const SocketException.closed();

    final controller = StreamController<T>();

    state.on(event, (data) {
      dPrint(data);
      controller.add(data);
    });

    return controller.stream;
  }
}
