program HelloWorld;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ChakraCommonWindows in '..\..\..\..\ChakraCore-Delphi\ChakraCommonWindows.pas',
  ChakraCommon in '..\..\..\..\ChakraCore-Delphi\ChakraCommon.pas';

procedure HelloWorldTest;
var
  script: String;
	runtime: JsRuntimeHandle;
	context: JsContextRef;
	currentSourceContext: LongWord;
	result: JsValueRef;
  resultJSString: JsValueRef;
  resultWC: pwchar_t;
  stringLength: size_t;
  resultStr: String;
  error: JsErrorCode;
begin
  script := '(()=>{return ''Hello world!'';})()';

  // Create a runtime.
  error := JsCreateRuntime(JsRuntimeAttributeNone, nil, runtime);

  // Create an execution context.
  error := JsCreateContext(runtime, context);

  // Now set the execution context as being the current one on this thread.
  error := JsSetCurrentContext(context);

  // Run the script.
  error := JsRunScript(pwchar_t(script), @currentSourceContext, pwchar_t(''), result);

  error := JsConvertValueToString(result, resultJSString);

  error := JsStringToPointer(resultJSString, resultWC, stringLength);

  setLength(resultStr, stringLength);
  move(resultWC[0], resultStr[1], stringLength * 2);

  WriteLn(String.Format('result is %s', [resultStr]));

  // Dispose runtime
  JsSetCurrentContext(JS_INVALID_REFERENCE);
  JsDisposeRuntime(runtime);  
end;

begin
  try
    HelloWorldTest;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
