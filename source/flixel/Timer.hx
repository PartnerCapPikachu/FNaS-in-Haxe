package flixel;

import haxe.Int64;

#if (windows && cpp)
@:cppInclude('windows.h')
#end
class Timer
{
  #if (windows && cpp)
  @:functionCode('
    LARGE_INTEGER count;
    QueryPerformanceCounter(&count);
    return count.QuadPart;
  ')
  #end
  static function _stamp():Int64
  {
    return 0;
  }

  inline public static function stamp():Float
  {
    return cast _stamp();
  }
}