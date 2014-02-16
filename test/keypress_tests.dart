part of keypress_test;

void
testKeypress() {
    String combo_string = 'shift s';
    KeyCombo test_combo = new KeyCombo(combo_string, onKeyDown: (){});
    Keypress keypress = new Keypress();

    group('Keypress', () {
        test('registers KeyCombos', () =>
        expect(
            () => keypress.registerCombo(test_combo),
            returnsNormally
        ));

        test('checks for duplicate KeyCombos', () {
            expect(
                () => keypress.registerCombo(test_combo),
                throws,
                reason: 'KeyCombo already registered'
            );
            expect(
                () => keypress.combo(combo_string, (){}),
                throws,
                reason: 'KeyCombo already registered'
            );
        });

        test('unregisters KeyCombos', () {
            expect(
                () => keypress.unregisterCombo(combo_string),
                returnsNormally,
                reason: 'Accepts Strings in addition to KeyCombos'
            );

            expect(
                keypress.registered_combos,
                isEmpty
            );
        });
    });
}