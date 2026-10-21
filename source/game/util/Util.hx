package game.util;

@:publicFields
class Util
{
  static function scanDirectory(directory:String = '', scanfor:String = '.png'):Array<String>
  {
    directory = 'assets/$directory';
    var result:Array<String> = [];
    if (FileSystem.exists(directory) && FileSystem.isDirectory(directory))
      for (file in FileSystem.readDirectory(directory))
      {
        var filePath:String = '$directory/$file';
        if (FileSystem.isDirectory(filePath))
          result = result.concat(scanDirectory(filePath.substr(7)));
        else if (filePath.endsWith(scanfor))
          result.push(filePath.substr(0, filePath.lastIndexOf(scanfor)));
      }
    return result;
  }

  static function mouseOverlaps(object:game.objects.Button, ?camera:FlxCamera, offsetX:Float = 0, offsetY:Float = 0):Bool
  {
    if (camera == null)
      camera = object.camera ?? FlxG.camera;

    var zoom:Float = camera.zoom;
    var mousePos:flixel.math.FlxPoint = FlxG.mouse.getScreenPosition(camera);

    var pointerPos:Float = (mousePos.x - offsetX) * zoom;
    var objectPos:Float = (object.hitbox.x) * zoom;
    var objectPos2:Float = (object.hitbox.x + object.hitbox.scale.x) * zoom;
    var overlapsX:Bool = pointerPos >= objectPos && pointerPos <= objectPos2;

    var pointerPos:Float = (mousePos.y - offsetY) * zoom;
    var objectPos:Float = (object.hitbox.y) * zoom;
    var objectPos2:Float = (object.hitbox.y + object.hitbox.scale.y) * zoom;
    var overlapsY:Bool = pointerPos >= objectPos && pointerPos <= objectPos2;

    return overlapsX && overlapsY;
  }
}