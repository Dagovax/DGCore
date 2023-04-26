/*

	DGCore_fnc_log

	Purpose: to write a message to the server log

	Parametsrs:
		_message: message to be logged
		_scriptName: name of the calling script to be used in logging
		_type: 

	Example: ["I am being logged", "DG RoamingAI", "information"] call DGCore_fnc_log;

	Returns: None 

	Copyright 2023 by Dagovax
*/

params["_message",["_scriptName","DGCore"],["_type",""]];

if !(_type isEqualType "") then 
{
	[format["Invalid _type %1 passed to DGCore_fnc_log","DGCore", _type]] call DGCore_fnc_log;
	_type = "";
};
if (isNil "_scriptName") then
{
	_scriptName = "DGCore";
};
private _log = "";
#define basemsg "[%1] %2 %3"
switch (toLowerANSI _type) do 
{
	case "warning": {_log = format["[%1] %2 %3", _scriptName, " <WARNING> ",_message]};
	case "error": {_log = format["[%1] %2 %3", _scriptName, " <ERROR> ",_message]};
	case "information": {_log = format["[%1] %2 %3", _scriptName, " <INFORMATION> ",_message]};
	case "debug": {_log = format["[%1] %2 %3", _scriptName, " <DEBUG> ",_message]};
	default {_log = format["[%1] %2 %3",_scriptName,"",_message]};
};
diag_log _log;
// if(DGCore_EnableLogging) then
// {
	// if((toLowerANSI DGCore_LogLevel isEqualTo "debug") || (toLowerANSI _type isEqualTo "")) exitWith // Log everything
	// {
		// diag_log _log;
	// };
	// if((toLowerANSI DGCore_LogLevel isEqualTo "information") && ((toLowerANSI _type isEqualTo "information") || (toLowerANSI _type isEqualTo "error"))) exitWith // Only log normal information messages
	// {
		// diag_log _log;
	// };
	// if((toLowerANSI DGCore_LogLevel isEqualTo "errors") && toLowerANSI _type isEqualTo "error") exitWith // Only log error messages
	// {
		// diag_log _log;
	// };
	// if(toLowerANSI DGCore_LogLevel isEqualTo "warnings" && toLowerANSI _type isEqualTo "warning") exitWith // Only log warning messages
	// {
		// diag_log _log;
	// };
// };