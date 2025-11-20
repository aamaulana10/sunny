class ConditionHelper {
  static final Map<int, Map<String, String>> _map = {
    0: {
      "description": "Langit Cerah",
      "icon": "asset/image/clearsky.png",
    },
    1: {
      "description": "Cerah Berawan",
      "icon": "asset/image/fewclouds.png",
    },
    2: {
      "description": "Sebagian Berawan",
      "icon": "asset/image/scatteredclouds.png",
    },
    3: {
      "description": "Mendung",
      "icon": "asset/image/brokenclouds.png",
    },
    45: {
      "description": "Berkabut",
      "icon": "asset/image/mist.png",
    },
    48: {
      "description": "Berkabut",
      "icon": "asset/image/mist.png",
    },
    51: {
      "description": "Gerimis Ringan",
      "icon": "asset/image/rain.png",
    },
    53: {
      "description": "Gerimis Sedang",
      "icon": "asset/image/rain.png",
    },
    55: {
      "description": "Gerimis Lebat",
      "icon": "asset/image/rain.png",
    },
    61: {
      "description": "Hujan Ringan",
      "icon": "asset/image/rain.png",
    },
    63: {
      "description": "Hujan Sedang",
      "icon": "asset/image/showerrain.png",
    },
    65: {
      "description": "Hujan Lebat",
      "icon": "asset/image/showerrain.png",
    },
    80: {
      "description": "Hujan Lokal",
      "icon": "asset/image/showerrain.png",
    },
    81: {
      "description": "Hujan Lebat Lokal",
      "icon": "asset/image/showerrain.png",
    },
    82: {
      "description": "Hujan Sangat Lebat",
      "icon": "asset/image/showerrain.png",
    },
    95: {
      "description": "Badai Petir",
      "icon": "asset/image/thunderstorm.png",
    },
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
}
