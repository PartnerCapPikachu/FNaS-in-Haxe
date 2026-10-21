package game.states;

import flixel.util.FlxColor;

import game.objects.*;
import game.objects.built.Office;

class Game extends FlxState
{
  var office:Office;
  var jumpscare:Jumpscare;

  var camButton:Button;

  var curCam(default, set):Int = 0;
  var map:Sprite;
  var mapButtons:Array<Button>;
  var restaurant:Sprite;
  var camMario:Sprite;
  var camSonic:Sprite;
  var camYoshi:Sprite;

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
    camCCTV.visible = false;
    FlxG.cameras.add(camCCTV, false);

    camUI = new FlxCamera();
    camUI.bgColor.alpha = 0;
    FlxG.cameras.add(camUI, false);

    office = new Office();
    add(office);

    jumpscare = new Jumpscare();
    jumpscare.camera = camJUMP;
    add(jumpscare);

    camButton = new Button(0, 0, AssetManager.getImage('Buttons/camera_flip_button'));
    camButton.camera = camUI;
    camButton.setHitboxSize(camButton.width, camButton.height);
    camButton.x = FlxG.width * 0.5 - camButton.width * 0.5;
    camButton.y = FlxG.height - camButton.height * 2;
    add(camButton);
    camButton.onHitboxHit = ()->{
      var wasvis:Bool = camCCTV.visible;

      FlxG.camera.visible = wasvis;
      office.buttonDoreL.interactable = wasvis;
      office.buttonLightL.interactable = wasvis;
      office.buttonDoreR.interactable = wasvis;
      office.buttonLightR.interactable = wasvis;

      camCCTV.visible = !wasvis;

      for (butt in mapButtons) butt.interactable = !wasvis;
    }

    restaurant = new Sprite();
    restaurant.camera = camCCTV;
    restaurant.frames = AssetManager.getSparrow('Camera/areas');
    for (i in 1...12) restaurant.animation.addByPrefix('${i-1}', 'Camera${i}_', 24, false);
    restaurant.play('0', false, false, 0, false);
    add(restaurant);

    map = new Sprite(0, 0, AssetManager.getImage('Camera/map'));
    map.camera = camCCTV;
    map.x = FlxG.width - map.width - 19;
    map.y = FlxG.height - map.height - 57;
    add(map);

    mapButtons = [];
    for (i in 0...11)
    {
      //i'm sorry
      var position:Array<Float> = switch (i)
      {
        case 0: [347, 277];
        case 1: [353, 307];
        case 2: [323, 333];
        case 3: [435, 309];
        case 4: [289, 305];
        case 5: [440, 372];
        case 6: [307, 380];
        case 7: [345, 381];
        case 8: [381, 381];
        case 9: [336, 411];
        case 10: [389, 411];
        default: [0, 0];
      }

      var butt:Button = new Button(position[0], position[1]);
      butt.camera = camCCTV;
      butt.frames = AssetManager.getSparrow('Buttons/camera_buttons');
      butt.animation.addByIndices('', 'cam', [i], '', 24, false);
      butt.play('');
      butt.setHitboxSize(butt.width, butt.height);
      butt.onHitboxHit = ()->curCam=i;
      butt.clickToTrigger = true;
      add(butt);
      mapButtons.push(butt);
    }

    curCam = 0;
  }

  function set_curCam(index:Int):Int
  {
    mapButtons[curCam].color = FlxColor.WHITE;
    mapButtons[index].color = FlxColor.LIME;

    restaurant.play('$index', false, false, 0, false);

    return curCam = index;
  }
}