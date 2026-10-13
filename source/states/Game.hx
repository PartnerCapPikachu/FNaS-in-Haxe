package states;

class Game extends FlxState
{
  var camCctv:FlxCamera;
  var camUi:FlxCamera;

  override function create():Void
  {
    super.create();
    persistentUpdate = persistentDraw = true;

    camCctv = new FlxCamera();
    camCctv.bgColor.alpha = 0;
    FlxG.cameras.add(camCctv, false);

    camUi = new FlxCamera();
    camUi.bgColor.alpha = 0;
    FlxG.cameras.add(camUi, false);
  }
}