/*
    DGCore_fnc_sendNotification

    Purpose: To send a notification and write a message to the server log.

    Parameters:
        _title: 		The title of the notification.
        _message: 		The message to be logged.
        _type: 			Type of notification (info, success, error, etc.). 	| Optional -> Default: "info_empty".
        _network: 		Type of network the notification should be sent to. | Optional -> Default: "exile".
        _titleColor: 	Color for the title text. 							| Optional -> Default from DGCore settings.
        _titleSize: 	Size for the title text. 							| Optional -> Default from DGCore settings.
        _titleFont: 	Font for the title text. 							| Optional -> Default from DGCore settings.
        _messageColor: 	Color for the message text. 						| Optional -> Default from DGCore settings.
        _messageSize: 	Size for the message text. 							| Optional -> Default from DGCore settings.
        _messageFont: 	Font for the message text. 							| Optional -> Default from DGCore settings.

    Examples: 
		["New Mission", "A new mission started", "info"] call DGCore_fnc_sendNotification;
		["Mission Success", "A mission was completed!", "success"] call DGCore_fnc_sendNotification;
		["Mission Failed", "A mission failed!", "error"] call DGCore_fnc_sendNotification;

    Returns: None

    Copyright 2024 by Dagovax
*/

params [
    "_title", 
    "_message", 
    ["_type", "info"], 
    ["_network", "exile"], 
    ["_titleColor", DGCore_Notification_Title_Color], 
    ["_titleSize", DGCore_Notification_Title_Size], 
    ["_titleFont", DGCore_Notification_Title_Font], 
    ["_messageColor", DGCore_Notification_Message_Color], 
    ["_messageSize", DGCore_Notification_Message_Size], 
    ["_messageFont", DGCore_Notification_Message_Font]
];

// Check if _title or _message is missing
if (isNil "_title" || isNil "_message") exitWith {
    [format["Not enough valid params to send notification! _title or _message = undefined"], "DGCore_fnc_sendNotification", "error"] call DGCore_fnc_log;
};

_message remoteExecCall ["systemChat",-2];
switch (toLowerANSI _network) do 
{
	case "exile":
	{
		private ["_exileToastType"];
        switch (toLowerANSI _type) do 
		{
            case "info":         
			{ 
				_exileToastType = "InfoEmpty";
			};
            case "success":
			{
				_exileToastType = "SuccessEmpty";
				_titleColor = DGCore_Notification_Success_Color;
			};
            case "error":
			{
				_exileToastType = "ErrorEmpty";
				_titleColor = DGCore_Notification_Error_Color;
				
			};
            default { _exileToastType = "InfoEmpty"; };
        };
		
		[
			"toastRequest",
			[
				_exileToastType,
				[
					format
					[
						"<t color='%1' size='%2' font='%3'>%4</t><br/><t color='%5' size='%6' font='%7'>%8</t>",
						_titleColor,
						_titleSize,
						_titleFont,
						_title,
						_messageColor,
						_messageSize,
						_messageFont,
						_message
					]
				]
			]
		] call ExileServer_system_network_send_broadcast;
	};
};