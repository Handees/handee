import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:handees/shared/res/uri.dart';
import 'package:handees/shared/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PaymentRepository {
  static PaymentRepository? _instance;
  PaymentRepository._();

  factory PaymentRepository() {
    return _instance ??= PaymentRepository._();
  }

  Future<String> getAccessCode({
    required String email,
    required int amount,
  }) async {
    String token = AuthService.instance.token;

    final response = await http.post(
      AppUris.paymentsUri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'access-token': token,
      },
      body: jsonEncode(
        {
          'email': email,
          'amount': amount,
        },
      ),
    );

    debugPrint('AccessCode request response: ${response.body}');

    return jsonDecode(response.body)['data']['access_code'];
  }
}
