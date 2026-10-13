package util;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

import openfl.display.BitmapData;
import openfl.media.Sound;

@:publicFields
class AssetManager
{
	static function getSparrow(key:String):FlxAtlasFrames
	{
		var graphic:FlxGraphic = getImage(key);
		if (graphic == null)
			return null;

		var xmlPath:String = 'assets/images/$key.xml';
		if (!FileSystem.exists(xmlPath))
			return null;

		return FlxAtlasFrames.fromSparrow(graphic, xmlPath);
	}

	static var trackedGraphics:Map<String, FlxGraphic> = [];
	static function getImage(key:String):FlxGraphic
	{
		var path:String = 'assets/images/$key.png';

		var graphic:FlxGraphic = trackedGraphics[path];
		if (graphic != null)
			return graphic;

		if (!FileSystem.exists(path))
			return null;

		graphic = FlxGraphic.fromBitmapData(getBitmap(path), false, path, false);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		trackedGraphics.set(path, graphic);
		return graphic;
	}

	static var trackedBitmaps:Map<String, BitmapData> = [];
	static function getBitmap(path:String):BitmapData
	{
		var bitmap:BitmapData = trackedBitmaps[path];
		if (bitmap != null)
			return bitmap;

		bitmap = BitmapData.fromFile(path);
		bitmap.disposeImage();
		trackedBitmaps.set(path, bitmap);
		return bitmap;
	}

	static function getSound(key:String):Sound
	{
		return getOgg('sounds/$key');
	}

	static function getMusic(key:String):Sound
	{
		return getOgg('music/$key');
	}

	static var trackedAudio:Map<String, Sound> = [];
	static function getOgg(key:String):Sound
	{
		var path:String = 'assets/$key.ogg';

		var sound:Sound = trackedAudio[path];
		if (sound != null)
			return sound;

		if (!FileSystem.exists(path))
			return flixel.system.FlxAssets.getSound('flixel/sounds/beep');

		sound = Sound.fromFile(path);
		trackedAudio.set(path, sound);
		return sound;
	}
}