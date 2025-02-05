import 'package:ichack_backend_server/src/generated/protocol.dart';
import 'package:ichack_backend_server/src/llm_util.dart';
import 'package:ichack_backend_server/src/prompt_util.dart';
import 'package:serverpod/serverpod.dart';

class TextEndpoint extends Endpoint {
  // List to store recorded speeches and their timestamps
  List<Sentence> recordedSpeeches = [];
  Future<bool> record(Session session, int conversationId,
      String speechRecorded, DateTime timestamp) async {
    try {
      var sentence = Sentence(
          convoId: conversationId,
          timestamp: timestamp,
          sentence: speechRecorded,
          emotion: "");
      recordedSpeeches.add(sentence);
      // Return true to indicate success
      return true;
    } catch (e) {
      // Log the error (optional)
      session.log('Failed to record speech: $e');
      // Return false to indicate failure
      return false;
    }
  }

  Future<String> generateReply(Session session,
      {bool encouraging = true,
      bool constructive = true,
      bool wellRounded = true}) async {
    // await Sentence.db.insert(session, recordedSpeeches);
    String prompt = PromptUtil.buildPrompt(recordedSpeeches, encouraging: encouraging, constructive: constructive, wellRounded: wellRounded);
    recordedSpeeches.clear();
    return LLMUtil.ask(session, prompt);
  }
}
