import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/shared/data/handees/job_category.dart';
import 'package:handees/shared/res/constants.dart';
import 'package:handees/shared/utils/utils.dart';

import 'package:http/http.dart' as http;

import 'sockets/customer_socket.dart';

final bookingServiceProvider =
    Provider((ref) => BookingService._(ref.watch(customerSocketProvider)));

class BookingService {
  BookingService._(this._customerSocket);

  final CustomerSocket _customerSocket;

  Future<String> bookService({
    required String token,
    required double lat,
    required double lon,
    required JobCategory category,
  }) async {
    final future = http.post(
      Uri.http(
        AppConstants.url,
        '/api/bookings/',
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'access-token': token,
      },
      body: jsonEncode(
        {
          'lat': lat,
          'lon': lon,
          //TODO: Hook this up with the payment methods screen
          'payment_method': "cash",
          'job_category': category.id,
        },
      ),
    );

    final response = await future;
    dPrint(response.body);

    final json = jsonDecode(response.body);
    final bookingId = json['data']['booking_id'];

    return bookingId;
  }

  void cancelOffer(String bookingId) {
    _customerSocket.cancelOffer(bookingId);
  }

  void confirmJobDetails({
    required String bookingId,
    required bool isContract,
    required String settlementType,
    required double settlementAmount,
    required int duration,
    required String durationUnit,
  }) {
    dPrint('Sbmitting');
    _customerSocket.confirmJobDetails(
      bookingId: bookingId,
      isContract: isContract,
      settlementType: settlementType,
      settlementAmount: settlementAmount,
      duration: duration,
      durationUnit: durationUnit,
    );
  }

  void rejectJobDetails(String bookingId) {
    _customerSocket.rejectJobDetails(bookingId);
  }

  //TODO shouldn't be dynamic
  getBookings(String token) async {
    await http.get(
      Uri.https(
        AppConstants.url,
        '/user/bookings',
      ),
      headers: {
        // HttpHeaders.contentTypeHeader: 'application/json',
        'access-token': token,
      },
    );
  }
}
