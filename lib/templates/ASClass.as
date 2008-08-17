class <%= @project_name %> {
  var _timeline:MovieClip;
  function <%= @project_name %>(timeline){
    _timeline = timeline;
  }
  static function main(tl:MovieClip){
    var app:<%= @project_name %> = new <%= @project_name %>(tl);
  }
}
