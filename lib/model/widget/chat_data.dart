class ChatbotResponse {
  static Map<String, String> responses = {
    // General Fitness Questions
    'hello':
        'Hello! I\'m your fitness chatbot assistant. How can I help you today?',
    'hi': 'Hi there! How can I assist with your fitness journey today?',
    'hey': 'Hey! Ready to talk fitness? What can I help you with?',
    'help':
        'I can help with workout plans, nutrition advice, tracking progress, and answering fitness questions. What do you need help with?',

    // Workout Questions
    'best workout for weight loss':
        'For weight loss, a combination of cardio (like HIIT, running, or cycling) and strength training usually works best. Aim for 3-4 cardio sessions and 2-3 strength sessions per week.',
    'how to build muscle':
        'To build muscle, focus on resistance training with progressive overload, consume sufficient protein (1.6-2.2g per kg of bodyweight), and ensure adequate recovery between workouts.',
    'how often should i work out':
        'For general fitness, aim for 3-5 workout sessions per week with rest days in between. Beginners should start with 2-3 days and gradually increase.',
    'beginner workout':
        'As a beginner, start with 2-3 full-body workouts per week focusing on compound movements like squats, push-ups, and rows. Start with bodyweight exercises before adding weights.',
    'home workout without equipment':
        'Try this no-equipment workout: 3 rounds of 15 push-ups, 20 squats, 10 lunges per leg, 30-second plank, and 30 jumping jacks with 60-second rest between rounds.',

    // Nutrition Questions
    'best diet for fitness':
        'The "best" diet depends on your goals, but generally focus on whole foods, lean proteins, fruits, vegetables, and adequate hydration. Avoid heavily processed foods and excessive sugar.',
    'how much protein do i need':
        'For active individuals, aim for 1.6-2.2g of protein per kg of bodyweight daily. If you\'re looking to build muscle, stay in the higher end of that range.',
    'pre workout meal':
        'A good pre-workout meal should be consumed 1-3 hours before exercise and include carbs (for energy) and a moderate amount of protein. Examples: banana with peanut butter or oatmeal with protein powder.',
    'post workout nutrition':
        'After working out, consume a meal with protein and carbs within 45 minutes. This helps with muscle recovery and replenishing glycogen stores. A protein shake with a banana is a quick option.',
    'how many calories':
        'Calorie needs vary greatly based on age, gender, weight, height, and activity level. For a personalized calculation, use the Harris-Benedict equation or consult with a nutritionist.',

    // Progress Tracking
    'how to track progress':
        'Track your fitness progress through measurements (weight, body measurements), performance metrics (weights lifted, time/distance), progress photos, and how you feel overall.',
    'not seeing results':
        'If you\'re not seeing results, consider: 1) Are you consistent? 2) Has enough time passed? 3) Are you progressive overloading? 4) Is your nutrition aligned with your goals? 5) Are you getting enough rest?',
    'how long for results':
        'You may notice small changes in 2-4 weeks, but significant results typically take 8-12 weeks of consistent training and nutrition. Be patient and trust the process!',
    'plateau':
        'When you hit a plateau, try changing your workout routine, adjusting your nutrition, ensuring adequate recovery, or slightly increasing workout intensity or volume.',

    // Recovery
    'sore muscles':
        'Muscle soreness (DOMS) is normal, especially with new exercises. Manage it with light activity, proper hydration, adequate protein, and consider gentle stretching or foam rolling.',
    'how much sleep':
        'Aim for 7-9 hours of quality sleep per night. Sleep is crucial for recovery, hormone regulation, and overall fitness progress.',
    'rest days':
        'Rest days are essential for recovery and progress. Include 2-3 rest days weekly. You can do light activity like walking or yoga on these days if you want to stay active.',
    'injury prevention':
        'Prevent injuries by warming up properly, using correct form, progressing gradually, listening to your body, wearing appropriate gear, and including mobility work in your routine.',

    // Default response
    'default':
        'I don\'t have specific information about that yet. For personalized fitness advice, consider consulting with a certified trainer or nutritionist.'
  };

  static String getResponse(String question) {
    // Convert to lowercase and remove punctuation for better matching
    String processedQuestion =
        question.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');

    // Try to find exact match first
    if (responses.containsKey(processedQuestion)) {
      return responses[processedQuestion]!;
    }

    // Try to find partial match
    for (var key in responses.keys) {
      if (processedQuestion.contains(key)) {
        return responses[key]!;
      }
    }

    // Check for keywords
    if (processedQuestion.contains('workout') ||
        processedQuestion.contains('exercise')) {
      return responses['how often should i work out']!;
    } else if (processedQuestion.contains('diet') ||
        processedQuestion.contains('eat') ||
        processedQuestion.contains('food')) {
      return responses['best diet for fitness']!;
    } else if (processedQuestion.contains('protein')) {
      return responses['how much protein do i need']!;
    } else if (processedQuestion.contains('progress') ||
        processedQuestion.contains('result')) {
      return responses['how to track progress']!;
    } else if (processedQuestion.contains('sleep') ||
        processedQuestion.contains('rest') ||
        processedQuestion.contains('recover')) {
      return responses['how much sleep']!;
    }

    // No match found, return default response
    return responses['default']!;
  }
}
