class Data {
  bool cursor = false;
  bool state_select = false;
  String src = "";
  String name = "";

  Data({this.src = "", this.cursor = false, this.name = ""});

  set_active_cursor() {
    cursor = true;
  }

  set_unactive_cursor() {
    cursor = false;
  }

  set_active_state_select() {
    state_select = true;
  }

  set_unactive_state_select() {
    state_select = false;
  }
}
