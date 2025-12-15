// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class DBService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   Future<void> insertAllPlanets() async {
//     final db = FirebaseFirestore.instance;
//
//     final List<Map<String, dynamic>> planets = [
//       // ================= MERCURY =================
//       {
//         "planetId": "mercury",
//         "nameEn": "Mercury",
//         "nameVi": "Sao Thủy",
//         "orderFromSun": 1,
//         "planetType": "terrestrial",
//         "shortDescription": "Hành tinh gần Mặt Trời nhất",
//         "overview": "Sao Thủy là hành tinh nhỏ nhất và gần Mặt Trời nhất trong hệ Mặt Trời. Do nằm rất gần Mặt Trời, Sao Thủy có sự chênh lệch nhiệt độ cực lớn giữa ngày và đêm, với nhiệt độ ban ngày có thể vượt quá 400°C trong khi ban đêm có thể giảm xuống dưới -170°C. Hành tinh này không có khí quyển dày để giữ nhiệt, khiến bề mặt của nó chịu ảnh hưởng trực tiếp từ bức xạ Mặt Trời. Sao Thủy quay rất chậm quanh trục của mình, một ngày trên Sao Thủy kéo dài hơn cả một năm của chính nó. Bề mặt Sao Thủy chứa nhiều miệng va chạm do thiên thạch, tương tự như Mặt Trăng, cho thấy hành tinh này đã trải qua rất ít thay đổi địa chất trong hàng tỷ năm.",
//         "physical": {
//           "radiusKm": 2440,
//           "massKg": 3.30e23,
//           "gravity": 3.7,
//           "density": 5.43,
//           "temperatureAvgC": 167
//         },
//         "orbit": {
//           "distanceFromSunKm": 57900000,
//           "orbitalPeriodDays": 88,
//           "rotationPeriodHours": 1407.6,
//           "axialTiltDeg": 0.03
//         },
//         "atmosphere": {
//           "hasAtmosphere": false,
//           "mainGases": []
//         },
//         "moons": {
//           "count": 0,
//           "names": []
//         },
//         "specialFeatures": ["Nhiệt độ chênh lệch lớn"],
//         "media": {
//           "image2d": "assets/images/mercury.png",
//           "model3d": "assets/models/mercury.glb"
//         }
//       },
//
//       // ================= VENUS =================
//       {
//         "planetId": "venus",
//         "nameEn": "Venus",
//         "nameVi": "Sao Kim",
//         "orderFromSun": 2,
//         "planetType": "terrestrial",
//         "shortDescription": "Hành tinh nóng nhất",
//         "overview": "Sao Kim là hành tinh thứ hai tính từ Mặt Trời và có kích thước gần tương đương với Trái Đất, nên thường được gọi là hành tinh song sinh của Trái Đất. Tuy nhiên, môi trường trên Sao Kim lại vô cùng khắc nghiệt do hiệu ứng nhà kính cực mạnh. Khí quyển của Sao Kim rất dày, chủ yếu gồm khí carbon dioxide, giữ lại nhiệt lượng từ Mặt Trời và khiến nhiệt độ bề mặt luôn ở mức rất cao, trung bình khoảng 460°C. Sao Kim có áp suất khí quyển lớn gấp hơn 90 lần so với Trái Đất, đủ để nghiền nát hầu hết các vật thể. Đặc biệt, Sao Kim quay ngược chiều so với hầu hết các hành tinh khác và có chu kỳ tự quay rất chậm, khiến một ngày trên Sao Kim dài hơn cả một năm của hành tinh này.",
//         "physical": {
//           "radiusKm": 6052,
//           "massKg": 4.87e24,
//           "gravity": 8.87,
//           "density": 5.24,
//           "temperatureAvgC": 464
//         },
//         "orbit": {
//           "distanceFromSunKm": 108200000,
//           "orbitalPeriodDays": 225,
//           "rotationPeriodHours": -5832.5,
//           "axialTiltDeg": 177.4
//         },
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Carbon Dioxide", "Nitrogen"]
//         },
//         "moons": {
//           "count": 0,
//           "names": []
//         },
//         "specialFeatures": ["Hiệu ứng nhà kính cực mạnh"],
//         "media": {
//           "image2d": "assets/images/venus.png",
//           "model3d": "assets/models/venus.glb"
//         }
//       },
//
//       // ================= EARTH =================
//       {
//         "planetId": "earth",
//         "nameEn": "Earth",
//         "nameVi": "Trái Đất",
//         "orderFromSun": 3,
//         "planetType": "terrestrial",
//         "shortDescription": "Hành tinh duy nhất có sự sống",
//         "overview": "Trái Đất là hành tinh thứ ba tính từ Mặt Trời và là hành tinh duy nhất trong hệ Mặt Trời được biết đến có sự sống. Hành tinh này có điều kiện môi trường đặc biệt phù hợp cho sự sống nhờ sự tồn tại của nước ở dạng lỏng, khí quyển giàu oxy và từ trường bảo vệ bề mặt khỏi bức xạ có hại từ không gian. Trái Đất có cấu trúc địa chất năng động với các mảng kiến tạo, núi lửa và động đất, góp phần điều hòa khí hậu trong thời gian dài. Độ nghiêng trục quay của Trái Đất tạo ra các mùa trong năm, trong khi chu kỳ tự quay và chuyển động quanh Mặt Trời giúp duy trì nhịp sinh học ổn định cho các sinh vật sống.",
//         "physical": {
//           "radiusKm": 6371,
//           "massKg": 5.97e24,
//           "gravity": 9.8,
//           "density": 5.51,
//           "temperatureAvgC": 15
//         },
//         "orbit": {
//           "distanceFromSunKm": 149600000,
//           "orbitalPeriodDays": 365,
//           "rotationPeriodHours": 24,
//           "axialTiltDeg": 23.5
//         },
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Nitrogen", "Oxygen"]
//         },
//         "moons": {
//           "count": 1,
//           "names": ["Moon"]
//         },
//         "specialFeatures": ["Có sự sống", "Có nước lỏng"],
//         "media": {
//           "image2d": "assets/images/earth.png",
//           "model3d": "assets/models/earth.glb"
//         }
//       },
//
//       // ================= MARS =================
//       {
//         "planetId": "mars",
//         "nameEn": "Mars",
//         "nameVi": "Sao Hỏa",
//         "orderFromSun": 4,
//         "planetType": "terrestrial",
//         "shortDescription": "Hành tinh đỏ",
//         "overview": "Sao Hỏa là hành tinh thứ tư tính từ Mặt Trời, thường được gọi là Hành tinh Đỏ do bề mặt giàu oxit sắt. Các nghiên cứu khoa học cho thấy trong quá khứ, Sao Hỏa từng có nước lỏng chảy trên bề mặt, thể hiện qua các dấu vết của sông cổ, hồ và khoáng chất hình thành trong môi trường nước. Tuy nhiên, theo thời gian, hành tinh này đã mất phần lớn khí quyển và từ trường, khiến nước bốc hơi hoặc đóng băng. Hiện nay, Sao Hỏa có khí hậu lạnh, khô và có các cơn bão bụi lớn bao phủ toàn bộ hành tinh. Sao Hỏa là mục tiêu quan trọng trong các sứ mệnh thám hiểm không gian nhằm tìm kiếm dấu hiệu của sự sống trong quá khứ.",
//         "physical": {
//           "radiusKm": 3390,
//           "massKg": 6.42e23,
//           "gravity": 3.71,
//           "density": 3.93,
//           "temperatureAvgC": -63
//         },
//         "orbit": {
//           "distanceFromSunKm": 227900000,
//           "orbitalPeriodDays": 687,
//           "rotationPeriodHours": 24.6,
//           "axialTiltDeg": 25.2
//         },
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Carbon Dioxide"]
//         },
//         "moons": {
//           "count": 2,
//           "names": ["Phobos", "Deimos"]
//         },
//         "specialFeatures": ["Có bão bụi lớn"],
//         "media": {
//           "image2d": "assets/images/mars.png",
//           "model3d": "assets/models/mars.glb"
//         }
//       },
//
//       // ================= JUPITER =================
//       {
//         "planetId": "jupiter",
//         "nameEn": "Jupiter",
//         "nameVi": "Sao Mộc",
//         "orderFromSun": 5,
//         "planetType": "gas_giant",
//         "shortDescription": "Hành tinh lớn nhất",
//         "overview": "Sao Mộc là hành tinh lớn nhất trong hệ Mặt Trời và thuộc nhóm hành tinh khí khổng lồ. Hành tinh này chủ yếu được cấu tạo từ hydro và heli, không có bề mặt rắn như các hành tinh đất đá. Sao Mộc nổi bật với các dải mây nhiều màu sắc và Vết Đỏ Lớn – một cơn bão khổng lồ đã tồn tại hàng trăm năm. Nhờ khối lượng rất lớn, Sao Mộc có lực hấp dẫn mạnh, đóng vai trò như một lá chắn bảo vệ các hành tinh bên trong khỏi nhiều thiên thạch và sao chổi. Sao Mộc có hệ thống vệ tinh phong phú, trong đó các mặt trăng lớn như Io, Europa, Ganymede và Callisto là những đối tượng nghiên cứu quan trọng trong việc tìm kiếm khả năng tồn tại sự sống.",
//         "physical": {
//           "radiusKm": 69911,
//           "massKg": 1.90e27,
//           "gravity": 24.8,
//           "density": 1.33,
//           "temperatureAvgC": -108
//         },
//         "orbit": {
//           "distanceFromSunKm": 778500000,
//           "orbitalPeriodDays": 4333,
//           "rotationPeriodHours": 9.9,
//           "axialTiltDeg": 3.1
//         },
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Hydrogen", "Helium"]
//         },
//         "moons": {
//           "count": 79,
//           "names": ["Io", "Europa", "Ganymede", "Callisto"]
//         },
//         "specialFeatures": ["Vết Đỏ Lớn"],
//         "media": {
//           "image2d": "assets/images/jupiter.png",
//           "model3d": "assets/models/jupiter.glb"
//         }
//       },
//
//       // ================= SATURN =================
//       {
//         "planetId": "saturn",
//         "nameEn": "Saturn",
//         "nameVi": "Sao Thổ",
//         "orderFromSun": 6,
//         "planetType": "gas_giant",
//         "shortDescription": "Hành tinh có vành đai",
//         "overview": "Sao Thổ là hành tinh thứ sáu tính từ Mặt Trời và thuộc nhóm hành tinh khí khổng lồ. Hành tinh này nổi bật nhất với hệ thống vành đai rộng lớn và phức tạp, được cấu tạo từ hàng tỷ mảnh băng và đá quay quanh hành tinh. Giống như Sao Mộc, Sao Thổ chủ yếu được cấu tạo từ hydro và heli và không có bề mặt rắn rõ ràng. Do có mật độ rất thấp, Sao Thổ là hành tinh duy nhất trong hệ Mặt Trời có thể nổi trên nước nếu tồn tại một đại dương đủ lớn. Sao Thổ sở hữu nhiều vệ tinh tự nhiên, trong đó Titan – mặt trăng lớn nhất – có khí quyển dày và được xem là một trong những đối tượng tiềm năng cho nghiên cứu về sự sống ngoài Trái Đất.",
//         "physical": {
//           "radiusKm": 58232,
//           "massKg": 5.68e26,
//           "gravity": 10.4,
//           "density": 0.69,
//           "temperatureAvgC": -139
//         },
//         "orbit": {
//           "distanceFromSunKm": 1434000000,
//           "orbitalPeriodDays": 10759,
//           "rotationPeriodHours": 10.7,
//           "axialTiltDeg": 26.7
//         },
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Hydrogen", "Helium"]
//         },
//         "moons": {
//           "count": 83,
//           "names": ["Titan", "Enceladus"]
//         },
//         "specialFeatures": ["Vành đai lớn nhất"],
//         "media": {
//           "image2d": "assets/images/saturn.png",
//           "model3d": "assets/models/saturn.glb"
//         }
//       },
//       // ================= URANUS =================
//       {
//         "planetId": "uranus",
//         "nameEn": "Uranus",
//         "nameVi": "Sao Thiên Vương",
//         "orderFromSun": 7,
//         "planetType": "ice_giant",
//
//         "shortDescription": "Hành tinh nghiêng trục kỳ lạ",
//         "overview": "Sao Thiên Vương là hành tinh thứ bảy tính từ Mặt Trời và thuộc nhóm hành tinh khí băng. Điểm đặc biệt nhất của Sao Thiên Vương là trục quay nghiêng gần 98 độ so với mặt phẳng quỹ đạo, khiến hành tinh này dường như quay nằm ngang. Do đặc điểm này, mỗi cực của Sao Thiên Vương có thể trải qua nhiều thập kỷ liên tục trong ánh sáng Mặt Trời hoặc trong bóng tối hoàn toàn, tạo ra các mùa cực kỳ khác thường. Khí quyển của Sao Thiên Vương chủ yếu gồm hydro, heli và methane, trong đó methane hấp thụ ánh sáng đỏ và phản xạ ánh sáng xanh, tạo nên màu xanh nhạt đặc trưng của hành tinh. Sao Thiên Vương có nhiệt độ rất thấp và là một trong những hành tinh lạnh nhất trong hệ Mặt Trời.",
//
//         "physical": {
//           "radiusKm": 25362,
//           "massKg": 8.68e25,
//           "gravity": 8.7,
//           "density": 1.27,
//           "temperatureAvgC": -224
//         },
//
//         "orbit": {
//           "distanceFromSunKm": 2871000000,
//           "orbitalPeriodDays": 30687,
//           "rotationPeriodHours": -17.2,
//           "axialTiltDeg": 97.8
//         },
//
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Hydrogen", "Helium", "Methane"]
//         },
//
//         "moons": {
//           "count": 27,
//           "names": ["Titania", "Oberon", "Umbriel", "Ariel", "Miranda"]
//         },
//
//         "specialFeatures": [
//           "Trục quay nghiêng gần 98 độ",
//           "Nhiệt độ cực thấp"
//         ],
//
//         "media": {
//           "image2d": "assets/images/uranus.png",
//           "model3d": "assets/models/uranus.glb"
//         }
//       },
//       // ================= NEPTUNE =================
//       {
//         "planetId": "neptune",
//         "nameEn": "Neptune",
//         "nameVi": "Sao Hải Vương",
//         "orderFromSun": 8,
//         "planetType": "ice_giant",
//
//         "shortDescription": "Hành tinh xa nhất và có gió mạnh nhất",
//         "overview": "Sao Hải Vương là hành tinh thứ tám và xa Mặt Trời nhất trong hệ Mặt Trời, thuộc nhóm hành tinh khí băng. Mặc dù nằm ở khoảng cách rất xa, Sao Hải Vương lại có khí quyển vô cùng năng động với tốc độ gió mạnh nhất được ghi nhận trong hệ Mặt Trời, có thể vượt quá 2.000 km/h. Khí quyển của hành tinh này chủ yếu gồm hydro, heli và methane, trong đó methane hấp thụ ánh sáng đỏ và phản xạ ánh sáng xanh, tạo nên màu xanh đậm đặc trưng. Sao Hải Vương có nhiệt độ rất thấp và chịu ảnh hưởng mạnh từ các cơn bão lớn, tiêu biểu là Vết Tối Lớn – một hệ thống bão tương tự Vết Đỏ Lớn trên Sao Mộc. Hành tinh này cũng sở hữu nhiều vệ tinh tự nhiên, trong đó Triton là mặt trăng lớn nhất với quỹ đạo quay ngược chiều so với hành tinh.",
//
//         "physical": {
//           "radiusKm": 24622,
//           "massKg": 1.02e26,
//           "gravity": 11.0,
//           "density": 1.64,
//           "temperatureAvgC": -214
//         },
//
//         "orbit": {
//           "distanceFromSunKm": 4495000000,
//           "orbitalPeriodDays": 60190,
//           "rotationPeriodHours": 16.1,
//           "axialTiltDeg": 28.3
//         },
//
//         "atmosphere": {
//           "hasAtmosphere": true,
//           "mainGases": ["Hydrogen", "Helium", "Methane"]
//         },
//
//         "moons": {
//           "count": 14,
//           "names": ["Triton", "Nereid"]
//         },
//
//         "specialFeatures": [
//           "Tốc độ gió mạnh nhất hệ Mặt Trời",
//           "Màu xanh đậm đặc trưng"
//         ],
//
//         "media": {
//           "image2d": "assets/images/neptune.png",
//           "model3d": "assets/models/neptune.glb"
//         }
//       },
//
//     ];
//
//     for (final planet in planets) {
//       await db
//           .collection("planets")
//           .doc(planet["planetId"])
//           .set({
//         ...planet,
//         "createdAt": FieldValue.serverTimestamp(),
//       });
//     }
//
//     print("✅ Insert ALL planets success");
//   }
// }