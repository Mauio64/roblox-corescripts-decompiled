local parent = script.Parent.Parent
local UserLib = require(parent.UserLib)

local Dependencies = {
	AppBlox = require(parent.AppBlox),
	Cryo = require(parent.Cryo),
	Dash = require(parent.Dash),
	LocalStorage = require(parent.LocalStorage),
	Rodux = require(parent.Rodux),
	Roact = require(parent.Roact),
	RoactRodux = require(parent.RoactRodux),
	RoactServices = require(parent.RoactServices),
	React = require(parent.React),
	ReactRoblox = require(parent.ReactRoblox),
	UIBlox = require(parent.UIBlox),
	Localization = require(parent.Localization),
	NotificationModalsManager = require(parent.NotificationModalsManager),
	RobloxAppHooks = require(parent.RobloxAppHooks),
	RobloxAppEnums = require(parent.RobloxAppEnums),
	RoactServiceTags = require(parent.RoactServiceTags),
	Hooks = 0,
	LuauPolyfill = 0,
	t = 0,
	ToastNotificationsProtocol = 0,
	ToastNotificationProtocolEnums = 0,
	UserLib = 0,
	getRbxthumbWithTypeSizeAndOptions = 0,
	UserLibConstants = 0,
	Lumberyak = 0,
	SharedFlags = 0,
	Signal = 0
}

local RoactUtils = require(parent.RoactUtils)
Dependencies.Hooks = { dependencyArray = RoactUtils.Hooks.dependencyArray }

Dependencies.LuauPolyfill = require(parent.LuauPolyfill)
Dependencies.t = require(parent.t)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
Dependencies.ToastNotificationsProtocol = ToastNotificationsProtocol.ToastNotificationProtocol
local ToastNotificationsProtocol2 = require(parent.ToastNotificationsProtocol)
Dependencies.ToastNotificationProtocolEnums = ToastNotificationsProtocol2.ToastNotificationProtocolEnums
Dependencies.UserLib = UserLib
Dependencies.getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
Dependencies.UserLibConstants = UserLib.Utils.Constants
Dependencies.Lumberyak = require(parent.Lumberyak)
Dependencies.SharedFlags = require(parent.SharedFlags)
local AppCommonLib = require(parent.AppCommonLib)
Dependencies.Signal = AppCommonLib.Signal
return Dependencies
