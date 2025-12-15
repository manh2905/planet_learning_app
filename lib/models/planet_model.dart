class PhysicalInfo {
  final double radiusKm;
  final double massKg;
  final double gravity;
  final double density;
  final double temperatureAvgC;

  PhysicalInfo({
    required this.radiusKm,
    required this.massKg,
    required this.gravity,
    required this.density,
    required this.temperatureAvgC,
  });

  factory PhysicalInfo.fromMap(Map<String, dynamic> map) {
    return PhysicalInfo(
      radiusKm: (map['radiusKm'] as num).toDouble(),
      massKg: (map['massKg'] as num).toDouble(),
      gravity: (map['gravity'] as num).toDouble(),
      density: (map['density'] as num).toDouble(),
      temperatureAvgC: (map['temperatureAvgC'] as num).toDouble(),
    );
  }
}

class OrbitInfo {
  final double distanceFromSunKm;
  final double orbitalPeriodDays;
  final double rotationPeriodHours;
  final double axialTiltDeg;

  OrbitInfo({
    required this.distanceFromSunKm,
    required this.orbitalPeriodDays,
    required this.rotationPeriodHours,
    required this.axialTiltDeg,
  });

  factory OrbitInfo.fromMap(Map<String, dynamic> map) {
    return OrbitInfo(
      distanceFromSunKm: (map['distanceFromSunKm'] as num).toDouble(),
      orbitalPeriodDays: (map['orbitalPeriodDays'] as num).toDouble(),
      rotationPeriodHours: (map['rotationPeriodHours'] as num).toDouble(),
      axialTiltDeg: (map['axialTiltDeg'] as num).toDouble(),
    );
  }
}


class AtmosphereInfo {
  final bool hasAtmosphere;
  final List<String> mainGases;

  AtmosphereInfo({
    required this.hasAtmosphere,
    required this.mainGases,
  });

  factory AtmosphereInfo.fromMap(Map<String, dynamic> map) {
    return AtmosphereInfo(
      hasAtmosphere: map['hasAtmosphere'] ?? false,
      mainGases: List<String>.from(map['mainGases'] ?? []),
    );
  }
}


class MoonInfo {
  final int count;
  final List<String> names;

  MoonInfo({
    required this.count,
    required this.names,
  });

  factory MoonInfo.fromMap(Map<String, dynamic> map) {
    return MoonInfo(
      count: map['count'] ?? 0,
      names: List<String>.from(map['names'] ?? []),
    );
  }
}


class MediaInfo {
  final String image2d;
  final String model3d;

  MediaInfo({
    required this.image2d,
    required this.model3d,
  });

  factory MediaInfo.fromMap(Map<String, dynamic> map) {
    return MediaInfo(
      image2d: map['image2d'],
      model3d: map['model3d'],
    );
  }
}


class PlanetModel {
  final String planetId;
  final String nameEn;
  final String nameVi;
  final int orderFromSun;
  final String planetType;
  final String shortDescription;
  final String overview;

  final PhysicalInfo physical;
  final OrbitInfo orbit;
  final AtmosphereInfo atmosphere;
  final MoonInfo moons;
  final List<String> specialFeatures;
  final MediaInfo media;

  PlanetModel({
    required this.planetId,
    required this.nameEn,
    required this.nameVi,
    required this.orderFromSun,
    required this.planetType,
    required this.shortDescription,
    required this.overview,
    required this.physical,
    required this.orbit,
    required this.atmosphere,
    required this.moons,
    required this.specialFeatures,
    required this.media,
  });

  factory PlanetModel.fromFirestore(Map<String, dynamic> data) {
    return PlanetModel(
      planetId: data['planetId'],
      nameEn: data['nameEn'],
      nameVi: data['nameVi'],
      orderFromSun: data['orderFromSun'],
      planetType: data['planetType'],
      shortDescription: data['shortDescription'],
      overview: data['overview'],

      physical: PhysicalInfo.fromMap(data['physical']),
      orbit: OrbitInfo.fromMap(data['orbit']),
      atmosphere: AtmosphereInfo.fromMap(data['atmosphere']),
      moons: MoonInfo.fromMap(data['moons']),
      specialFeatures: List<String>.from(data['specialFeatures']),
      media: MediaInfo.fromMap(data['media']),
    );
  }
}
