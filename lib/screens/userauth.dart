import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> registerUser(String userId, String userName) async {
  final avatarUrls = [
    'https://i1.sndcdn.com/avatars-000112742232-y1bpmi-t500x500.jpg',
    'https://miro.medium.com/v2/resize:fit:2400/2*VbG-KPhDrqdcBpcU6GGsYA.png',
    'https://t4.ftcdn.net/jpg/00/94/66/91/360_F_94669163_taoLbRaIz4V2DnEjWZg17V9WygRubBuK.jpg',
    'https://p0.zoon.ru/preview/OLyGnGSBgJX7deGc0gRtPA/2400x1500x85/1/f/a/original_57d8b60640c08816228bf876_57e826c695508.jpg',
    'https://i.pinimg.com/originals/fc/67/03/fc6703e79d41363832817cbdf297beaa.jpg',
    'https://m.media-amazon.com/images/I/B1iSr2M+s-S.jpg',
    'https://jobhelp.campaign.gov.uk/cymraeg/wp-content/uploads/sites/3/2024/04/Capture1.jpg',
    'https://yudent.ru/wp-content/uploads/2020/03/slide3.jpg',
    'https://thumbs.dreamstime.com/b/young-smiling-relaxed-corporate-guy-38456451.jpg',
    'https://avatars.mds.yandex.net/i?id=9fd484d6ce1e2e4fb961f8a5333b64c06155d66f-2037526-images-thumbs&n=13',
    'https://www.mehmetkazandi.com/wp-content/uploads/2015/09/implant-09.jpg',
  ];
  final randomAvatar = avatarUrls[Random().nextInt(avatarUrls.length)];

  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'name': userName,
    'photoUrl': randomAvatar,
  });
}
