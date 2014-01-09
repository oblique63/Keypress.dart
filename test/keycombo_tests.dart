part of keypress_test;

void
testKeyCombo() {
    List<KeyCombo> combos = [
        new KeyCombo('shift f', onKeyDown: (){}),
        new KeyCombo('ctrl s', onKeyDown: (){}),
        new KeyCombo('ctrl d', onKeyDown: (){})
    ];

    group('KeyCombo', () {

        group('compares with', () {
            test('Strings', () =>
            expect(
                combos.contains('CTRL S'),
                isTrue
            ));

            test('KeyCombos', () =>
            expect(
                combos.contains( new KeyCombo('Ctrl s', onKeyDown: (){})),
                isTrue
            ));
        });

        group('validates', () {
            test('keys', () =>
            expect(
                () => new KeyCombo('foo bar', onKeyDown: (){}),
                throws,
                reason: 'Invalid keys'
            ));

            test('combos', () {
                expect(
                    () => new KeyCombo('cmd s f', onKeyDown: (){}),
                    throws,
                    reason: 'More than 1 non-modifier key with meta key'
                );

                expect(
                    () => new KeyCombo('', onKeyDown: (){}),
                    throws,
                    reason: 'Empty combo'
                );

                expect(
                    () => new KeyCombo('lol', onKeyDown: (){}, combo_delimiter: 'o'),
                    throws,
                    reason: 'Combo delimiter cannot contain alpha-numeric characters'
                );

                expect(
                    () => new KeyCombo('meta x'),
                    throws,
                    reason: 'KeyCombo requires a callback function'
                );
            });
        });
    });
}