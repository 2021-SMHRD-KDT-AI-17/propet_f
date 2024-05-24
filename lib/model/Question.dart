class Question{
  int q_idx;
  String q_content;
  String q_answer;
  //Unit8List q_embedding;  // gpt는 된다는데 안됨

  String q_tf;
  String q_category;
  String u_id;

  Question({
    required this.q_idx,
    required this.q_content,
    required this.q_answer,
    required this.q_tf,
    required this.q_category,
    required this.u_id,

  });


}