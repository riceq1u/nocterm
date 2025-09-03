part of 'framework.dart';

/// A component that has mutable state.
abstract class StatefulComponent extends Component {
  const StatefulComponent({super.key});

  @override
  StatefulElement createElement() => StatefulElement(this);

  /// Creates the mutable state for this component.
  @protected
  State createState();
}

/// The logic and internal state for a [StatefulComponent].
abstract class State<T extends StatefulComponent> {
  T get component => _component!;
  T? _component;

  BuildContext get context => _element!;
  StatefulElement? _element;

  bool get mounted => _element != null;

  /// Initialize state. Called once when the State object is created.
  @protected
  void initState() {}

  /// Called whenever the component configuration changes.
  @protected
  void didUpdateComponent(covariant T oldComponent) {}

  /// Called when dependencies of this object change.
  @protected
  void didChangeDependencies() {}

  /// Clean up resources. Called when the State object is removed permanently.
  @protected
  void dispose() {}

  /// Called whenever the application is reassembled during debugging, for
  /// example during hot reload.
  ///
  /// This provides an opportunity to reinitialize any data that was computed
  /// in the initState method or to reset any state.
  @protected
  @mustCallSuper
  void reassemble() {}

  /// Describes the part of the user interface represented by this component.
  @protected
  Component build(BuildContext context);

  /// Notify the framework that the internal state has changed.
  @protected
  void setState(VoidCallback fn) {
    assert(_element != null);
    assert(_element!._lifecycleState == _ElementLifecycle.active);

    fn();
    _element!.markNeedsBuild();
  }
}

/// Element for StatefulComponent
class StatefulElement extends BuildableElement {
  StatefulElement(StatefulComponent component) : super(component) {
    _state = component.createState();
    assert(_state._element == null, 'State object was already used');
    _state._element = this;
    assert(_state._component == null, 'State object was already initialized');
    _state._component = component;
  }

  @override
  StatefulComponent get component => super.component as StatefulComponent;

  late final State _state;
  State get state => _state;

  @override
  Component build() => _state.build(this);

  @override
  void mount(Element? parent, dynamic newSlot) {
    _state.initState();
    super.mount(parent, newSlot);
  }

  @override
  void update(Component newComponent) {
    super.update(newComponent);
    assert(component == newComponent);
    final StatefulComponent oldComponent = _state._component!;
    _state._component = component;
    _state.didUpdateComponent(oldComponent);
    rebuild();
  }

  @override
  void unmount() {
    super.unmount();
    _state.dispose();
    _state._element = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _state.didChangeDependencies();
  }

  @override
  void reassemble() {
    _state.reassemble();
    super.reassemble();
  }
}

/// Error thrown by the framework
class FlutterError extends Error {
  FlutterError(this.message);
  final String message;
  @override
  String toString() => message;
}
