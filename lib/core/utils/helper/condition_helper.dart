class ConditionHelper {
  static final Map<int, Map<String, String>> _map = {
    0: {"description": "Langit Cerah", "icon": "asset/image/clearsky.png"},
    1: {"description": "Cerah Berawan", "icon": "asset/image/fewclouds.png"},
    2: {
      "description": "Sebagian Berawan",
      "icon": "asset/image/scatteredclouds.png",
    },
    3: {"description": "Mendung", "icon": "asset/image/brokenclouds.png"},
    45: {"description": "Berkabut", "icon": "asset/image/mist.png"},
    48: {"description": "Berkabut", "icon": "asset/image/mist.png"},
    51: {"description": "Gerimis Ringan", "icon": "asset/image/rain.png"},
    53: {"description": "Gerimis Sedang", "icon": "asset/image/rain.png"},
    55: {"description": "Gerimis Lebat", "icon": "asset/image/rain.png"},
    61: {"description": "Hujan Ringan", "icon": "asset/image/rain.png"},
    63: {"description": "Hujan Sedang", "icon": "asset/image/showerrain.png"},
    65: {"description": "Hujan Lebat", "icon": "asset/image/showerrain.png"},
    80: {"description": "Hujan Lokal", "icon": "asset/image/showerrain.png"},
    81: {
      "description": "Hujan Lebat Lokal",
      "icon": "asset/image/showerrain.png",
    },
    82: {
      "description": "Hujan Sangat Lebat",
      "icon": "asset/image/showerrain.png",
    },
    95: {"description": "Badai Petir", "icon": "asset/image/thunderstorm.png"},
    96: {
      "description": "Badai Petir + Hujan Es",
      "icon": "asset/image/thunderstorm.png",
    },
    99: {
      "description": "Badai Petir + Hujan Es",
      "icon": "asset/image/thunderstorm.png",
    },
  };

  static Map<String, String> getCondition(int? code) {
    if (code == null) return {"description": "-", "icon": ""};
    return _map[code] ?? {"description": "-", "icon": ""};
  }

  static String? getDescription(int? code) {
    return getCondition(code)["description"];
  }

  static String? getIcon(int? code) {
    return getCondition(code)["icon"];
  }

  static String getMoodMessage(int? code) {
    if (code == null) return "Tetap semangat!";
    if (code == 0) return "Langit cerah! Cocok untuk aktivitas luar 😊";
    if (code == 1 || code == 2) {
      return "Berawan tipis, tetap nyaman buat jalan santai.";
    }
    if (code == 3) return "Mendung, mungkin lebih nyaman di dalam ruangan.";
    if (code == 45 || code == 48) return "Berkabut, hati-hati saat berkendara.";
    if ([51, 53, 55].contains(code)) return "Gerimis, siapkan jaket tipis ya.";
    if ([61, 63, 65, 80, 81, 82].contains(code)) {
      return "Hujan, payungmu jangan lupa! ☔";
    }
    if ([95, 96, 99].contains(code)) {
      return "Badai petir, aman di rumah lebih baik.";
    }
    return "Cuaca berubah-ubah, tetap jaga kesehatan!";
  }

  static String getInsight({int? code, num? uv, int? rainProb, double? wind}) {
    if ((uv ?? 0) >= 6) return "UV tinggi — sunscreen dulu ya!";
    if ((rainProb ?? 0) >= 60) {
      return "Bawa payung bro, bakal hujan bentar lagi 😭";
    }
    if ((wind ?? 0) >= 30) return "Angin kencang — stay safe!";
    if (code == 0) return "Energetic day 🔥";
    if ([61, 63, 65, 80, 81, 82].contains(code)) return "Cozy weather ☔";
    if ([1, 2, 3].contains(code)) return "Soft mood 😌";
    return "Nikmati harimu ✨";
  }

  static String getBadge(int streak) {
    if (streak >= 7) return "Rain Master";
    if (streak >= 4) return "Sun Hunter";
    if (streak >= 1) return "Weather Rookie";
    return "";
  }
}
