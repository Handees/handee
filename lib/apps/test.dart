import 'package:flutter/material.dart';
import 'package:handees/shared/res/constants.dart';
import 'package:handees/shared/res/uri.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:handees/shared/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // Future<void> submit() async {

  final site = AppConstants.url;
  // late String token;

  io.Socket rootSocket = io.io(
    AppUris.rootUri.toString(),
    io.OptionBuilder()
        .setAuth({'access_token': AuthService.instance.token}).setTransports(
            ['websocket']).build(),
  );

// Dart client
  // io.Socket customerSocket = io.io(
  //   AppUris.customerSocketUri.toString(),
  //   io.OptionBuilder().setTransports(
  //       ['websocket']).build(),
  // );

  io.Socket chatSocket = io.io(AppUris.chatSocketUri.toString(),
      io.OptionBuilder().setTransports(['websocket']).build());

  final customerSocket = io.io(
    AppUris.customerSocketUri.toString(),
    io.OptionBuilder()
        .setAuth({'access_token': AuthService.instance.token}).setTransports(
            ['websocket']).build(),
  );

  String? bookingId;
  String? artisanId;

  @override
  void initState() {
    dPrint("Uri is ${AppUris.customerSocketUri.toString()}");

    customerSocket.connect();

    customerSocket.onAny((event, data) {
      dPrint('Customer update hany: Event($event) $data');
    });

    // rootSocket.connect();
    rootSocket.onAny((event, data) {
      dPrint('Root update any: Event($event) $data');
    });

    chatSocket.connect();

    // customerSocket.onConnect((_) {
    //   dPrint('customer connected');
    // });
    // chatSocket.onConnect((_) {
    //   print('Chat connected');
    // });
    // socket.on('event', (data) => print('Event $data'));
    // customerSocket.onDisconnect((_) => print('client disconnected'));
    chatSocket.onDisconnect((_) => debugPrint('Chat disconnected'));

    // customerSocket.on('msg', (data) {
    //   print('Customer update: $data');

    //   // artisanId = data['artisan_id'];
    // });

    chatSocket.on('msg', (data) {
      dPrint('Chat update: $data');
    });

    chatSocket.onAny((event, data) {
      dPrint('Chat update any: Event($event) $data');
    });

    super.initState();
  }

  late String vId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          runSpacing: 20,
          spacing: 20,
          children: [
            InkWell(
              onTap: () {
                // BookingService.instance.confirmJobDetails(
                //   bookingId: '960103e8a91e4b8ca28b93fac0767936',
                //   isContract: false,
                //   settlementType: "NEGOTIATION",
                //   settlementAmount: 550.0,
                //   duration: 4,
                //   durationUnit: "days",
                // );

                customerSocket.emit('confirm_job_details', {
                  'booking_id': 'b62e7fb7318a4b08a5289e00679d0974',
                  'is_contract': false,
                  'settlement': {
                    'type': 'NEGOTIATION',
                    'amount': 550.0,
                  },
                  'duration': 4,
                  'duration_unit': 'days',
                });

                customerSocket.emit('reject_job_details');
                dPrint("Sending");
              },
              child: Ink(
                height: 80,
                width: 80,
                color: Colors.blue,
              ),
            ),
            InkWell(
              onTap: () async {
                // BookingService.instance.bookService(
                //   token: AuthService.instance.token,
                //   onBooked: (bookingId) {
                //     print(bookingId);

                //     BookingService.instance.confirmJobDetails(
                //       bookingId: bookingId,
                //       isContract: true,
                //       settlementType: "negotiation",
                //       settlementAmount: 0.0,
                //       duration: 2,
                //       durationUnit: "days",
                //     );

                //     chatSocket.emit('join_chat', {'booking_id': bookingId});
                //     print('joined_chat');
                //   },
                //   category: JobCategory.carpentry,
                //   lat: 6.517871336509268,
                //   lon: 3.399740067230001,
                // );
              },
              child: Ink(
                height: 80,
                width: 80,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
