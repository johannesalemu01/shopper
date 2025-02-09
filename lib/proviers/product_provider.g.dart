part of 'product_provider.dart';

String _$productHash() => r'5c51d823a6be6793e74f8ab336b893404e93b868';

@ProviderFor(product)
final productProvider = AutoDisposeStreamProvider<List<Product>>.internal(
  product,
  name: r'productProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
typedef ProductRef = AutoDisposeProviderRef<List<Product>>;
