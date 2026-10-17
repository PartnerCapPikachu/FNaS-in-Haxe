package game.objects;

class Button extends Sprite
{
  public var hitbox(default, null):FlxSprite;

  public var interactable:Bool = true;
  public var onHitboxHit:Void->Void;
  public var clickToTrigger:Bool = false;
  public var mouseOverlaps(get, never):Bool;
  public var mouseCheckOffsetX:Float = 0;
  public var mouseCheckOffsetY:Float = 0;

  public function new(?x:Float = 0, ?y:Float = 0, ?SimpleGraphic:flixel.system.FlxAssets.FlxGraphicAsset):Void
  {
    hitbox = new Sprite(x, y);
    hitbox.makeGraphic(1, 1, flixel.util.FlxColor.LIME);
    hitbox.visible = false;

    super(x, y, SimpleGraphic);
    active = true;
  }

  public function setHitboxSize(width:Float, height:Float):Void
  {
    if (hitbox != null)
    {
      hitbox.scale.set(width, height);
      hitbox.updateHitbox();
    }
  }

  public function setHitboxOffset(?x:Float = 0, ?y:Float = 0):Void
  {
    if (hitbox != null)
    {
      hitbox.offset.set(x, y);
    }
  }

  public function setMouseCheckOffset(?offsetX:Float = 0, ?offsetY:Float = 0):Void
  {
    mouseCheckOffsetX = offsetX;
    mouseCheckOffsetY = offsetY;
  }

  override function play(name:String, forced:Bool = false, reversed:Bool = false, frame:Int = 0, active:Bool = true):Void
  {
		if (!animation.exists(name)) return;
		animation.play(name, forced, reversed, frame);
    this.active = active;
  }

  override function update(elapsed:Float):Void
  {
    if (!interactable)
    {
      visible = false;
      return;
    }

    if (clickToTrigger)
    {
      if (FlxG.mouse.justPressed && mouseOverlaps && onHitboxHit != null)
        onHitboxHit();
    }
    else if (visible && mouseOverlaps)
    {
      if (onHitboxHit != null)
        onHitboxHit();
      visible = false;
    }
    else if (!visible && !mouseOverlaps)
    {
      visible = true;
    }
  }

  override function draw():Void
  {
    super.draw();

    if (hitbox != null && hitbox.exists && hitbox.visible && hitbox.alpha > 0)
      hitbox.draw();
  }

  override function destroy():Void
  {
    super.destroy();
    onHitboxHit = null;
    hitbox.destroy();
  }

  override function set_x(value:Float):Float
  {
    if (hitbox != null)
      hitbox.x = value;
    return x = value;
  }

  override function set_y(value:Float):Float
  {
    if (hitbox != null)
      hitbox.y = value;
    return y = value;
  }

  function get_mouseOverlaps():Bool
  {
    return Util.mouseOverlaps(this, camera, mouseCheckOffsetX, mouseCheckOffsetY);
  }
}