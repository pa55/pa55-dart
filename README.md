# PA55 in Dart

A reference implementation of PA55 (not PA55 NYAPS) in Dart. Apache [license](https://github.com/pa55/pa55-dart/blob/master/LICENSE).

## Usage -- command line

```
pub run example/pa55_example.dart -h
```
displays the arguments that the program takes as follows. For example,

```
pub run example/pa55_example.dart -a SHA256 -r 10K -l 16 -v
```
runs PA55 with the hash algorithm set to SHA256, the PBKDF2 rounds to 10,000 and generates a password of length 16 after obtaining the inputs from the user through ```stdin``` for the master secret and the hint. Turning off the ```-v``` flag will turn off all output messages from PA55 except the final password and any error.

## Usage of the library

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
