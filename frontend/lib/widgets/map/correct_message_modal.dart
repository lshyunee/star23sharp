import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:star23sharp/providers/index.dart';
import 'package:star23sharp/widgets/index.dart';

class CorrectMessageModal extends StatelessWidget {
  final VoidCallback onNoteButtonPressed;
  final Map<String, dynamic> markerData;

  const CorrectMessageModal({
    required this.onNoteButtonPressed,
    required this.markerData,
    super.key,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onNoteButtonPressed,
    required Map<String, dynamic> markerData,
  }) {
    showDialog(
      context: context,
      builder: (_) => CorrectMessageModal(
        onNoteButtonPressed: onNoteButtonPressed,
        markerData: markerData,
      ),
    );
  }

  void _showImageModal(BuildContext context, String imageUrl) {
    final deviceWidth = UIhelper.deviceWidth(context);
    final deviceHeight = UIhelper.deviceHeight(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: deviceWidth * 0.8,
                    height: deviceHeight * 0.35,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "확인",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final deviceWidth = UIhelper.deviceWidth(context);
    final deviceHeight = UIhelper.deviceHeight(context);

    return Stack(
      children: [
        Positioned(
          top: deviceHeight * 0.1,
          left: deviceWidth * 0.01,
          right: deviceWidth * 0.01,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: deviceWidth,
              height: deviceHeight * 0.5,
              decoration: BoxDecoration(
                color: themeProvider.mainColor,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "정답입니다!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (markerData['hint_image_first'] !=
                                          null) {
                                        _showImageModal(
                                          context,
                                          markerData['hint_image_first'],
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: deviceWidth * 0.65,
                                      height: deviceHeight * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15,),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                "${markerData['sender_nickname']}님이 이곳에 쪽지를 숨겼어요!",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 12,),
                                              if (markerData[
                                                      'hint_image_first'] !=
                                                  null)
                                                Center(
                                                  child: ClipRRect(
                                                    child: SizedBox(
                                                      width: deviceWidth * 0.5,
                                                      height:
                                                          deviceWidth * 0.35,
                                                      child: markerData[
                                                                  "hint_image_first"] !=
                                                              null
                                                          ? Stack(
                                                              children: [
                                                                Image.network(
                                                                  markerData["hint_image_first"],
                                                                  fit: BoxFit.cover,
                                                                  width: double.infinity,
                                                                  height: double.infinity,
                                                                ),
                                                                Positioned(
                                                                  top: 8, // 이미지의 상단에서 떨어진 거리
                                                                  right: 8, // 이미지의 우측에서 떨어진 거리
                                                                  child: Opacity(
                                                                    opacity: 0.7,
                                                                    child: Container(
                                                                      width: 32,
                                                                      height: 32,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors.black
                                                                            .withOpacity(
                                                                                0.5),
                                                                        shape:
                                                                            BoxShape.circle,
                                                                      ),
                                                                      child: const Icon(
                                                                        Icons.search,
                                                                        color: Colors.white,
                                                                        size: 18,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : const Icon(
                                                              Icons.image,
                                                              color:
                                                                  Colors.grey,
                                                              size: 50,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                          ),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              CorrectModal.show(
                                context,
                                markerData,
                              );
                            },
                            child: const Text(
                              "쪽지 확인",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
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
