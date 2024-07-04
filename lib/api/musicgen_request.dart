class MusicGenRequest {
  String url = 'http://127.0.0.1:5000/musicgen';

  Map<String, dynamic> createPayload(String description) {
    return {
      'inputs': description,
    };
  }
}
