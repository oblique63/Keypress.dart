library keypress;

import 'dart:html';

part 'key_maps.dart';
part 'key_combo.dart';

// TODO: Make _registered_combos static, and turn the como initializer methods into constructors
// TODO: Support option to consider NumberPad input as regular numerical inputs
//        (i.e. don't require distinguishing the keycodes for the NumberPad)

class Keypress {
    bool
        force_event_defaults = false,
        suppress_event_defaults = false;
    int
        sequence_delay = 800;

    List<KeyCombo>
        _registered_combos = [],
        _active_combos = [];
    List
        _keys_down = [];
    List
        _sequence = [];
    int
        _sequence_timer = null;
    bool
        _prevent_capture = false;
    static Keypress
        _singleton = null;

    factory
    Keypress() {
        if (_singleton == null) {
            _singleton = new Keypress._init();
        }
        return _singleton;
    }

    Keypress._init() {
        if (window.navigator.userAgent.contains("Opera")) {
            // TODO: find a better way to do this, so that _keycode_dictionary can remain a 'const'
            _keycode_map[17] = 'cmd';
        }
    }

    List<KeyCombo> get
    registered_combos =>
        _registered_combos;

    void
    reset() =>
        _registered_combos.clear();

    void
    combo(String combo_string, ComboCallback callback, {prevent_default: false}) {
        registerCombo(new KeyCombo(
            combo_string,
            onKeyDown: callback,
            prevent_default: prevent_default
        ));
    }

    void
    countingCombo(String combo_string, ComboCallback count_callback, {prevent_default: false}) {
        registerCombo(new KeyCombo.counting(
            combo_string,
            onKeyDown: count_callback,
            prevent_default: prevent_default
        ));
    }

    void
    sequenceCombo(String combo_string, ComboCallback callback, {prevent_default: false}) {
        registerCombo(new KeyCombo.sequence(
            combo_string,
            onKeyDown: callback,
            prevent_default: prevent_default
        ));
    }

    void
    registerCombo(KeyCombo combo) {
        if (_registered_combos.contains(combo))
            throw "KeyCombo already registered";
        else
            _registered_combos.add(combo);
    }

    void
    registerMany(List<KeyCombo> combos) {
        combos.forEach(registerCombo);
    }

    void
    unregisterCombo(combo) {
        if (_registered_combos.contains(combo)) {
            _registered_combos.remove(combo);
        }
        else throw 'Combo not registered: $combo';
    }
}