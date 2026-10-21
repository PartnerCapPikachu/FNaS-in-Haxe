package game.display;

class FPS extends openfl.text.TextField
{
	public var currentFPS(default, null):Int = 0;

	var _lastTime(null, null):Float = 0;
	var _count(null, null):Int = 0;
	var _accumulator(null, null):Float = 0;

	var _startTime(null, null):Float = 0;

	public function new(x:Float = 5, y:Float = 5, color:Int = 0xffffffff):Void
	{
		_startTime = stamp();

		super();
		this.x = x;
		this.y = y;
		selectable = mouseEnabled = false;
		defaultTextFormat = new openfl.text.TextFormat('_sans', 12, color);
		autoSize = LEFT;
		multiline = true;

    #if flash
		addEventListener(Event.ENTER_FRAME, __enterFrame);
		#end
	}

	dynamic public function updateText():Void
	{
		var str:String = 'FPS: $currentFPS';
		if (text != str) text = str;
	}

	#if !flash override #end function __enterFrame(_):Void
	{
		var _currentTime:Float = stamp();
		var _timePassed:Float = _currentTime - _lastTime;
		_lastTime = _currentTime;

		_accumulator += _timePassed * .001;
		++_count;

		if (_accumulator >= 1)
		{
			currentFPS = _count;
			_count = 0;
			_accumulator -= 1;
		}

		if (visible)
		{
			updateText();
		}
	}

	inline function stamp():Float
	{
		return #if (windows && cpp) flixel.Timer.stamp() * .0001 #else lime.system.System.getTimerPrecise() #end - _startTime;
	}
}