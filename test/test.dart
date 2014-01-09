library keypress_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
//import 'package:keypress/keypress.dart';
import '../lib/keypress.dart';

part 'keycombo_tests.dart';
part 'keypress_tests.dart';

void
main() {
    useHtmlEnhancedConfiguration();

    testKeyCombo();
    testKeypress();
}