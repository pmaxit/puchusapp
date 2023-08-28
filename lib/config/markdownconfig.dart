import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final sheet = MarkdownStyleSheet(
    h1: const TextStyle(color: Colors.deepOrange, fontSize: 30),
    h2: const TextStyle(color: Colors.black, fontSize: 25),
    h3: const TextStyle(color: Colors.black, fontSize: 20),
    h4: const TextStyle(color: Colors.black, fontSize: 15),
    h5: const TextStyle(color: Colors.black, fontSize: 10),
    h6: const TextStyle(color: Colors.black, fontSize: 5),
    p: const TextStyle(color: Colors.black, fontSize: 15),
    strong: const TextStyle(color: Colors.black, fontSize: 15),
    em: const TextStyle(color: Colors.black, fontSize: 15),
    code: const TextStyle(color: Colors.black, fontSize: 15),
    blockquote: const TextStyle(color: Colors.deepOrange, fontSize: 15),
    img: const TextStyle(color: Colors.black, fontSize: 15),
    blockSpacing: 15,
    listIndent: 15,
    blockquotePadding: const EdgeInsets.all(15),
    tableBorder: TableBorder.all(color: Colors.black, width: 1),
    tableHead: const TextStyle(color: Colors.deepOrange, fontSize: 15),
    tableBody: const TextStyle(color: Colors.black, fontSize: 15),
    tableColumnWidth: const FlexColumnWidth(1),
    tableCellsPadding: const EdgeInsets.all(8),
    blockquoteDecoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5)),
    
);