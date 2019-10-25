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

import 'dart:convert';
//TODO: optimise the imports
import 'package:pointycastle/export.dart';

enum HashAlgorithm {
  SHA1,
  SHA256,
  SHA512
}

class PA55v1Core {

  static String generatePBKDF2Password(HashAlgorithm pbkdfAlgorithm,
                                String masterSecret,
                                String passwordHint,
                                int passwordLength,
                                int pbkdf2Rounds) {
    var digest;
    var blockLength;
    switch(pbkdfAlgorithm) {
      /*
       * Check block lengths from:
       * https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/crypto/macs/HMac.java
       */
      case HashAlgorithm.SHA1:
        digest = SHA1Digest();
        blockLength = 64;
        break;
      case HashAlgorithm.SHA256:
        digest = SHA256Digest();
        blockLength = 64;
        break;
      case HashAlgorithm.SHA512:
        digest = SHA512Digest();
        blockLength = 128;
        break;
    }

    //UTF-8 encoder: string->bytes
    Utf8Encoder utf8encoder = Utf8Encoder();

    //Generator for PBE derived keys and ivs as defined by PKCS 5 V2.0 Scheme 2
    PBKDF2KeyDerivator derivator = PBKDF2KeyDerivator(
        HMac(digest, blockLength))
          ..init(Pbkdf2Parameters(utf8encoder.convert(passwordHint),
          pbkdf2Rounds, passwordLength));

    //Obtain the PBKDF2 output
    var bytes = derivator.process(utf8encoder.convert(masterSecret));

    //Return a base64 encoded string
    Base64Encoder base64encoder = Base64Encoder();
    return base64encoder.convert(bytes);
  }

}
