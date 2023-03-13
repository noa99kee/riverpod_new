// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streamRepositoryHash() => r'200ea4263c99172a639b4a748fec2d721350a649';

/// See also [streamRepository].
@ProviderFor(streamRepository)
final streamRepositoryProvider = AutoDisposeProvider<StreamRepository>.internal(
  streamRepository,
  name: r'streamRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streamRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreamRepositoryRef = AutoDisposeProviderRef<StreamRepository>;
String _$streamMoviesHash() => r'ba09cabcbdd942f50bbbeb7d975b51e531afc8f6';

/// See also [streamMovies].
@ProviderFor(streamMovies)
final streamMoviesProvider = AutoDisposeStreamProvider<List<Movie>>.internal(
  streamMovies,
  name: r'streamMoviesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$streamMoviesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreamMoviesRef = AutoDisposeStreamProviderRef<List<Movie>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
