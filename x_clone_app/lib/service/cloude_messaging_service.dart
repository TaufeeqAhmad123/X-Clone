import 'package:http/http.dart';
import 'package:googleapis_auth/auth_io.dart';

class getCloudeMessagingService {
  // This class is a placeholder for the Cloud Messaging Service.
  // It can be used to implement methods related to cloud messaging.

  // Example method to send a message
  Future<String> serverToken() async {
    final scope = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/userinfo.email',
    ];
    final cline = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "xclone-af992",
        "private_key_id": "c4bd1eb68593f83ef2c5bcd836f44dce8fb2ba93",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCJu8WMWiF+8qHK\nJDZgyLjMpgjr0SqG0fiRyVykHDhXgkrj3Ink6HCl2h6acW6l0sIwOB/lapaBusVV\nVhxcDsDu7R9tOKnrN9oAz28np5fa3ai8DGn0IcKuCkf1auywln8/ieKPOIexsw3n\nDVThHUe1XhodIFxG7MAzI/nEkTzYW1FBY5Tq1b5fr/bENABEyuZshT/U5DOav3sp\nP9LjnQj0KA9lwWqzYgAi8mifshYlw1tcc2dhpBpx56cCIo2VfU3Fic7OmRfJmQ2o\nv86vh0aEGeNPrHURunSKsbt52iULK/jVWhq2ZSdMgyPkzx/wJ5u5AvpUYKETvNAQ\nddhPw/MzAgMBAAECggEAAihYC23PHRCfDXneHDRi7ohQxXYELPuVm+PEFgZombiE\ns0SL+eeO+gLd5SJgfXHIlA+FvjV3g2IDiHFT4yFKlPlm3iyBhOtSPntee2UubkG9\nwNgDfCoxaBOjJ01ROYQJS4oma5pNMMgS0zmr9yyg4k66EdC8agy+HmY+JX3f3SHz\nMbyqVFVsXs9PFKDOjcALFkX/fmGKb+QErCZTGgl4JA/bCVsbrHN2qyL9SnAzHsMA\nwOerBt3PkBEJ6DIvOxiZKqrWK/9XXS4FNZErOAIaaAEQRI2GeIK0rn5DJiclvjY6\ndYv0WTxrfJPDiPVUyOoWiWjz9F11tRkboB6sszdxAQKBgQC8UVdVXdZi7dzmCkIX\nAa9YdaGI9nRQg27oXHYJ7VUeJH0uuhBxbCSQb0kyQkOTmuO7Nasez0xeaW8NMJOC\nR7RTMKo+t/DIJpUvPrYm2EFmfX3+b2EpVqimy4wFU/0i2ucVU3Gx9HLw4FNa3FWY\nq5pwXW7nrkc5jLFyXhkpnaqXgQKBgQC7PEu0YvaFqfzCFLd4gQyFNAduO96lu2ov\nVQ1AxIn5tU3u5jtQkqXdZ9nMcJnCTAzKInX3jkHpISTBUTrb1UwNjqN2WveKGyHr\n5Emc2QGVaxivxJOJJ5BzyspathmD4OPENmKe6VWd7fjDNV6vN5gHU3REpSg8BdUT\nLC2Nph4EswKBgH/jkbbUulKHDTxgfQ+YwlcF08Tq8oT3LWu51yPYvLRyvVztWVtd\nwNsh6IisPa5RQxURVnve9hMr8RH5CkQwpALXCtb7HhcfNLNYGGX6+Tc8REN1qntj\ncbeMhjPcHQ39sW9nMtBSnXh+L72F4s+CwqhKm5XVYmNv69Yql1YO0BqBAoGACZFi\nOPyZpmjyXqSaX5EQp7np60sp7IQwP+zzuWyRtG38ZonjXBGyYicNbTIP2WrzeFzc\ndGMToSstaqeQ/2zd7w9r8P9jCO6sBBbtYBOCzjTj1Q+Rjn+0FQa24n3Nvfx/BybU\nUVSRKHnhrXALv55yqWUtWtipvq95nPoz9boYbJsCgYB1kaWCleeM0F5MbDt05k/q\ngjfgshPdo89xUVh0hilfywnwLWV/7h+pD1WftauEmkXbbyxvCQUtqVU/92GdePx4\nR1xKvQwAONoYzBYjDAGLacaN3B9dNXGLi34v1c18hMDWdFjNKgWLF8Pu2ldRMETF\nl5FffUoGQWH9q0nReYbPmg==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@xclone-af992.iam.gserviceaccount.com",
        "client_id": "108994455534198153460",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40xclone-af992.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      scope,
    );
    final accessKey = cline.credentials.accessToken.data;
    return accessKey;
  }
  final String serverkey='ya29.c.c0ASRK0GYcFH1Mu9KK5_Jw52-ehVCXkGrcNPPgLqYVIu4XIzeSGzQySUY9o4PUu3NC9cnIFvivELlPif67ToCWil4l7ZXXibBX7OZiCUTVIXWI7lxrkhHZ_uJ3E-50QZTz4O9oaikJspN4cm2ygXIX4J-L5LSgbMYIb8zI2opf_VvYP_p-_TDSjKHEGpPXDG08xq8BK3UQIk0zEvw1_S4PJMYQIvjDNbAs8n_x6gz2CCkBo6sBVu2K26xhC8Ug-I8qdbDs-8hOqc8bOXKlB_lk6f3-LYj0Ble4wD4KRtxc193ibdehPX5rZQkaIUIaw8ZFc8tviYAL3gThHd6qZdZnNoJLi0cETIKq4g2gzZztCnVqUgoQnkdURIlYzMME388Dcs9uQkY52f7VsIwFW5B2dz1m1mh70nthJSsyok-1rc7mj4ZVveF3zuqscBpsOW12RlifnnOJo5oVY90p3gyr0jl9bsay-Otmur0X7XmMzlYuQa29rq5XbfOQY8wgRXMYpSUV28auwWUl9dYofwvo18pd3F1Wj7kljkqz2lRfaw7Fplju4t43WxF2iUsbc0ZrnypSxUidf3j_4I3YYou867_yrp3Ml5rvusW-ocxwUeln2daWJOdJyfijr4wvQgSZBw8uBaZie3fFd993uoM5gjxy37nq3YlQiFecjWZUhIZ4juFtsmYBIF112v6M5-5yauhOBkrpk_0tweW-M08yhw3zB80U0ZZMiIjnocqcyo10JRlolaQIxi0amp9Qafeuud-ahhy3or04Y9wB1ef83Wi_bof207Q2-pvW7rhnwBm98hQg1bnxp8vOnqRwqxOi7QWh1lpRMbham5hjMOitVoXvgJVefd-B-pznbu_xs1uXJBjlIUhpjkUivdf304ddMqjzkXygerijMq9RwvneM9yoU_ketOVeeiXhsnuwMsyakgs93d7B_wVXUzOyyppBzBIkyhk-mUfF9dYUl1fyW4aBib35hjpU5BoWOys9';
}
