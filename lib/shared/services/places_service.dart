import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handees/shared/data/places/place_model.dart';
import 'package:handees/shared/data/places/places_repository.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class PlacesService {
  final location = Location.instance;
  WidgetRef? ref;
  final PlacesRepository placesRepository;
  PlacesService._(this.placesRepository);

  static final instance = PlacesService._(PlacesRepository());

  final sessionToken = const Uuid().v4();

  /// Get Predictions based on the specified input
  Future<List<PlaceModel>> getPredictions(String input) =>
      placesRepository.getPredictions(input, sessionToken);

  Future<LocationData> getLocation() async {
    final locationData = await location.getLocation();
    return locationData;
  }
}
