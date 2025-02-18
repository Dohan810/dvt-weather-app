import 'dart:math';

String getGreetingMessage() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 18) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

String getQuote() {
  final quotes = [
    'Have a day of blessings!',
    'Stay positive, work hard, make it happen!',
    'Weather is a great metaphor for life.',
    'Keep your face always toward the sunshine—and shadows will fall behind you.',
    'Wherever you go, no matter what the weather, always bring your own sunshine.',
    'The best thing one can do when it’s raining is to let it rain.',
    'Some people feel the rain. Others just get wet.',
  ];
  final randomIndex = Random().nextInt(quotes.length);
  return quotes[randomIndex];
}
