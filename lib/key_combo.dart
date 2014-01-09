part of keypress;

/// Callback function for a [KeyCombo].
/// i.e. [onKeyDown](KeyCombo.onKeyDown), [onKeyUp](KeyCombo.onKeyUp), [onRelease](KeyCombo.onRelease)
typedef void ComboCallback();


/// Binds [callback functions](ComboCallback) to a [string of keys](combo_string) to represent a key shortcut/combo.
/// [KeyCombo]s do not start listening for key combos on their own, they must be registered with [Keypress].
class KeyCombo {
    /// A [String] of seperated key names that make up the combo
    final String
        combo_string;

    /// A [String] indicating how the key names are separated (e.g. `' '`, `'+'`, etc)
    final String
        combo_delimiter;

    /// Whether to prevent the default browser behavior for all keypresses that are part of the combo.
    bool
        prevent_default = false;

    /// Normally the [onKeyDown] callback will be called as fast as your browser fires the keydown event,
    /// but by setting this option to `true`, the [onKeyDown] callback will only be called the first time.
    bool
        prevent_repeat = false;

    /// Whether to log the number of times the combo has been pressed
    bool
        is_counting = false;

    /// Whether to require the user to press the keys in the order specified by the [combo_string].
    bool
        is_ordered = false;

    /// Whether to require the user to press all the keys in the [combo_string] exactly, and in order
    bool
        is_sequence = false;

    /// Whether to call the callback functions of other [KeyCombo]s that share a subset of this combo's keys
    bool
        is_exclusive = false;

    /// This option will check that ONLY the combo's keys are being pressed when set to true.
    /// When set to the default value of false, a combo can be activated even if extraneous keys are pressed.
    bool
        is_solitary = false;

    // TODO: Optional support for distinguishing Left/Right keys (e.g. shift, ctrl, alt...)?

    ComboCallback
        onKeyDown,
        onKeyUp,
        onRelease;

    List<String>
        _keys;
    int
        _count = 0;

    static String
        _metakey;

    // TODO: Clean up constructors and rely on the cascade operator for setting values

    /// Creates a [KeyCombo] instance
    KeyCombo(this.combo_string,
            {this.onKeyDown, this.onKeyUp, this.onRelease,
             this.combo_delimiter: ' ', this.prevent_default, this.prevent_repeat,
             this.is_counting, this.is_ordered, this.is_sequence, this.is_exclusive, this.is_solitary }) {

        _keys = combo_string.toLowerCase().split(combo_delimiter);
        _validateCombo();
    }

    /// Creates a [counting combo](is_counting)
    KeyCombo.counting(this.combo_string,
                      {this.onKeyDown, this.onKeyUp, this.onRelease,
                       this.combo_delimiter: ' ', this.prevent_default, this.prevent_repeat,
                       this.is_exclusive, this.is_solitary}) {

        _keys = combo_string.toLowerCase().split(combo_delimiter);
        is_counting = true;
        is_ordered = true;
        _validateCombo();
    }

    /// Creates a [sequence combo](is_sequence)
    KeyCombo.sequence(this.combo_string,
                      {this.onKeyDown, this.onKeyUp, this.onRelease,
                       this.combo_delimiter: ' ', this.prevent_default, this.prevent_repeat,
                       this.is_exclusive, this.is_solitary}) {

        _keys = combo_string.toLowerCase().split(combo_delimiter);
        is_sequence = true;
        _validateCombo();
    }

    /// A [List] of the keys in the combo
    List<String> get
    keys => _keys;

    /// The number of times the combo has been called (only if [is_counting] == `true`)
    int get
    count => _count;

    String
    toString() => combo_string.toLowerCase();

    /// Can compare [KeyCombo]s with each other, or with [String]s containing combo keys.
    /// E.g. `(new KeyCombo('shift s', ...)) == 'shift s' == true`
    bool operator
    == (other) {
        if (other is KeyCombo) {
            List same_keys = _keys.where((key) => (other as KeyCombo).keys.contains(key));

            return same_keys.length == _keys.length &&
                    other.is_ordered == is_ordered;
        }

        else if (other is String) {
            return other.toLowerCase() == combo_string ||
                    other.toLowerCase() == _keys.join(combo_delimiter);
        }
        else throw "Invalid KeyCombo comparison";
    }

    int get
    hashCode {
        String code_string = _keys.join('')
                                   .codeUnits
                                   .fold('', (result, int code) => '$result$code');

        if (is_ordered) {
            code_string = '1$code_string';
        }

        return int.parse(code_string);
    }

    void
    _validateCombo() {
        if (_keys.isEmpty)
            throw "Cannot create a KeyCombo with no keys!";

        else if (combo_delimiter == null)
            throw "KeyCombo must have a combo delimiter";

        else if (combo_delimiter.contains(r'\w+'))
            throw 'Combo delimiter cannot contain alpha-numeric characters: "$combo_delimiter"';

        else if (onKeyDown == null && onKeyUp == null && onRelease == null)
            throw 'KeyCombo must have a callback function: "$combo_string"';

        if (_metakey == null) {
            _decideMetaKey();
        }

        for (int i = 0; i < _keys.length; i++) {
            String key = _keys[i];

            if (key == 'meta') {
                _keys[i] = _metakey;
            }
            else if (key == 'cmd') {
                print("Warning: use 'meta' instead of 'cmd' to ensure platform compatibiity");
            }
            else if (_alternate_key_names.containsKey(key)) {
                _keys[i] = _alternate_key_names[key];
            }
            else if (!_valid_keys.contains(key)) {
                throw "Invalid key: $key";
            }
        }

        List non_modifier_keys = _keys.where((key) => !_modifier_keys.contains(key));
        if (non_modifier_keys.length > 1) {
            // TODO: check if this is still a problem when defining sequence combos
            throw "'meta'/'ctrl'/'cmd' KeyCombos cannot have more than 1 non-modifier key";
        }
    }

    static void
    _decideMetaKey() {
        if (window.navigator.platform.contains("Mac")) {
            _metakey = 'cmd';
        }
        else {
            _metakey = 'ctrl';
        }
    }
}