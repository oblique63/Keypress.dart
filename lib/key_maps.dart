part of keypress;

const List<String>
_modifier_keys = const ['meta', 'alt', 'option', 'ctrl', 'shift', 'cmd'];

const Map<String, String>
_modifier_event_mapping = const {
    'cmd': 'metaKey',
    'ctrl': 'ctrlKey',
    'shift': 'shiftKey',
    'alt': 'altKey'
};

const Map<String, String>
_alternate_key_names = const {
    'escape': 'esc',
    'control': 'ctrl',
    'command': 'cmd',
    'break': 'pause',
    'del': 'delete',
    'return': 'enter',
    'windows': 'cmd',
    'win': 'cmd',
    'prt': 'print',
    'prtscr': 'print',
    'print_screen': 'print',
    'opt': 'alt',
    'option': 'alt',
    'caps_lock': 'caps',
    'pgup': 'pageup',
    'pgdown': 'pagedown',
    'apostrophe': "'",
    'semicolon': ';',
    'tilde': '~',
    'accent': '`',
    'scroll_lock': 'scroll',
    'num_lock': 'num'
};

const Map<String, String>
_numpad_alternate = const {
    'num_0': '0',
    'num_1': '1',
    'num_2': '2',
    'num_3': '3',
    'num_4': '4',
    'num_5': '5',
    'num_6': '6',
    'num_7': '7',
    'num_8': '8',
    'num_9': '9',
    'num_add': '+',
    'num_enter': 'enter',
    'num_divide': '/',
    'num_decimal': '.',
    'num_subtract': '-',
    'num_multiply': '*'
};

const Map<String, String>
_shifted_keys = const {
    '/': '?',
    '.': '>',
    ',': '<',
    "'": '"',
    ';': ':',
    '[': '{',
    ']': '}',
    r'\': '|',
    '`': '~',
    '=': '+',
    '-': '_',
    '1': '!',
    '2': '@',
    '3': '#',
    '4': r'$',
    '5': '%',
    '6': '^',
    '7': '&',
    '8': '*',
    '9': '(',
    '0': ')'
};

final Map<int, String>
_keycode_map =  {
    0: r'\',

    8: 'backspace',
    9: 'tab',

    12: 'num',
    13: 'enter',

    16: 'shift',
    17: 'ctrl', // 'cmd' in Opera
    18: 'alt',
    19: 'pause',

    20: 'caps',
    27: 'esc',

    32: 'space',
    33: 'pageup',
    34: 'pagedown',
    35: 'end',
    36: 'home',
    37: 'left',
    38: 'up',
    39: 'right',
    40: 'down',
    44: 'print',
    45: 'insert',
    46: 'delete',

    48: '0',
    49: '1',
    50: '2',
    51: '3',
    52: '4',
    53: '5',
    54: '6',
    55: '7',
    56: '8',
    57: '9',

    59: ';', // Firefox
    61: '=', // Firefox

    65: 'a',
    66: 'b',
    67: 'c',
    68: 'd',
    69: 'e',
    70: 'f',
    71: 'g',
    72: 'h',
    73: 'i',
    74: 'j',
    75: 'k',
    76: 'l',
    77: 'm',
    78: 'n',
    79: 'o',
    80: 'p',
    81: 'q',
    82: 'r',
    83: 's',
    84: 't',
    85: 'u',
    86: 'v',
    87: 'w',
    88: 'x',
    89: 'y',
    90: 'z',

    91: 'cmd',
    92: 'cmd',
    93: 'cmd',

    96:  'num_0',
    97:  'num_1',
    98:  'num_2',
    99:  'num_3',
    100: 'num_4',
    101: 'num_5',
    102: 'num_6',
    103: 'num_7',
    104: 'num_8',
    105: 'num_9',
    106: 'num_multiply',
    107: 'num_add',
    108: 'num_enter',
    109: 'num_subtract',
    110: 'num_decimal',
    111: 'num_divide',

    112: 'f1',
    113: 'f2',
    114: 'f3',
    115: 'f4',
    116: 'f5',
    117: 'f6',
    118: 'f7',
    119: 'f8',
    120: 'f9',
    121: 'f10',
    122: 'f11',
    123: 'f12',
    124: 'print',

    144: 'num',
    145: 'scroll',
    186: ';',
    187: '=',
    188: ',',
    189: '-',
    190: '.',
    191: '/',
    192: '`',

    219: '[',
    220: r'\',
    221: ']',
    222: "'",
    223: '`',
    224: 'cmd',
    225: 'alt',

    57392: 'ctrl',
    63289: 'num'
};

final Set<String>
_valid_keys = _keycode_map.values.toSet()
                                  ..addAll(_shifted_keys.values);