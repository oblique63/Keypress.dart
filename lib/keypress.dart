library keypress;

import 'dart:html';
import 'dart:async';

part 'key_maps.dart';
part 'key_combo.dart';
part 'event_helpers.dart';

// TODO: Make _registered_combos static, and turn the como initializer methods into constructors
// TODO: Support option to consider NumberPad input as regular numerical inputs
//        (i.e. don't require distinguishing the keycodes for the NumberPad)
// TODO: make _keycode_map a static class var that stores the map of the Locale passed to it
// TODO: Refactor input capture functionality into its own class/object (InputManager)

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
    List<String>
        _sequence_input = [];
    StreamSubscription
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
    registered_combos => _registered_combos;

    void
    reset() => _registered_combos.clear();

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

    void
    _bindKeyEvents(Element context) {
        StreamSubscription<KeyboardEvent>
        keyDownStream = context.onKeyDown.listen((event) => _receiveInput(event, true));

        StreamSubscription<KeyboardEvent>
        keyUpStream = context.onKeyDown.listen((event) => _receiveInput(event, false));

        context.onBlur.listen(_onBlur);
    }

    void
    _receiveInput(KeyEvent event, bool is_keydown) {
        if (_prevent_capture) {
            if (_keys_down.isNotEmpty) {
                _keys_down.clear();
            }
            return;
        }
        else if (!is_keydown && _keys_down.isEmpty) {
            return;
        }
        else if (is_keydown) {
            String key = _eventToKeyString(event);
            _keyDown(key, event);
        }
        else {
            String key = _eventToKeyString(event);
            _keyUp("key", event);
        }
    }

    String
    _eventToKeyString(KeyEvent event) {
        return _keycode_map[event.keyCode];
    }

    void
    _keyDown(String key, KeyEvent event) {
        if (event.shiftKey) {
            key = _shifted_keys[key];
        }

        _addKeyToSequence(key, event);
        // TODO: finish implementing
    }

    void
    _keyUp(String key, [KeyEvent keyEvent]) {
        // TODO
    }

    void
    _onBlur(Event event) {
        _keys_down
            ..forEach(_keyUp)
            ..clear();
    }

    void
    _addKeyToSequence(String key, KeyEvent event) {
        List<KeyCombo> sequence_combos = _possibleSequences();

        if (sequence_combos.isNotEmpty) {
            _sequence_input.add(key);

            sequence_combos.forEach((KeyCombo combo) =>
                _preventDefault(event, should_prevent: combo.prevent_default));

            _resetSequenceTimer();
        }
    }

    KeyCombo
    _getSequence(String key) {
        List sequence_combos = _registered_combos.where((combo) => combo.is_sequence);

        for (KeyCombo combo in sequence_combos) {
            for (int j = 1; j < _sequence_input.length; j++) {
                List sequence = _sequence_input.where(
                    (key) => combo.keys.contains("shift") || key != "shift" );

                // TODO Finish implementing
            }
        }
    }

    List<KeyCombo>
    _possibleSequences() {
        int sequence_length = _sequence_input.length;
        List sequence_combos = _registered_combos.where((combo) => combo.is_sequence);
        List<KeyCombo> matches;

        for (KeyCombo combo in sequence_combos) {

            // Because  _sequence is a stack, we're checking the values backwards.
            // TODO: figure out why this is implemented this way...
            for (int j = sequence_length-1; j >= 0; j--) {
                List sequence = _sequence_input.getRange(j, sequence_length);

                if (!combo.keys.contains("shift")) {
                    sequence.removeWhere((key) => key == "shift");
                }
                if (sequence.isEmpty)
                    continue;

                bool match = true;
                for (int i = 0; i < sequence.length; i++) {
                    if (sequence[i] != combo.keys[i]) {
                        match = false;
                        break;
                    }
                }

                if (match) {
                    matches.add(combo);
                }
            }
        }

        return matches;
    }

    void
    _resetSequenceTimer() {
        if (_sequence_timer != null) {
            _sequence_timer.cancel();
        }

        if (sequence_delay > -1) {
            Future future_delay = new Future.delayed(new Duration(milliseconds: sequence_delay));

            _sequence_timer = future_delay.asStream()
                                          .listen((_) => _sequence_input.clear() );
        }
    }

    void
    _preventDefault(KeyEvent event, {bool should_prevent}) {
        if ((should_prevent || suppress_event_defaults) && !force_event_defaults) {
            event.preventDefault();
            event.stopPropagation();
        }
    }
}