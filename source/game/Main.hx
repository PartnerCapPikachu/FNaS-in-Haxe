package game;

#if cpp
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#elseif java
import java.vm.Gc;
#elseif neko
import neko.vm.Gc;
#end

class Main extends openfl.display.Sprite
{
  public static function main():Void
  {
    CrashHandler.initialize();
    openfl.Lib.current.addChild(new Main());
  }

  @:allow(game.Init)
  static function cache():Void
  {
    var images:Array<String> = Util.scanDirectory('images');
    while (images.length != 0)
      AssetManager.getSparrow(images.shift().substr('assets/images/'.length));

    var oggs:Array<String> = Util.scanDirectory('music', '.ogg').concat(Util.scanDirectory('sounds', '.ogg'));
    while (oggs.length != 0)
      AssetManager.getOgg(oggs.shift().substr('assets/'.length));

	//gulp
	#if (cpp || hl || java || neko)
	#if (cpp || java || neko)
	Gc.run(true);
	#end
	#if cpp
	Gc.compact();
	#end
	#if hl
	Gc.major();
	#end
	#end
  }

  public function new():Void
  {
    super();
    addChild(new FlxGame(500, 500, Init, 60, 60, false, #if FLX_DEBUG false #else true #end));
    addChild(new game.display.FPS());
  }
}