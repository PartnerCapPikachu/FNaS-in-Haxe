package states;

import Main;

class IntroState extends FlxState
{
  var introImage:FlxSprite;
  var load:FlxState;

  override function create():Void
  {
    Main.cache();

    super.create();
    persistentUpdate = true;

    introImage = new FlxSprite().loadGraphic(AssetManager.getImage('Intro/Intro'));
    add(introImage);

    load = new Game();
    new flixel.util.FlxTimer().start(3, _ -> FlxG.switchState(load));
  }
}