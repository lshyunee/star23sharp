import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star23sharp/models/star_list_item_model.dart';
import 'package:star23sharp/providers/index.dart';
import 'package:star23sharp/services/index.dart';
import 'package:star23sharp/widgets/index.dart';

class StarStoragebox extends StatefulWidget with RouteAware {
  const StarStoragebox({super.key});

  @override
  _StarStorageboxState createState() => _StarStorageboxState();
}

class _StarStorageboxState extends State<StarStoragebox> with RouteAware, SingleTickerProviderStateMixin {
  late int initialIndex;
  int selectedIndex = 0;
  final List<String> dropdownItems = ['전체', '보물 쪽지', '일반 쪽지'];
  String selectedItem = '전체';
  late Future<List<StarListItemModel>?> sent;
  late Future<List<StarListItemModel>?> received;

  @override
  void initState() {
    super.initState();
    sent = StarService.getStarList(true, selectedIndex);
    received = StarService.getStarList(false, selectedIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ModalRoute에서 arguments를 받아서 초기 인덱스를 설정
    initialIndex = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
    sent = StarService.getStarList(true, selectedIndex);
    received = StarService.getStarList(false, selectedIndex);
  }

  // 선택된 값에 따른 데이터 로드
  void _loadData() {
    setState(() {
      sent = StarService.getStarList(true, selectedIndex);
      received = StarService.getStarList(false, selectedIndex);
    });
  }

  void updateSelectedIndex(String? newValue) {
    setState(() {
      selectedItem = newValue!;
      selectedIndex = dropdownItems.indexOf(newValue); // 드롭다운에서 선택된 값의 인덱스를 설정
      _loadData(); // 선택값이 변경되면 다시 데이터를 불러옴
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.68,
            child: Image.asset(
              themeProvider.subBg,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "보관함",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: FontSizes.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton<String>(
                          value: selectedItem,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          dropdownColor: Colors.black.withOpacity(0.6),
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                          onChanged: updateSelectedIndex,
                          items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(
                                fontFamily: 'Hakgyoansim Chilpanjiugae',
                                fontSize: 18
                              ),),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: UIhelper.deviceWidth(context) * 0.8,
                height: UIhelper.deviceHeight(context) * 0.5,
                child: DefaultTabController(
                  length: 2,
                  initialIndex: initialIndex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                        child: TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white70,
                          indicatorColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: FontSizes.label,
                            fontFamily: 'Hakgyoansim Chilpanjiugae',
                          ),
                          tabs: [
                            Tab(text: "받은 쪽지"),
                            Tab(text: "보낸 쪽지"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          // controller: _tabController,  // TabController 적용
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3E1E1).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: FutureBuilder<List<StarListItemModel>?>( 
                                future: received,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == 
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Image.asset(
                                        "assets/img/logo/loading_logo.gif",
                                        height: UIhelper.deviceHeight(context) *
                                            0.3,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text(
                                      '받은 쪽지가 없습니다.',
                                      style: TextStyle(
                                          fontSize: FontSizes.body,
                                          color: Colors.white),
                                    ));
                                  } else {
                                    final List<StarListItemModel> itemsData =
                                        snapshot.data!;
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 5.3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemCount: itemsData.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: index % 2 == 1
                                                ? const Color(0xFFF6F6F6)
                                                    .withOpacity(0.2)
                                                : Colors.white.withOpacity(0),
                                          ),
                                          child: ListItem(
                                            item: itemsData[index],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3E1E1).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: FutureBuilder<List<StarListItemModel>?>(
                                future: sent,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == 
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Image.asset(
                                        "assets/img/logo/loading_logo.gif",
                                        height: UIhelper.deviceHeight(context) * 0.3,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('보낸 쪽지가 없습니다.',
                                            style: TextStyle(
                                                fontSize: FontSizes.body,
                                                color: Colors.white)));
                                  } else {
                                    final List<StarListItemModel> itemsData =
                                        snapshot.data!;
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 5.3, 
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 10,
                                      ),
                                      itemCount: itemsData.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: index % 2 == 1
                                                ? const Color(0xFFF6F6F6)
                                                    .withOpacity(0.2)
                                                : Colors.transparent,
                                          ),
                                          child: ListItem(
                                            item: itemsData[index],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
