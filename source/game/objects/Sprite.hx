package game.objects;

class Sprite extends FlxSprite
{
  public function new(?x:Float = 0, ?y:Float = 0, ?SimpleGraphic:flixel.system.FlxAssets.FlxGraphicAsset):Void
  {
    super(x, y, SimpleGraphic);
    this.active = this.moves = false;
  }

  public function play(name:String, forced:Bool = false, reversed:Bool = false, frame:Int = 0, active:Bool = true):Void
  {
		if (!animation.exists(name)) return;
		animation.play(name, forced, reversed, frame);
    this.active = active && animation.curAnim != null && animation.curAnim.numFrames > 1;
  }
}