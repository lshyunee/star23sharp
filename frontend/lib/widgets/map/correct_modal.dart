import 'package:flutter/material.dart';
import 'package:star23sharp/widgets/index.dart';

class CorrectModal extends StatelessWidget {
  final Map<String, dynamic> markerData;

  const CorrectModal({
    Key? key,
    required this.markerData,
  }) : super(key: key);

  static void show(BuildContext context, Map<String, dynamic> markerData) {
    showDialog(
      context: context,
      builder: (_) => CorrectModal(markerData: markerData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: UIhelper.deviceHeight(context) * 0.1,
          left: UIhelper.deviceWidth(context) * 0.01,
          right: UIhelper.deviceWidth(context) * 0.01,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: UIhelper.deviceWidth(context),
              height: UIhelper.deviceHeight(context) * 0.5,
              decoration: BoxDecoration(
                color: const Color(0xFF9588E7).withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  // 오른쪽 상단 닫기 버튼
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  // 주요 내용
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32), // IconButton 공간 확보
                        Center(
                          child: Text(
                            markerData['title'] ?? "정답 확인",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "힌트사진!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: SizedBox(
                                    width: 320,
                                    height: 200,
                                    child: markerData["hintImg"] != null
                                        ? Image(
                                            image: markerData["hintImg"],
                                          )
                                        : const SizedBox(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "정답 메시지",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  markerData['hint'] ?? "축하합니다, 정답을 맞추셨습니다!",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 하단 버튼 영역
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("확인"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
