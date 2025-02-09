part of 'cart_provider.dart';

String _$cartTotalHash() => r'eb41abb2aaf99a994c64ad66074b8b6a63cf9148';

@ProviderFor(cartTotal)
final cartTotalProvider = AutoDisposeProvider<double>.internal(
  cartTotal,
  name: r'cartTotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
typedef CartTotalRef = AutoDisposeProviderRef<int>;
String _$cartCountHash() => r'756bd7b6960745c8f39daf10efe074d135e3e524';

@ProviderFor(cartCount)
final cartCountProvider = AutoDisposeProvider<int>.internal(
  cartCount,
  name: r'cartCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
typedef CartCountRef = AutoDisposeProviderRef<int>;
String _$cartNotifierHash() => r'bbe973ca9ee5cfd5829bc68bcc9f774e5d93fc9d';

@ProviderFor(cartNotifier)
final cartNotifierProvider =
    AutoDisposeNotifierProvider<cartNotifier, Set<Product>>.internal(
  cartNotifier.new,
  name: r'cartNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$cartNotifier = AutoDisposeNotifier<Set<Product>>;
