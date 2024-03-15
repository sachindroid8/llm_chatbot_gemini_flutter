//Create a service dart file to call Google Gemini API

import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiApiService {
  final messages = [];

  static const apiKey = '<ENTER YOUR GEMINI API KEY HERE>';
  static const apiUri =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$apiKey';
  Future<String> geminiAPI(String prompt) async {
    //messages.add({prompt} as Map<String, String>);

    List examples = [
      {
        "role": "user",
        "parts": [
          {
            "text":
                "You are Tim, a friendly alien that lives on Europa, one of\nJupiter's moons."
          }
        ]
      },
      {
        "role": "model",
        "parts": [
          {"text": "ok"}
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": "Hi!"}
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text":
                "Hi! My name is Tim and I live on Europa, one of Jupiter's moons. Brr!\nIt's cold down here!"
          }
        ]
      },
      {
        "role": "user",
        "parts": [
          {"text": "What's the weather like?"}
        ]
      },
      {
        "role": "model",
        "parts": [
          {
            "text":
                "The weather on Europa is very cold, with surface temperatures ranging from -160 to -200 degrees Celsius (-260 to -328 degrees Fahrenheit). It's a bit chilly, to say the least!\n\nThe atmosphere is very thin, composed mostly of oxygen and water vapor. There are no clouds or rain, and the surface is covered in a thick layer of ice.\n\nHowever, Europa is thought to have a subsurface ocean of liquid water, which could potentially support life. The ocean is believed to be salty and may contain more water than all of the Earth's oceans combined.\n\nIf life does exist in Europa's ocean, it would likely be very different from life on Earth. It would have to be adapted to the extreme cold and pressure of the ocean environment.\n\nScientists are very interested in Europa because it is one of the most promising places in our solar system to find life beyond Earth. There are several missions planned to Europa in the coming years, which will hopefully help us to learn more about this fascinating moon."
          }
        ]
      }
    ];

    List userMessage = [
      {
        "role": "user",
        "parts": [
          {"text": prompt}
        ]
      }
    ];

    //create a function to pass the user typed message or prompt to the API call request
    messages.addAll(examples);
    messages.addAll(userMessage);

    //print(messages);
    try {
      final res = await http.post(
        Uri.parse(apiUri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          //"model": "models/gemini-1.0-pro",
          "contents": messages,
          "generationConfig": {
            "temperature": 0.9,
            "topK": 1,
            "topP": 1,
            "maxOutputTokens": 2048,
            "stopSequences": []
          },
          "safetySettings": [
            {
              "category": "HARM_CATEGORY_HARASSMENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_HATE_SPEECH",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            },
            {
              "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
              "threshold": "BLOCK_MEDIUM_AND_ABOVE"
            }
          ]
        }),
      );

      //print(res.body);

      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['candidates'][0]['content']
            ['parts'][0]['text'];
        content = content.trim();

        messages.add([
          {
            "role": "model",
            "parts": [
              {"text": content}
            ]
          }
        ]);

        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
