// ViewAction types referenced in every vFul screen template
abstract class ViewAction {}

class NavigateScreen extends ViewAction {
  final String target;

  NavigateScreen(this.target);
}

enum MessageType { success, error, info, warning }

class DisplayMessage extends ViewAction {
  final String message;
  final MessageType type;

  DisplayMessage(this.message, {this.type = MessageType.info});
}
