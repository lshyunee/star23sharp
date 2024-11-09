import 'package:flutter/material.dart';
import 'package:star23sharp/widgets/index.dart';

class StarWriteTypeModal extends StatelessWidget {
  const StarWriteTypeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIhelper.deviceWidth(context) * 0.07,
      width: UIhelper.deviceWidth(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // 보물 편지 버튼 클릭 시 동작
              Navigator.pop(context, '/map'); // 모달 닫고 데이터 전달
            },
            child: const Text("보물 편지 보내기"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // 일반 편지 버튼 클릭 시 동작
              Navigator.pop(context, '/starwriteform'); // 모달 닫고 데이터 전달
            },
            child: const Text("일반 편지 보내기"),
          ),
        ],
      ),
    );
  }
}
