class Node {
  CONTENT_TYPE? type;
  dynamic? content;
  String? linkToContent;
  String? text;
  double x;
  double y;

  Node(this.x, this.y,
      {this.type, this.content, this.text, this.linkToContent});

  Map<String, dynamic> toJson() {
    return {
      "content_type": type.toString(),
      "link_to_content": linkToContent,
      "text": text,
      "x": x,
      "y": y
    };
  }

  Node.fromJson(Map<String, dynamic> json)
      : type = getContentTypeFromString(json['content_type']),
        linkToContent = json['link_to_content'],
        text = json['text'],
        x = json['x'] ,
        y=json['y'] ;

  static CONTENT_TYPE getContentTypeFromString(String type_str){
    return CONTENT_TYPE.values.firstWhere((e) => e.toString() == type_str);
  }
}

enum CONTENT_TYPE { image, text, audio, video }
