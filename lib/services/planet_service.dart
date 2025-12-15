import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planet_model.dart';

class PlanetService {
  final _db = FirebaseFirestore.instance;

  Future<List<PlanetModel>> getAllPlanets() async {
    final snapshot = await _db
        .collection('planets')
        .orderBy('orderFromSun')
        .get();

    return snapshot.docs
        .map((doc) => PlanetModel.fromFirestore(doc.data()))
        .toList();
  }
}
