package game.objects;

class Jumpscare extends Sprite
{
  public function new():Void
  {
    super();
    visible = false;
  }

  public function jump(character:String):Void
  {
    if (frames == null)
      frames = AssetManager.getSparrow('Jumpscares/$character');

    animation.destroyAnimations();
    animation.addByPrefix('jump', 'jumpscare', 24, false);
    play('jump');
    visible = true;
  }
}