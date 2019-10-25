# PA55 in Dart

A reference implementation of PA55 (not PA55 NYAPS) in Dart. Apache [license](https://github.com/pa55/pa55-dart/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:pa55/pa55.dart';

main() {
  String pa55Password = PA55v1Core.generatePBKDF2Password(
                        HashAlgorithm.SHA256,
                        "test1234",
                        "1234test",
                        18, //24-character password
                        10000);
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/pa55/pa55-dart/issues
