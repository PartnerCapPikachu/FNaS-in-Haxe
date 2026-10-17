package game.objects.built;

class Office extends flixel.group.FlxSpriteGroup
{
  public var office:Sprite;
  public var poster:Sprite;
  public var fan:Sprite;
  public var lightL:Sprite;
  public var doreL:Sprite;
  public var lightR:Sprite;
  public var doreR:Sprite;
  public var buttonDoreL:Button;
  public var buttonLightL:Button;
  public var buttonDoreR:Button;
  public var buttonLightR:Button;

  public var goldensonic:Sprite;
  public var sonic:Sprite;
  public var sonicpowerout:Sprite;
  public var mario:Sprite;
  public var yoshi:Sprite;

  public var leftDoorClosed(default, null):Bool = false;
  public var leftLightOn(default, null):Bool = false;
  public var rightDoorClosed(default, null):Bool = false;
  public var rightLightOn(default, null):Bool = false;

  public function new(?X:Float = 0, ?Y:Float = 0, ?MaxSize:Int = 0):Void
  {
    super(X, Y, MaxSize);
    initOffice();
    initCharacters();
    completeOffice();
  }

  function initOffice():Void
  {
    var officeFrames = AssetManager.getSparrow('Office/office');
    var doreFramesLeft = AssetManager.getSparrow('Office/leftdoor');
    var doreFramesRight = AssetManager.getSparrow('Office/rightdoor');
    var doreButtonFrames = AssetManager.getSparrow('Buttons/dore_button');
    var lightButtonFrames = AssetManager.getSparrow('Buttons/light_button');

    office = new Sprite();
    office.frames = officeFrames;
    office.animation.addByPrefix('idle', 'office', 24, false);
    office.play('idle');

    poster = new Sprite(176, 92);
    poster.frames = officeFrames;
    poster.animation.addByPrefix('idle', 'poster', 24, false);
    poster.play('idle', false, false, 0, false);

    fan = new Sprite(230, 217);
    fan.frames = officeFrames;
    fan.animation.addByPrefix('idle', 'fan', 24, true);
    fan.play('idle');

    doreL = new Sprite();
    doreL.frames = doreFramesLeft;
    doreL.animation.addByPrefix('idle', 'closing', 24, false);
    doreL.play('idle', true);
    doreL.animation.pause();

    doreR = new Sprite();
    doreR.frames = doreFramesRight;
    doreR.animation.addByPrefix('idle', 'closing', 24, false);
    doreR.play('idle', true);
    doreR.animation.pause();

    lightL = new Sprite();
    lightL.frames = doreFramesLeft;
    lightL.animation.addByPrefix('idle', 'light', 24, false);
    lightL.play('idle', true, false, 0, false);
    lightL.visible = false;

    lightR = new Sprite();
    lightR.frames = doreFramesRight;
    lightR.animation.addByPrefix('idle', 'light', 24, false);
    lightR.play('idle', true, false, 0, false);
    lightR.visible = false;

    buttonDoreL = new Button(-4 + 5, 210);
    buttonDoreL.frames = doreButtonFrames;
    buttonDoreL.animation.addByPrefix('off', 'dore_off', 24, false);
    buttonDoreL.animation.addByPrefix('on', 'dore_on', 24, false);
    buttonDoreL.play('off');
    buttonDoreL.setHitboxSize(25, 30);
    buttonDoreL.setHitboxOffset(-16, -16.5);
    buttonDoreL.clickToTrigger = true;
    buttonDoreL.setMouseCheckOffset(4, 2);
    buttonDoreL.onHitboxHit = function():Void
    {
      buttonDoreL.play(leftDoorClosed ? 'off' : 'on', true);
      if (leftDoorClosed) doreL.animation.curAnim.reverse();
      else doreL.animation.curAnim.play(true, false, doreL.animation.curAnim.curFrame);
      leftDoorClosed = !leftDoorClosed;
    }

    buttonLightL = new Button(-4 + 5, 250);
    buttonLightL.frames = lightButtonFrames;
    buttonLightL.animation.addByPrefix('off', 'light_off', 24, false);
    buttonLightL.animation.addByPrefix('on', 'light_on', 24, false);
    buttonLightL.play('off');
    buttonLightL.setHitboxSize(25, 30);
    buttonLightL.setHitboxOffset(-16, -16.5);
    buttonLightL.clickToTrigger = true;
    buttonLightL.setMouseCheckOffset(4, 2);
    buttonLightL.onHitboxHit = function():Void
    {
      buttonLightL.play(lightL.visible ? 'off' : 'on', true);
      leftLightOn = !leftLightOn;
      lightL.visible = leftLightOn;

      if (rightLightOn)
      {
        buttonLightR.play('off', true);
        rightLightOn = false;
        lightR.visible = false;
      }
    }

    buttonDoreR = new Button(0, 210);
    buttonDoreR.frames = doreButtonFrames;
    buttonDoreR.animation.addByPrefix('off', 'dore_off', 24, false);
    buttonDoreR.animation.addByPrefix('on', 'dore_on', 24, false);
    buttonDoreR.play('off');
    buttonDoreR.x = (FlxG.width - buttonDoreR.width) + 4 - 5;
    buttonDoreR.setHitboxSize(25, 30);
    buttonDoreR.setHitboxOffset(-16, -16.5);
    buttonDoreR.clickToTrigger = true;
    buttonDoreR.setMouseCheckOffset(4, 2);
    buttonDoreR.onHitboxHit = function():Void
    {
      buttonDoreR.play(rightDoorClosed ? 'off' : 'on', true);
      if (rightDoorClosed) doreR.animation.curAnim.reverse();
      else doreR.animation.curAnim.play(true, false, doreR.animation.curAnim.curFrame);
      rightDoorClosed = !rightDoorClosed;
    }

    buttonLightR = new Button(0, 250);
    buttonLightR.frames = lightButtonFrames;
    buttonLightR.animation.addByPrefix('off', 'light_off', 24, false);
    buttonLightR.animation.addByPrefix('on', 'light_on', 24, false);
    buttonLightR.play('off');
    buttonLightR.x = (FlxG.width - buttonLightR.width) + 4 - 5;
    buttonLightR.setHitboxSize(25, 30);
    buttonLightR.setHitboxOffset(-16, -16.5);
    buttonLightR.clickToTrigger = true;
    buttonLightR.setMouseCheckOffset(4, 2);
    buttonLightR.onHitboxHit = function():Void
    {
      buttonLightR.play(lightR.visible ? 'off' : 'on', true);
      rightLightOn = !rightLightOn;
      lightR.visible = rightLightOn;

      if (leftLightOn)
      {
        buttonLightL.play('off', true);
        leftLightOn = false;
        lightL.visible = false;
      }
    }
  }

  function initCharacters():Void
  {
    goldensonic = new Sprite();
    goldensonic.frames = AssetManager.getSparrow('Office/golden_in_office');
    goldensonic.animation.addByPrefix('idle', 'fade', 24, false);
    goldensonic.play('idle');
    goldensonic.visible = false;

    (sonic = new Sprite()).loadGraphic(AssetManager.getImage('Office/sonic'));
    sonic.visible = false;

    (sonicpowerout = new Sprite()).loadGraphic(AssetManager.getImage('Office/sonic_po'));
    sonicpowerout.visible = false;

    (mario = new Sprite()).loadGraphic(AssetManager.getImage('Office/mario'));
    mario.visible = false;

    (yoshi = new Sprite()).loadGraphic(AssetManager.getImage('Office/yoshi'));
    yoshi.visible = false;
  }

  function completeOffice():Void
  {
    add(office);
    add(poster);
    add(fan);
    add(goldensonic);

    add(lightL);
    add(mario);
    add(sonicpowerout);
    add(doreL);

    add(lightR);
    add(yoshi);
    add(sonic);
    add(doreR);

    add(buttonDoreL);
    add(buttonLightL);

    add(buttonDoreR);
    add(buttonLightR);
  }
}