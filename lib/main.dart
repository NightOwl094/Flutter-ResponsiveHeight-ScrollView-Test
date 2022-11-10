import 'package:flutter/material.dart';
import 'package:layout_test/need_scroll_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends NeedScrollState<MyHomePage> {
  final dataModels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // final dataModels = [1];

  @override
  Widget build(BuildContext context) {
    // 렌더링 될 아이템 key
    GlobalKey itemBoxKey = GlobalKey();

    // 스크롤 뷰 바로 위 부모 key
    GlobalKey containerKey = GlobalKey();

    //
    GlobalKey firstChildKey = GlobalKey();

    // 렌더링 후 실행,
    // 부모 요소의 두 번째 자식(Scroll View or Column)의 height 와
    // 렌더링 될 아이템들의 총합 height 를 비교해 스크롤이 필요한지를 this.isNeedScroll 에 세팅.
    updateNeedScrollState(
        parentKey: containerKey,
        childKey: firstChildKey,
        itemKey: itemBoxKey,
        itemCount: dataModels.length);

    // 첫 번째 아이템 요소의 key 를 구하면서 아이템 렌더링.
    final itemBoxes = dataModels
        .asMap()
        .entries
        .map((it) => _buildItemBox(key: it.key == 0 ? itemBoxKey : null))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildSurface(children: [
          Expanded(
              child: Column(
            key: containerKey,
            children: [
              _buildHeaderBox(firstChildKey),
              isNeedScroll
                  ? _wrapScrollView(children: itemBoxes)
                  : _wrapBorderedContainer(children: itemBoxes)
            ],
          )),
          _buildButtonBox()
        ]));
  }

  // 콘텐츠 바디
  Widget _buildSurface({required List<Widget> children}) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: children,
          ),
        ));
  }

  // Red Header 영역
  Widget _buildHeaderBox(GlobalKey key) {
    return Container(
      key: key,
      width: double.infinity,
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Header', style: TextStyle(fontSize: 36)),
          Text('Header', style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }

  // 스크롤 뷰로 감싸기
  Widget _wrapScrollView({required List<Widget> children}) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 10, color: Colors.blueAccent),
          ),
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              runSpacing: 12,
              children: children,
            ),
          )),
    );
  }

  // Blue Border 로 감싸기
  Widget _wrapBorderedContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 10, color: Colors.blueAccent),
      ),
      child: Wrap(
        runSpacing: 12,
        children: children,
      ),
    );
  }

  // 렌더링 될 아이템
  Widget _buildItemBox({GlobalKey? key}) {
    return Container(
        key: key, width: double.infinity, height: 100, color: Colors.brown);
  }

  // 화면 최하단 버튼
  Widget _buildButtonBox() {
    return MaterialButton(
        onPressed: () {},
        color: Colors.blue,
        minWidth: double.infinity,
        child: const Text('Next'));
  }
}
