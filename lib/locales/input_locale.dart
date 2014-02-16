part of keypress;

class InputLocale {
    final String
        ID;

    final Map<int, String>
        KEYCODE_MAP;
    const Map<String, String>
        SHIFTED_KEYS;

    const Set<String>
        VALID_KEYS;

    InputLocale(this.ID, {this.KEYCODE_MAP, this.SHIFTED_KEYS}) {
        VALID_KEYS = KEYCODE_MAP.values.toSet()
                                        ..addAll(SHIFTED_KEYS.values);
    }
}

// TODO: provide method to detect Locale