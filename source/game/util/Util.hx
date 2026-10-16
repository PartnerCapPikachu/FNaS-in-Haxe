package game.util;

@:publicFields
class Util
{
  static function scanDirectory(directory:String, scanfor:String = '.png'):Array<String>
  {
    directory = 'assets/$directory';
    var result:Array<String> = [];
    if (FileSystem.exists(directory) && FileSystem.isDirectory(directory)) for (file in FileSystem.readDirectory(directory))
    {
      var filePath:String = '$directory/$file';
      if (FileSystem.isDirectory(filePath)) result = result.concat(scanDirectory(filePath.substr(7)));
      else if (filePath.endsWith(scanfor)) result.push(filePath.substr(0, filePath.length - scanfor.length));
    }
    return result;
  }

  static function mouseOverlaps(object:FlxSprite, ?camera:FlxCamera, offsetX:Float = 0, offsetY:Float = 0):Bool
  {
    camera ??= FlxG.camera;
    var mousePos = FlxG.mouse.getScreenPosition(camera);

    var math:Float = (mousePos.x + offsetX) * camera.zoom;
    var overlapsX:Bool = math >= (object.x * camera.zoom);
    overlapsX = overlapsX && math <= ((object.x + object.width) * camera.zoom);

    math = (mousePos.y + offsetY) * camera.zoom;
    var overlapsY:Bool = math >= (object.y * camera.zoom);
    overlapsY = overlapsY && math <= ((object.y + object.height) * camera.zoom);

    return overlapsX && overlapsY;
  }
}