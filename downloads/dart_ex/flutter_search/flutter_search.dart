import 'dart:async';

import 'package:flutter/material.dart';


void main() => runApp(new ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Material Search Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Material Search Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _names =  [
    'Igor Minar',
    'Brad Green',
    'Dave Geddes',
    'Naomi Black',
    'Greg Weber',
    'Dean Sofer',
    'Wes Alvaro',
    'John Scott',
    'Daniel Nadasi',
  ];

  String _name = 'No one';

  final _formKey = new GlobalKey<FormState>();

  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
      settings: new RouteSettings(
        name: 'material_search',
        isInitialRoute: false,
      ),
      builder: (BuildContext context) {
        return new Material(
          child: new MaterialSearch<String>(
            placeholder: 'Search',
            results: _names.map((String v) => new MaterialSearchResult<String>(
              icon: Icons.person,
              value: v,
              text: "Mr(s). $v",
            )).toList(),
            filter: (dynamic value, String criteria) {
              return value.toLowerCase().trim()
                .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
            },
            onSelect: (dynamic value) => Navigator.of(context).pop(value),
            onSubmit: (String value) => Navigator.of(context).pop(value),
          ),
        );
      }
    );
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
      .push(_buildMaterialSearchPage(context))
      .then((dynamic value) {
        setState(() => _name = value as String);
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              _showMaterialSearch(context);
            },
            tooltip: 'Search',
            icon: new Icon(Icons.search),
          )
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
              child: new Text("You found: ${_name ?? 'No one'}"),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: new Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    new MaterialSearchInput<String>(
                      placeholder: 'Name',
                      results: _names.map((String v) => new MaterialSearchResult<String>(
                        icon: Icons.person,
                        value: v,
                        text: "Mr(s). $v",
                      )).toList(),
                      filter: (dynamic value, String criteria) {
                        return value.toLowerCase().trim()
                          .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
                      },
                      onSelect: (dynamic v) {
                        print(v);
                      },
                      validator: (dynamic value) => value == null ? 'Required field' : null,
                      formatter: (dynamic v) => 'Hello, $v',
                    ),
                    new MaterialButton(
                      child: new Text('Validate'),
                      onPressed: () {
                        _formKey.currentState.validate();
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _showMaterialSearch(context);
        },
        tooltip: 'Search',
        child: new Icon(Icons.search),
      ),
    );
  }
}

typedef String FormFieldFormatter<T>(T v);
typedef bool MaterialSearchFilter<T>(T v, String c);
typedef int MaterialSearchSort<T>(T a, T b, String c);
typedef Future<List<MaterialSearchResult>> MaterialResultsFinder(String c);
typedef void OnSubmit(String value);

class MaterialSearchResult<T> extends StatelessWidget {
  const MaterialSearchResult({
    Key key,
    this.value,
    this.text,
    this.icon,
  }) : super(key: key);

  final T value;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(width: 70.0, child: new Icon(icon)),
          new Expanded(child: new Text(text, style: Theme.of(context).textTheme.subhead)),
        ],
      ),
      height: 56.0,
    );
  }
}

class MaterialSearch<T> extends StatefulWidget {
  MaterialSearch({
    Key key,
    this.placeholder,
    this.placeholderColor = Colors.black87,
    this.results,
    this.getResults,
    this.filter,
    this.sort,
    this.limit: 10,
    this.onSelect,
    this.onSubmit,
    this.barBackgroundColor = Colors.white,
    this.barTitleColor = Colors.black,
    this.iconColor = Colors.black,
    this.leading,
  }) : assert(() {
         if (results == null && getResults == null
             || results != null && getResults != null) {
           throw new AssertionError('Either provide a function to get the results, or the results.');
         }

         return true;
       }()),
       super(key: key);

  final String placeholder;

  final List<MaterialSearchResult<T>> results;
  final MaterialResultsFinder getResults;
  final MaterialSearchFilter<T> filter;
  final MaterialSearchSort<T> sort;
  final int limit;
  final ValueChanged<T> onSelect;
  final OnSubmit onSubmit;
  final Color barBackgroundColor;
  final Color barTitleColor;
  final Color placeholderColor;
  final Color iconColor;
  final Widget leading;

  @override
  _MaterialSearchState<T> createState() => new _MaterialSearchState<T>();
}

class _MaterialSearchState<T> extends State<MaterialSearch> {
  bool _loading = false;
  List<MaterialSearchResult<T>> _results = [];

  String _criteria = '';
  TextEditingController _controller = new TextEditingController();

  _filter(dynamic v, String c) {
    return v.toString().toLowerCase().trim()
      .contains(new RegExp(r'' + c.toLowerCase().trim() + ''));
  }

  @override
  void initState() {
    super.initState();

    if (widget.getResults != null) {
      _getResultsDebounced();
    }

    _controller.addListener(() {
      setState(() {
        _criteria = _controller.value.text;
        if (widget.getResults != null) {
          _getResultsDebounced();
        }
      });
    });
  }

  Timer _resultsTimer;
  Future _getResultsDebounced() async {
    if (_results.length == 0) {
      setState(() {
        _loading = true;
      });
    }

    if (_resultsTimer != null && _resultsTimer.isActive) {
      _resultsTimer.cancel();
    }

    _resultsTimer = new Timer(new Duration(milliseconds: 400), () async {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = true;
      });

      //TODO: debounce widget.results too
      var results = await widget.getResults(_criteria);

      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _results = results;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _resultsTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var results = (widget.results ?? _results)
      .where((MaterialSearchResult result) {
        if (widget.filter != null) {
          return widget.filter(result.value, _criteria);
        }
        //only apply default filter if used the `results` option
        //because getResults may already have applied some filter if `filter` option was omited.
        else if (widget.results != null) {
          return _filter(result.value, _criteria);
        }

        return true;
      })
      .toList();

    if (widget.sort != null) {
      results.sort((a, b) => widget.sort(a.value, b.value, _criteria));
    }

    results = results
      .take(widget.limit)
      .toList();

    IconThemeData iconTheme = Theme.of(context).iconTheme.copyWith(color: widget.iconColor);

    return new Scaffold(
      appBar: new AppBar(
        leading: widget.leading,
        backgroundColor: widget.barBackgroundColor,
        iconTheme: iconTheme,
        title: new TextField(
          controller: _controller,
          autofocus: true,
          decoration: new InputDecoration.collapsed(
              hintText: widget.placeholder, hintStyle: TextStyle(color: widget.placeholderColor)),
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.title.fontFamily,
              fontSize: Theme.of(context).textTheme.title.fontSize,
              color: widget.barTitleColor),
          onSubmitted: (String value) {
            if (widget.onSubmit != null) {
              widget.onSubmit(value);
            }
          },
        ),
        actions: _criteria.length == 0 ? [] : [
          new IconButton(
            icon: new Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _controller.text = _criteria = '';
              });
            }
          ),
        ],
      ),
      body: _loading
        ? new Center(
            child: new Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: new CircularProgressIndicator()
            ),
          )
        : new SingleChildScrollView(
            child: new Column(
              children: results.map((MaterialSearchResult result) {
                return new InkWell(
                  onTap: () => widget.onSelect(result.value),
                  child: result,
                );
              }).toList(),
            ),
          ),
    );
  }
}

class _MaterialSearchPageRoute<T> extends MaterialPageRoute<T> {
  _MaterialSearchPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
    maintainState: true,
    bool fullscreenDialog: false,
  }) : assert(builder != null),
        super(builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
}

class MaterialSearchInput<T> extends StatefulWidget {
  MaterialSearchInput({
    Key key,
    this.onSaved,
    this.validator,
    this.autovalidate,
    this.placeholder,
    this.formatter,
    this.results,
    this.getResults,
    this.filter,
    this.sort,
    this.onSelect,
  });

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final bool autovalidate;
  final String placeholder;
  final FormFieldFormatter<T> formatter;

  final List<MaterialSearchResult<T>> results;
  final MaterialResultsFinder getResults;
  final MaterialSearchFilter<T> filter;
  final MaterialSearchSort<T> sort;
  final ValueChanged<T> onSelect;

  @override
  _MaterialSearchInputState<T> createState() => new _MaterialSearchInputState<T>();
}

class _MaterialSearchInputState<T> extends State<MaterialSearchInput<T>> {
  GlobalKey<FormFieldState<T>> _formFieldKey = new GlobalKey<FormFieldState<T>>();

  _buildMaterialSearchPage(BuildContext context) {
    return new _MaterialSearchPageRoute<T>(
      settings: new RouteSettings(
        name: 'material_search',
        isInitialRoute: false,
      ),
      builder: (BuildContext context) {
        return new Material(
          child: new MaterialSearch<T>(
            placeholder: widget.placeholder,
            results: widget.results,
            getResults: widget.getResults,
            filter: widget.filter,
            sort: widget.sort,
            onSelect: (dynamic value) => Navigator.of(context).pop(value),
          ),
        );
      }
    );
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
      .push(_buildMaterialSearchPage(context))
      .then((dynamic value) {
        if (value != null) {
          _formFieldKey.currentState.didChange(value);
          widget.onSelect(value);
        }
      });
  }

  bool get autovalidate {
    return widget.autovalidate ?? Form.of(context)?.widget?.autovalidate ?? false;
  }

  bool _isEmpty(field) {
    return field.value == null;
  }

  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.subhead;

    return new InkWell(
      onTap: () => _showMaterialSearch(context),
      child: new FormField<T>(
        key: _formFieldKey,
        validator: widget.validator,
        onSaved: widget.onSaved,
        autovalidate: autovalidate,
        builder: (FormFieldState<T> field) {
          return new InputDecorator(
            baseStyle: valueStyle,
            isEmpty: _isEmpty(field),
            decoration: new InputDecoration(
              labelStyle: _isEmpty(field) ? null : valueStyle,
              labelText: widget.placeholder,
              errorText: field.errorText,
            ),
            child: _isEmpty(field) ? null : new Text(
              widget.formatter != null
                ? widget.formatter(field.value)
                : field.value.toString(),
              style: valueStyle
            ),
          );
        },
      ),
    );
  }
}

// 以下為 meta.dart 程式庫, 若非在 Dartpad 中執行, 必須利用
// import 'package:meta/meta.dart'; 導入

// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Constants for use in metadata annotations.
///
/// See also `@deprecated` and `@override` in the `dart:core` library.
///
/// Annotations provide semantic information that tools can use to provide a
/// better user experience. For example, an IDE might not autocomplete the name
/// of a function that's been marked `@deprecated`, or it might display the
/// function's name differently.
///
/// For information on installing and importing this library, see the [meta
/// package on pub.dev](https://pub.dev/packages/meta).  For examples of using
/// annotations, see
/// [Metadata](https://dart.dev/guides/language/language-tour#metadata) in the
/// language tour.

/// Used to annotate a function `f`. Indicates that `f` always throws an
/// exception. Any functions that override `f`, in class inheritence, are also
/// expected to conform to this contract.
///
/// Tools, such as the analyzer, can use this to understand whether a block of
/// code "exits". For example:
///
/// ```dart
/// @alwaysThrows toss() { throw 'Thrown'; }
///
/// int fn(bool b) {
///   if (b) {
///     return 0;
///   } else {
///     toss();
///     print("Hello.");
///   }
/// }
/// ```
///
/// Without the annotation on `toss`, it would look as though `fn` doesn't
/// always return a value. The annotation shows that `fn` does always exit. In
/// addition, the annotation reveals that any statements following a call to
/// `toss` (like the `print` call) are dead code.
///
/// Tools, such as the analyzer, can also expect this contract to be enforced;
/// that is, tools may emit warnings if a function with this annotation
/// _doesn't_ always throw.
const _AlwaysThrows alwaysThrows = const _AlwaysThrows();

/// Used to annotate a parameter of an instance method that overrides another
/// method.
///
/// Indicates that this parameter may have a tighter type than the parameter on
/// its superclass. The actual argument will be checked at runtime to ensure it
/// is a subtype of the overridden parameter type.
///
/// DEPRECATED: Use the `covariant` modifier instead.
@deprecated
const _Checked checked = const _Checked();

/// Used to annotate a library, or any declaration that is part of the public
/// interface of a library (such as top-level members, class members, and
/// function parameters) to indicate that the annotated API is experimental and
/// may be removed or changed at any-time without updating the version of the
/// containing package, despite the fact that it would otherwise be a breaking
/// change.
///
/// If the annotation is applied to a library then it is equivalent to applying
/// the annotation to all of the top-level members of the library. Applying the
/// annotation to a class does *not* apply the annotation to subclasses, but
/// does apply the annotation to members of the class.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with a declaration that is not part of the
///   public interface of a library (such as a local variable or a declaration
///   that is private) or a directive other than the first directive in the
///   library, or
/// * the declaration is referenced by a package that has not explicitly
///   indicated its intention to use experimental APIs (details TBD).
const _Experimental experimental = const _Experimental();

/// Used to annotate an instance or static method `m`. Indicates that `m` must
/// either be abstract or must return a newly allocated object or `null`. In
/// addition, every method that either implements or overrides `m` is implicitly
/// annotated with this same annotation.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than a method, or
/// * a method that has this annotation can return anything other than a newly
///   allocated object or `null`.
const _Factory factory = const _Factory();

/// Used to annotate a class `C`. Indicates that `C` and all subtypes of `C`
/// must be immutable.
///
/// A class is immutable if all of the instance fields of the class, whether
/// defined directly or inherited, are `final`.
///
/// Tools, such as the analyzer, can provide feedback if
/// * the annotation is associated with anything other than a class, or
/// * a class that has this annotation or extends, implements or mixes in a
///   class that has this annotation is not immutable.
const Immutable immutable = const Immutable();

/// Used to annotate a test framework function that runs a single test.
///
/// Tools, such as IDEs, can show invocations of such function in a file
/// structure view to help the user navigating in large test files.
///
/// The first parameter of the function must be the description of the test.
const _IsTest isTest = const _IsTest();

/// Used to annotate a test framework function that runs a group of tests.
///
/// Tools, such as IDEs, can show invocations of such function in a file
/// structure view to help the user navigating in large test files.
///
/// The first parameter of the function must be the description of the group.
const _IsTestGroup isTestGroup = const _IsTestGroup();

/// Used to annotate a const constructor `c`. Indicates that any invocation of
/// the constructor must use the keyword `const` unless one or more of the
/// arguments to the constructor is not a compile-time constant.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than a const constructor,
///   or
/// * an invocation of a constructor that has this annotation is not invoked
///   using the `const` keyword unless one or more of the arguments to the
///   constructor is not a compile-time constant.
const _Literal literal = const _Literal();

/// Used to annotate an instance method `m`. Indicates that every invocation of
/// a method that overrides `m` must also invoke `m`. In addition, every method
/// that overrides `m` is implicitly annotated with this same annotation.
///
/// Note that private methods with this annotation cannot be validly overridden
/// outside of the library that defines the annotated method.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than an instance method,
///   or
/// * a method that overrides a method that has this annotation can return
///   without invoking the overridden method.
const _MustCallSuper mustCallSuper = const _MustCallSuper();

/// Used to annotate an instance member (method, getter, setter, operator, or
/// field) `m` in a class `C` or mixin `M`. Indicates that `m` should not be
/// overridden in any classes that extend or mixin `C` or `M`.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than an instance member,
/// * the annotation is associated with an abstract member (because subclasses
///   are required to override the member),
/// * the annotation is associated with an extension method,
/// * the annotation is associated with a member `m` in class `C`, and there is
///   a class `D` or mixin `M`, that extends or mixes in `C`, that declares an
///   overriding member `m`.
const _NonVirtual nonVirtual = const _NonVirtual();

/// Used to annotate a class, mixin, or extension declaration `C`. Indicates
/// that any type arguments declared on `C` are to be treated as optional.
/// Tools such as the analyzer and linter can use this information to suppress
/// warnings that would otherwise require type arguments on `C` to be provided.
const _OptionalTypeArgs optionalTypeArgs = const _OptionalTypeArgs();

/// Used to annotate an instance member (method, getter, setter, operator, or
/// field) `m` in a class `C`. If the annotation is on a field it applies to the
/// getter, and setter if appropriate, that are induced by the field. Indicates
/// that `m` should only be invoked from instance methods of `C` or classes that
/// extend, implement or mix in `C`, either directly or indirectly. Additionally
/// indicates that `m` should only be invoked on `this`, whether explicitly or
/// implicitly.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than an instance member,
///   or
/// * an invocation of a member that has this annotation is used outside of an
///   instance member defined on a class that extends or mixes in (or a mixin
///   constrained to) the class in which the protected member is defined.
/// * an invocation of a member that has this annotation is used within an
///   instance method, but the receiver is something other than `this`.
const _Protected protected = const _Protected();

/// Used to annotate a named parameter `p` in a method or function `f`.
/// Indicates that every invocation of `f` must include an argument
/// corresponding to `p`, despite the fact that `p` would otherwise be an
/// optional parameter.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than a named parameter,
/// * the annotation is associated with a named parameter in a method `m1` that
///   overrides a method `m0` and `m0` defines a named parameter with the same
///   name that does not have this annotation, or
/// * an invocation of a method or function does not include an argument
///   corresponding to a named parameter that has this annotation.
const Required required = const Required();

/// Annotation marking a class as not allowed as a super-type.
///
/// Classes in the same package as the marked class may extend, implement or
/// mix-in the annotated class.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with anything other than a class,
/// * the annotation is associated with a class `C`, and there is a class or
///   mixin `D`, which extends, implements, mixes in, or constrains to `C`, and
///   `C` and `D` are declared in different packages.
const _Sealed sealed = const _Sealed();

/// Used to annotate a field that is allowed to be overridden in Strong Mode.
///
/// Deprecated: Most of strong mode is now the default in 2.0, but the notion of
/// virtual fields was dropped, so this annotation no longer has any meaning.
/// Uses of the annotation should be removed.
@deprecated
const _Virtual virtual = const _Virtual();

/// Used to annotate an instance member that was made public so that it could be
/// overridden but that is not intended to be referenced from outside the
/// defining library.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with a declaration other than a public
///   instance member in a class or mixin, or
/// * the member is referenced outside of the defining library.
const _VisibleForOverriding visibleForOverriding =
    const _VisibleForOverriding();

/// Used to annotate a declaration was made public, so that it is more visible
/// than otherwise necessary, to make code testable.
///
/// Tools, such as the analyzer, can provide feedback if
///
/// * the annotation is associated with a declaration not in the `lib` folder
///   of a package, or a private declaration, or a declaration in an unnamed
///   static extension, or
/// * the declaration is referenced outside of its the defining library or a
///   library which is in the `test` folder of the defining package.
const _VisibleForTesting visibleForTesting = const _VisibleForTesting();

/// Used to annotate a class.
///
/// See [immutable] for more details.
class Immutable {
  /// A human-readable explanation of the reason why the class is immutable.
  final String reason;

  /// Initialize a newly created instance to have the given [reason].
  const Immutable([this.reason = '']);
}

/// Used to annotate a named parameter `p` in a method or function `f`.
///
/// See [required] for more details.
class Required {
  /// A human-readable explanation of the reason why the annotated parameter is
  /// required. For example, the annotation might look like:
  ///
  ///     ButtonWidget({
  ///         Function onHover,
  ///         @Required('Buttons must do something when pressed')
  ///         Function onPressed,
  ///         ...
  ///     }) ...
  final String reason;

  /// Initialize a newly created instance to have the given [reason].
  const Required([this.reason = '']);
}

class _AlwaysThrows {
  const _AlwaysThrows();
}

class _Checked {
  const _Checked();
}

class _Experimental {
  const _Experimental();
}

class _Factory {
  const _Factory();
}

class _IsTest {
  const _IsTest();
}

class _IsTestGroup {
  const _IsTestGroup();
}

class _Literal {
  const _Literal();
}

class _MustCallSuper {
  const _MustCallSuper();
}

class _NonVirtual {
  const _NonVirtual();
}

class _OptionalTypeArgs {
  const _OptionalTypeArgs();
}

class _Protected {
  const _Protected();
}

class _Sealed {
  const _Sealed();
}

@deprecated
class _Virtual {
  const _Virtual();
}

class _VisibleForOverriding {
  const _VisibleForOverriding();
}

class _VisibleForTesting {
  const _VisibleForTesting();
}
