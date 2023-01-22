import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'package:user_management/screens/fireStore/entity/User.dart' as u;

class ChatScreenController extends GetxController {
  RxList<BaseMessage> messages = <BaseMessage>[].obs;
  final u.User selUser;

  ChatScreenController(this.selUser);

  late User user;
  late GroupChannel channel;

  @override
  void onInit() async{
    user = Get.find<User>();
    GroupChannelParams params = GroupChannelParams()
      ..userIds = [selUser.emailId]
      ..operatorUserIds = [user.userId]
      ..isDistinct = true;

    channel = await GroupChannel.createChannel(params);
    Logger().i(channel.toJson());
    super.onInit();
  }
  Future getChannel()async{
    GroupChannelParams params = GroupChannelParams()
      ..userIds = [selUser.emailId]
      ..operatorUserIds = [user.userId]
      ..isDistinct = true;

    channel = await GroupChannel.createChannel(params);
  }

  Future getMessages() async{
    await getChannel();
    final params = MessageListParams()
      ..isInclusive = false
      ..includeThreadInfo = true
      ..reverse = true
      ..previousResultSize = 20;
    messages.value = await channel.getMessagesByTimestamp(DateTime.now().millisecondsSinceEpoch, params);
    return Future.value();
  }

  Future addMessage(String message) async{
    final params = UserMessageParams(message: message);
    UserMessage msg =  channel.sendUserMessage(params);
    messages.value = [msg,...messages];
  }

}