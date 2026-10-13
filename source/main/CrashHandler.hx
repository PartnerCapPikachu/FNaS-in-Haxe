package main;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.FlxG.FlxRenderMethod;
import haxe.Exception;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;

/**
 * A custom crash handler that writes to a log file and displays a message box.
 * This class is from Funkin' Github.
 */
@:nullSafety
class CrashHandler
{
  public static inline final LOG_FOLDER:String = 'logs';

  /**
   * Called before exiting the game when a standard error occurs, like a thrown exception.
   * @param message The error message.
   */
  public static var errorSignal(default, null):FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

  /**
   * Called before exiting the game when a critical error occurs, like a stack overflow or null object reference.
   * CAREFUL: The game may be in an unstable state when this is called.
   * @param message The error message.
   */
  public static var criticalErrorSignal(default, null):FlxTypedSignal<String->Void> = new FlxTypedSignal<String->Void>();

  /**
   * Initializes
   */
  public static function initialize():Void
  {
    Sys.println('[LOG] Enabling standard uncaught error handler...');
    @:privateAccess
    Lib.current.stage.__uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

    #if cpp
    Sys.println('[LOG] Enabling C++ critical error handler...');
    untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
    #end

    queryStatus();
  }

  /**
   * Called when an uncaught error occurs.
   * This handles most thrown errors, and is sufficient to handle everything alone on HTML5.
   * @param error Information on the error that was thrown.
   */
  static function onUncaughtError(error:UncaughtErrorEvent):Void
  {
    error.stopImmediatePropagation();
    error.preventDefault();

    Sys.println('[LOG] Generating UncaughtErrorEvent...');

    try
    {
      errorSignal.dispatch(generateErrorMessage(error));

      try
      {
        #if sys
        logError(error);
        #end
      }
      catch (err:Exception)
      {
        Sys.println('Error while logging error: $err');
      }

      displayError(error);
    }
    catch (err:Exception)
    {
      Sys.println('Error while handling crash: $err');
      Sys.println('Error: ' + error.error);
    }

    #if sys
    Sys.sleep(1); // wait a few moments of margin to process.
    // Exit the game. Since it threw an error, we use a non-zero exit code.
    openfl.Lib.application.window.close();
    #end
  }

  static function onCriticalError(message:String):Void
  {
    try
    {
      criticalErrorSignal.dispatch(message);

      try
      {
        #if sys
        logErrorMessage(message);
        #end
      }
      catch (err:Exception)
      {
        Sys.println('Error while logging error: $err');
      }

      displayErrorMessage(message);
    }
    catch (err:Exception)
    {
      Sys.println('Error while handling crash: $err');
      Sys.println('Error: $message');
    }

    #if sys
    Sys.sleep(1); // wait a few moments of margin to process.
    // Exit the game. Since it threw an error, we use a non-zero exit code.
    openfl.Lib.application.window.close();
    #end
  }

  static function displayError(error:UncaughtErrorEvent):Void
  {
    displayErrorMessage(generateErrorMessage(error));
  }

  static function displayErrorMessage(message:String):Void
  {
    lime.app.Application.current.window.alert(message, 'Fatal Uncaught Exception');
  }

  #if sys
  static function logError(error:UncaughtErrorEvent):Void
  {
    logErrorMessage(generateErrorMessage(error));
  }

  static function logErrorMessage(message:String, critical:Bool = false):Void
  {
    //FileUtil.createDirIfNotExists(LOG_FOLDER);
    #if sys
    var logFolderExists:Bool = try FileSystem.isDirectory(LOG_FOLDER) catch(_) false;
    if (!logFolderExists) FileSystem.createDirectory(LOG_FOLDER);
    #else
    throw 'FileSystem not supported.';
    #end

    sys.io.File.saveContent('$LOG_FOLDER/crash${critical ? '-critical' : ''}-${currentDate()}.log', buildCrashReport(message));
  }
  #end

  static function buildCrashReport(message:String):String
  {
    var fullContents:String = '=====================\n';
    fullContents += 'Five Nights at Sonic\'s crash';
    fullContents += '=====================\n';

    fullContents += '\n';

    fullContents += buildSystemInfo();

    fullContents += '\n\n';

    fullContents += '=====================\n';

    fullContents += '\n';

    var currentState:String = 'No state loaded';
    if (FlxG.game != null && FlxG.state != null)
    {
      var currentStateCls:Null<Class<Dynamic>> = Type.getClass(FlxG.state);
      if (currentStateCls != null)
      {
        currentState = Type.getClassName(currentStateCls) ?? 'No state loaded';
      }
    }

    fullContents += 'Flixel Current State: ${currentState}\n';

    fullContents += '\n';

    fullContents += '=====================\n';

    fullContents += '\n';

    fullContents += message;

    fullContents += '\n';

    return fullContents;
  }

  /**
   * Build a log of info about the garbage collector for debugging purposes.
   * funkin.util.MemoryUtils
   *
   * @return The resulting log.
   */
  public static function buildGCInfo():String
  {
    #if cpp
    var result:String = 'HXCPP-Immix:';
    result += '\n- Memory Used: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE)} bytes';
    result += '\n- Memory Reserved: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_RESERVED)} bytes';
    result += '\n- Memory Current Pool: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_CURRENT)} bytes';
    result += '\n- Memory Large Pool: ${cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_LARGE)} bytes';
    result += '\n- HXCPP Debugger: ${#if HXCPP_DEBUGGER 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Exp Generational Mode: ${#if HXCPP_GC_GENERATIONAL 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Exp Moving GC: ${#if HXCPP_GC_MOVING 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Exp Dynamic Size GC: ${#if HXCPP_GC_DYNAMIC_SIZE 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Exp Big Blocks GC: ${#if HXCPP_GC_BIG_BLOCKS 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Debug Link: ${#if HXCPP_DEBUG_LINK 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Stack Trace: ${#if HXCPP_STACK_TRACE 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Stack Trace Line Numbers: ${#if HXCPP_STACK_LINE 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Pointer Validation: ${#if HXCPP_CHECK_POINTER 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Profiler: ${#if HXCPP_PROFILER 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP Local Telemetry: ${#if HXCPP_TELEMETRY 'Enabled' #else 'Disabled' #end}';
    result += '\n- HXCPP C++11: ${#if HXCPP_CPP11 'Enabled' #else 'Disabled' #end}';
    result += '\n- Source Annotation: ${#if annotate_source 'Enabled' #else 'Disabled' #end}';
    #elseif js
    var result:String = 'JS-MNS:';
    result += '\n- Memory Used: ${openfl.system.System.totalMemoryNumber} bytes';
    #else
    var result:String = 'Unknown GC';
    #end

    return result;
  }

  public static function buildSystemInfo():String
  {
    var fullContents:String = '=====================\n';
    fullContents += 'System timestamp: ${currentDate()}\n';
    fullContents += 'Driver info: ${FlxG?.stage?.context3D?.driverInfo ?? 'N/A'}\n';
    #if sys
    fullContents += 'Platform: ${Sys.systemName()}\n';
    #end
    fullContents += 'Render method: ${renderMethod()}\n';
    fullContents += '\n';
    fullContents += '=====================\n';
    fullContents += '\n';
    fullContents += buildGCInfo();
    return fullContents;
  }

  static function generateErrorMessage(error:UncaughtErrorEvent):String
  {
    var errorMessage:String = '';
    var callStack:Array<haxe.CallStack.StackItem> = haxe.CallStack.exceptionStack(true);

    for (stackItem in callStack)
    {
      switch (stackItem)
      {
        case FilePos(innerStackItem, file, line, column):
          file = file.substr(0, file.length - 3).replace('/', '.');
          errorMessage += ' in ${file} #${line}';
          if (column != null) errorMessage += ':${column}';
        case CFunction:
          errorMessage += '[Function] ';
        case Module(m):
          errorMessage += '[Module(${m})] ';
        case Method(classname, method):
          errorMessage += '[Function(${classname}.${method})] ';
        case LocalFunction(v):
          errorMessage += '[LocalFunction(${v})] ';
      }
      errorMessage += '\n';
    }

    errorMessage += '${error.error}\n';

    return errorMessage;
  }

  public static function queryStatus():Void
  {
    @:privateAccess
    var currentStatus = Lib.current.stage.__uncaughtErrorEvents.__enabled;
    Sys.println('ERROR HANDLER STATUS: ' + currentStatus);

    #if openfl_enable_handle_error
    Sys.println('Define: openfl_enable_handle_error is enabled');
    #else
    Sys.println('Define: openfl_enable_handle_error is disabled');
    #end

    #if openfl_disable_handle_error
    Sys.println('Define: openfl_disable_handle_error is enabled');
    #else
    Sys.println('Define: openfl_disable_handle_error is disabled');
    #end
  }

  public static function induceBasicCrash():Void
  {
    throw 'This is an example of an uncaught exception.';
  }

  public static function induceNullObjectReference():Void
  {
    var obj:Dynamic = null;
    var value = obj.test;
  }

  public static function induceNullObjectReference2():Void
  {
    var obj:Dynamic = null;
    var value = obj.test();
  }

  public static function induceNullObjectReference3():Void
  {
    var obj:Dynamic = null;
    var value = obj();
  }

  static function renderMethod():String
  {
    var outputStr:String = 'UNKNOWN';
    outputStr = try
    {
      switch (FlxG.renderMethod)
      {
        case FlxRenderMethod.DRAW_TILES:
          'DRAW_TILES';
        case FlxRenderMethod.BLITTING:
          'BLITTING';
        default:
          'UNKNOWN';
      }
    }
    catch (e)
    {
      'ERROR ON QUERY RENDER METHOD: ${e}';
    }

    return outputStr;
  }

  inline static function currentDate():String
  {
    return Date.now().toString().replace(' ', '_').replace(':', '\'');
  }
}