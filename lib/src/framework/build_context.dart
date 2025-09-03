part of 'framework.dart';

/// Interface for locating components and accessing state
abstract class BuildContext {
  /// The current component associated with this [BuildContext].
  Component get component;

  /// The [BuildOwner] for this context.
  BuildOwner? get owner;

  /// Whether the component is currently being built.
  bool get debugDoingBuild;

  /// The parent element.
  Element? get parent;

  /// The current binding.
  NoctermBinding get binding;

  /// Returns the nearest ancestor widget of the given type T.
  T? findAncestorComponentOfExactType<T extends Component>() {
    Element? ancestor = parent;
    while (ancestor != null && ancestor.component.runtimeType != T) {
      ancestor = ancestor.parent;
    }
    return ancestor?.component as T?;
  }

  /// Returns the state of the nearest ancestor [StatefulComponent].
  T? findAncestorStateOfType<T extends State>() {
    Element? ancestor = parent;
    while (ancestor != null) {
      if (ancestor is StatefulElement && ancestor.state is T) {
        return ancestor.state as T;
      }
      ancestor = ancestor.parent;
    }
    return null;
  }

  /// Returns the render object of the nearest ancestor [RenderObjectComponent].
  T? findAncestorRenderObjectOfType<T extends RenderObject>() {
    Element? ancestor = parent;
    while (ancestor != null) {
      if (ancestor is RenderObjectElement && ancestor.renderObject is T) {
        return ancestor.renderObject as T;
      }
      ancestor = ancestor.parent;
    }
    return null;
  }

  /// Obtains the nearest [InheritedComponent] of the given type T and
  /// registers this context to be rebuilt when that component changes.
  T? dependOnInheritedComponentOfExactType<T extends InheritedComponent>({Object? aspect});

  /// Registers this context with an [InheritedElement].
  InheritedComponent dependOnInheritedElement(InheritedElement ancestor, {Object? aspect});

  /// Visit all the children elements.
  void visitChildElements(ElementVisitor visitor);

  /// Returns the size constraints from the nearest [RenderObject] ancestor.
  BoxConstraints get constraints {
    final renderObject = findAncestorRenderObjectOfType<RenderObject>();
    return renderObject?.constraints ?? const BoxConstraints();
  }
}
