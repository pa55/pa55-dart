/*
 * Copyright 2019 Anirban Basu

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */

import 'package:pa55/pa55.dart';
import 'package:test/test.dart';

void main() {

  group('HMac hash algorithms with test1234, 1234test, 16 characters, 10K iterations', () {

    test('(SHA1)', () {
      expect(PA55v1Core.generatePBKDF2Password(HashAlgorithm.SHA1,
          "test1234", "1234test", 12, 10000), "M5sfFklaZ86upPyp");
    });

    test('(SHA256)', () {
      expect(PA55v1Core.generatePBKDF2Password(HashAlgorithm.SHA256,
          "test1234", "1234test", 12, 10000), "arJngCkH1meNNDhN");
    });

    test('(SHA512)', () {
      expect(PA55v1Core.generatePBKDF2Password(HashAlgorithm.SHA512,
          "test1234", "1234test", 12, 10000), "FIbqvrcQy1EJAZVG");
    });

  });

  group('PBKDF2 iterations with SHA1, abcd1234, 1234abcd, 24 characters', () {

    test('(10K iterations)', () {
      expect(PA55v1Core.generatePBKDF2Password(HashAlgorithm.SHA1,
          "abcd1234", "1234abcd", 18, 10000), "oM/vrSqxpqVWJtlovMZsEDVV");
    });

    test('(250K iterations)', () {
      expect(PA55v1Core.generatePBKDF2Password(HashAlgorithm.SHA1,
          "abcd1234", "1234abcd", 18, 250000), "c+qFBNPQe0hxVOzYbp2lBi0G");
    });

    test('(500K iterations)', () {
      expect(PA55v1Core.generatePBKDF2Password(HashAlgorithm.SHA1,
          "abcd1234", "1234abcd", 18, 500000), "M/cv4059AVG4K2deMGm+J/3C");
    }, timeout: Timeout.factor(2));

  });

}
