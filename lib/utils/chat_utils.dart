String generateChatId(String user1, String user2) {
  final sorted = [user1.toLowerCase(), user2.toLowerCase()]..sort();
  return '${sorted[0]}_${sorted[1]}';
}
