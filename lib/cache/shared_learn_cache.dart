import 'package:caching_computer/cache/shared_manager.dart';
import 'package:flutter/material.dart';

class SharedLearnCacheView extends StatefulWidget {
  const SharedLearnCacheView({super.key});

  @override
  State<SharedLearnCacheView> createState() => _SharedLearnCacheViewState();
}

class _SharedLearnCacheViewState extends LoadingWidget<SharedLearnCacheView> {
  int _currentValue = 0;
  late final SharedManager _manager;

  @override
  void initState() {
    super.initState();
    _manager = SharedManager();
    _initialize();
  }

  Future<void> _initialize() async {
    changeLoading();
    await _manager.init();
    changeLoading();
    getDefaultValues();
  }

  void _onChangeValue(String value) {
    final _value = int.tryParse(value);

    if (_value != null) {
      setState(() {
        _currentValue = _value;
      });
    }
  }

  Future<void> getDefaultValues() async {
    _onChangeValue(_manager.getString(SharedKeys.counter) ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentValue.toString()),
        actions: [
          isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).scaffoldBackgroundColor,
                )
              : const SizedBox.shrink()
        ],
      ),
      body: TextField(
        onChanged: (value) {
          _onChangeValue(value);
        },
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _saveValueButton(),
          _removeValueButton(),
        ],
      ),
    );
  }

  FloatingActionButton _saveValueButton() {
    return FloatingActionButton(
      child: const Icon(Icons.save),
      onPressed: () async {
        changeLoading();
        await _manager.saveString(SharedKeys.counter, _currentValue.toString());
        changeLoading();
      },
    );
  }

  FloatingActionButton _removeValueButton() {
    return FloatingActionButton(
      child: const Icon(Icons.delete),
      onPressed: () async {
        changeLoading();
        await _manager.removeItem(SharedKeys.counter);
        changeLoading();
      },
    );
  }
}

//abstract class tanımlayarak bu widgetı tüm projede kullanabilirim
abstract class LoadingWidget<T extends StatefulWidget> extends State<T> {
  bool isLoading = false;

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
