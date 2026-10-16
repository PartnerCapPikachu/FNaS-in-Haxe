package game.states;

import game.objects.Sprite;

class Game extends FlxState
{
  override function create():Void
  {
    super.create();
    persistentUpdate = persistentDraw = true;

    initOffice();
    initCameras();
  }

  var office:Sprite;
  var poster:Sprite;
  var fan:Sprite;
  var lightL:Sprite;
  var doreL:Sprite;
  var lightR:Sprite;
  var doreR:Sprite;
  function initOffice():Void
  {
    var officeFrames = AssetManager.getSparrow('Office/office');
    var doreFramesLeft = AssetManager.getSparrow('Office/leftdoor');
    var doreFramesRight = AssetManager.getSparrow('Office/rightdoor');

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
    doreL.visible = false; //door is not used yet

    doreR = new Sprite();
    doreR.frames = doreFramesRight;
    doreR.animation.addByPrefix('idle', 'closing', 24, false);
    doreR.play('idle', true);
    doreR.visible = false; //door is not used yet

    lightL = new Sprite();
    lightL.frames = doreFramesLeft;
    lightL.animation.addByPrefix('idle', 'light', 24, false);
    lightL.play('idle', true, false, 0, false);
    lightL.visible = false; //light is not used yet

    lightR = new Sprite();
    lightR.frames = doreFramesRight;
    lightR.animation.addByPrefix('idle', 'light', 24, false);
    lightR.play('idle', true, false, 0, false);
    lightR.visible = false; //light is not used yet

    add(office);
    add(poster);
    add(fan);
    add(lightL);
    add(doreL);
    add(lightR);
    add(doreR);
  }

  var camCCTV:FlxCamera;
  var camUI:FlxCamera;
  function initCameras():Void
  {
    camCCTV = new FlxCamera();
    camCCTV.bgColor.alpha = 0;
    FlxG.cameras.add(camCCTV, false);

    camUI = new FlxCamera();
    camUI.bgColor.alpha = 0;
    FlxG.cameras.add(camUI, false);
  }
}