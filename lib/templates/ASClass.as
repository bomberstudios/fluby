class <%= @project_name %> {
  var mc:MovieClip;
  function <%= @project_name %>(timeline){
    mc = timeline;
  }
  static function main(tl:MovieClip){
    var app:<%= @project_name %> = new <%= @project_name %>(tl);
  }
}
