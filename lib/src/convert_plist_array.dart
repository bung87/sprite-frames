// import 'dart:convert';
import 'dart:collection';

enum _TokenType { BraceOpen, BraceClose, Content, Comma }

class _Token {
  static const BraceOpen = '{';
  static const BraceClose = '}';
  static const Comma = ',';
  String content;
  _TokenType type;
  _Token(String s) {
    content = s;
    type = _TokenType.Content;
  }
  _Token.braceOpen() {
    type = _TokenType.BraceOpen;
  }
  _Token.braceClose() {
    type = _TokenType.BraceClose;
  }
  _Token.comma() {
    type = _TokenType.Comma;
  }
  @override
  String toString() {
    return {'type': type, 'content': content}.toString();
  }
}

Iterable<_Token> _scan(String s) sync* {
  var i = 0;
  var len = s.length;
  var content = '';
  while (i < len) {
    switch (s[i]) {
      case _Token.BraceOpen:
        yield _Token.braceOpen();
        break;
      case _Token.BraceClose:
        if (content != '') {
          var token = _Token(content);
          yield token;
        }
        content = '';
        yield _Token.braceClose();
        break;
      case _Token.Comma:
        if (content != '') {
          var token = _Token(content);
          yield token;
        }
        content = '';
        yield _Token.comma();
        break;
      default:
        content += s[i];
        break;
    }
    ;
    i++;
  }
}

dynamic convertPlistArray(String s) {
  // var b = s.replaceAll('{', '[').replaceAll('}', ']');
  // var l = jsonDecode(b) as List;
  var prevNodes = Queue();
  var currNode = [];

  for (var token in _scan(s)) {
    switch (token.type) {
      case _TokenType.BraceOpen:
        prevNodes.add(currNode);
        currNode = [];
        break;
      case _TokenType.BraceClose:
        var childNode = currNode;
        currNode = prevNodes.removeLast();
        currNode.add(childNode);
        break;
      case _TokenType.Content:
        currNode.add(int.tryParse(token.content));
        break;
      default:
        break;
    }
  }

  return currNode.first;
}
