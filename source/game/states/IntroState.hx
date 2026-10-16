package game.states;

class IntroState extends FlxState
{
  var introImage:FlxSprite;
  var load:FlxState;

  override function create():Void
  {
    super.create();
    persistentUpdate = true;

    introImage = new FlxSprite().loadGraphic(AssetManager.getImage('Intro/Intro'));
    add(introImage);

    load = new Game();
    new flixel.util.FlxTimer().start(3, _ -> FlxG.switchState(load));
  }
}
