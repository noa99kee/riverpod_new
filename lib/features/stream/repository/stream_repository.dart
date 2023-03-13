import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_new/features/post/model/post.dart';

part 'stream_repository.g.dart';

@riverpod
StreamRepository streamRepository(StreamRepositoryRef ref) =>
    StreamRepository();

class StreamRepository {
  Stream<List<String>> getStreams() async* {
    await Future.delayed(Duration(seconds: 1));
    yield ['{"id":1, "title":"titanic"}'];

    await Future.delayed(Duration(seconds: 1));
    yield [
      '{"id":1, "title":"titanic"}',
      '{"id":2, "title":"avatar"}',
    ];
  }

  Stream<List<Movie>> getStreamMovies() {
    return getStreams().map(
      (snapshot) => snapshot.map((json) => Movie.fromJson(json)).toList(),
    );
  }
}

@riverpod
Stream<List<Movie>> streamMovies(StreamMoviesRef ref) {
  final repository = ref.watch(streamRepositoryProvider);
  return repository.getStreamMovies();
}

class Movie {
  final int id;
  final String title;
  Movie({
    required this.id,
    required this.title,
  });

  Movie copyWith({
    int? id,
    String? title,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Movie(id: $id, title: $title)';

  @override
  bool operator ==(covariant Movie other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
