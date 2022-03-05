import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _credentials = r'''
  
 {
  "type": "service_account",
  "project_id": "hackathon-database-343118",
  "private_key_id": "d0c26d2670ed782bf558d887e9218ece253a285d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCs2EpEGIoVY8Ow\ncCfma6Af0QgPc55/6HKICYttT5CemGENRFma9OBnwQjUU008twklj3+HtnPE+Jta\nNvwhys5oHKLm3EwKBe5xO74FVj7IZduYjsF+5FcKsqV0tQnq0qVy6hKrpZjSJBr+\nf0sLfj/kjbMydO2DwD3uA70Ch1PVjqdwAl2Js9Ig+FLoJC13GqfAZQgVzAluNcGr\n1IjoiotYlJoS91T/9q2lrLXrwFzRkRGympT2l3HEDvD2KjQ8Ec26GpJhgVcGNZhv\ni3lev5YEDxLmz6fKibs5DDOmuEo65XPyQ1DXT3Bklw2afowwzzJi4NCF0nqHrLlW\n32L4epl1AgMBAAECggEAAf3OTJQNd+XJx1KM0c27ec+zpyfsHimnCNRhUp2teyJN\ne0oRD+USi9Ilyvp4Y+1w8cmXjNBS66SjTOoKxCHnzbvHZbUJPD6pare8k/z/JVnF\nFVrPCxT66sDjAUylBAYFdCToblQEBichLNL5zJ9ZrEVfWJgPyio7ccQBwrxylb3g\nN0VHEqw8cIUk47E4wqx5HCU1p4hYTzPVvfzD07QkwqimeJCzHUkg9kXh3uNXSevS\niitnIWSkre5STg5RMkPPRIoXHHTyGXfLwwJ3VZS/qh023OzgGHxe5j/KI9y4aAuB\nKleFMF4tFl1M62MwjH9ACcnZpphWjXIANrplsHE/GQKBgQDwR+kTVG/Xdvo+RbIK\njy9fB8Dwrjz5O7o8FK3y7BpUbKdh5wioHlIU4K0/fTLb7VleaILtieqohqp8x7qf\nCzsOm2rzB6L0ryaPzPY6wyUJT4sm5RlDbqWD/HdnPi2TLyqMBcyzlDT5fJJTcOov\nGbOcE3qdhOoudANNwmVt/DdBfQKBgQC4Jv/GJG9dqQgkHbt4AtJMCw887VY3JFXZ\n5qbyC3qYdhXqi1Adh+n1Y0RoWt+aZldbXnQ4061a1JLZmDOoUYaGfuEDmtTJjJO3\natGzyPpimSaqqrKDp13TvuBT8VyZkqPO+M2t8Oef1MJ9oyvn4+WVcxBjKkYEyITk\nSKLWuXA5WQKBgGo/MfXFKWs6Be9RPCflJoo70HncYcPHQFNexYgcFIxuOxlUYoSM\nW7k1nAXt43ZSHmlbh0Fn8aYxXeOtIX1AJw4PdRwfrVPKux9s/xf+wDq8vIgnV6N0\noqWZFmdFnDtv6L1ftyNVDpOfHMjerf7Du6LxDg/m/PIrhGZ25gjbNMe1AoGAUd0U\nazMbRtmzwsps4mbusdtgxMcFQrImcB23LXao40nraD7SOK6I9QtSB8oOCQdh4j5V\nEEYZlH1XYt/kZvkHApc41G9qFMcni6wy2OeJV3eZ1tjXTuuCLHV4KBjt/19O7t1w\nIdksPsNISq3VANsw3oUuTccnJU02tn0L1sTM/NECgYBbZtwI61LAgftEcQPigJkp\nUir/LIB2JdreRn5tvg7DB+JS2cPtkxDys11JL/oGzRkovv5JN5qxD3caWylDcwIf\nKZHK8MGV83IbJUb/d28IiK8md2UJZgZxPYDmUUCd0mnxZeIvqKjxdpQe73yWyMSK\nJHpDLinbL+lElHjvRQh/Wg==\n-----END PRIVATE KEY-----\n",
  "client_email": "hackathon-database@hackathon-database-343118.iam.gserviceaccount.com",
  "client_id": "117522423648123127523",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/hackathon-database%40hackathon-database-343118.iam.gserviceaccount.com"
}


''';

  static final _spreedsheetId = '1f-DWJ6C4LssHmt9kMW-YDvrFfC0eTFDBgmO07rfI2Qc';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreedsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
