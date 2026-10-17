package game.states;

import game.objects.built.Office;

class Game extends FlxState
{
  var office:Office;

  var camJUMP:FlxCamera;
  var camCCTV:FlxCamera;
  var camUI:FlxCamera;

  override function create():Void
  {
    super.create();
    persistentUpdate = persistentDraw = true;

    camJUMP = new FlxCamera();
    camJUMP.bgColor.alpha = 0;
    FlxG.cameras.add(camJUMP, false);

    camCCTV = new FlxCamera();
    camCCTV.bgColor.alpha = 0;
    FlxG.cameras.add(camCCTV, false);

    camUI = new FlxCamera();
    camUI.bgColor.alpha = 0;
    FlxG.cameras.add(camUI, false);

    office = new Office();
    add(office);
  }
}