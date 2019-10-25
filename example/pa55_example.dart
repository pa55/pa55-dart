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

import 'dart:io';
import 'package:args/args.dart';
import 'package:pa55/pa55.dart';

void main(List<String> arguments) {
  final stopwatch = Stopwatch();
  var exitCode = 0; //presume success
  final programVersion = 'PA55 v.2019.10';
  final parser = ArgParser();

  parser..addOption('hash', abbr: 'a', help: 'Hash algorithm.',
                  allowed: {'SHA1', 'SHA256', 'SHA512'},
                  defaultsTo: 'SHA256');
  parser.addOption('length', abbr: 'l', help: 'Desired password length in characters.',
                  allowed: {'8', '12', '16', '20', '24', '28', '32'},
                  defaultsTo: '12');
  parser.addOption('rounds', abbr: 'r', help: 'PKBDF2 rounds (high values will be slower)',
                  allowed: {'10K', '250K', '500K', '750K', '1M', '1.25M', '1.5M'},
                  defaultsTo: '500K');
  parser.addFlag('verbose', abbr: 'v', help: 'En(dis)able verbose output.',
                negatable: true, defaultsTo: false);
  parser.addFlag('help', abbr: 'h', help: 'Show this usage information.',
                negatable: false);
 try {
    var argResults = parser.parse(arguments);
    if(argResults.wasParsed('help') || argResults.arguments.isEmpty) {
      printUsage(parser, programVersion);
    }
    else {
      var verbose = argResults['verbose'];
      //master secret and the password hint must be parsed from stdin instead of
      // being passed as an argument
      stdin.echoMode = false; //disable echo for sensitive input
      if(verbose) {
        print(programVersion);
        stdout.write("Type the master secret and press ENTER: ");
      }
      var masterSecret = stdin.readLineSync(retainNewlines: false);
      if(verbose) {
        stdout.write("\r\nType the password hint and press ENTER: ");
      }
      var passwordHint = stdin.readLineSync(retainNewlines: false);
      stdin.echoMode = true; //enable echo
      if(verbose) {
      //print the options
        print('\r\nComputing password, using options');
        argResults.options.forEach((f) => {
          if(f!='help' && f!='verbose') { //no need to show these flags
            print('  ' + f.toString() + ': ' + argResults[f].toString())
          }
        });
        stopwatch..start();
      }
      String pa55Password = PA55v1Core.generatePBKDF2Password(
                            hashAlgorithmFromString(argResults['hash']),
                            masterSecret,
                            /*argResults['hint']*/passwordHint,
                            passwordLengthFromString(argResults['length']),
                            passwordRoundsFromString(argResults['rounds']));
      if(verbose) {
        var timeElapsed = stopwatch.elapsedMilliseconds;
        print("Password (computed in " + timeElapsed.toString() + " ms): " + pa55Password);
        stopwatch.stop();
      }
      else {
        print(pa55Password);
      }
    }
  } on Exception catch (e) {
    stderr.write(e.toString() + '\r\n');
    printUsage(parser, programVersion);
    exitCode = -1;
  }
  exit(exitCode);
}

void printUsage(ArgParser parser, String programVersion) {
  print(programVersion + ' usage information');
  print('IMPORTANT: The master secret and the password hint must be typed in or piped in from another source. These cannot be passed as arguments.');
  print(parser.usage);
}

HashAlgorithm hashAlgorithmFromString(String argument) {
  HashAlgorithm choice;
  switch(argument) {
    case "SHA1":
      choice = HashAlgorithm.SHA1;
      break;
    case "SHA256":
      choice = HashAlgorithm.SHA256;
      break;
    case "SHA512":
      choice = HashAlgorithm.SHA512;
      break;
    default:
      choice = null;
  }
  return choice;
}

num passwordLengthFromString(String length) {
  return ((int.tryParse(length)?? 0)*3)~/4;
}

num passwordRoundsFromString(String rounds) {
  var thousandUnits = rounds[rounds.length - 1];
  var numberPart = rounds.substring(0, rounds.length-1);
  num parsedNumber = (double.tryParse(numberPart)?? 0);
  switch(thousandUnits.toUpperCase()) {
    case 'K':
      parsedNumber *= 1000;
    break;
    case 'M':
      parsedNumber *= 1000000;
    break;
  }
  return parsedNumber.toInt();
}
