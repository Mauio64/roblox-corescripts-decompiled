local ParentParent = script.Parent.Parent
local UserLib = require(ParentParent.UserLib)

return {
	AppBlox = require(ParentParent.AppBlox),
	Cryo = require(ParentParent.Cryo),
	Dash = require(ParentParent.Dash),
	LocalStorage = require(ParentParent.LocalStorage),
	Rodux = require(ParentParent.Rodux),
	Roact = require(ParentParent.Roact),
	RoactRodux = require(ParentParent.RoactRodux),
	RoactServices = require(ParentParent.RoactServices),
	React = require(ParentParent.React),
	ReactRoblox = require(ParentParent.ReactRoblox),
	UIBlox = require(ParentParent.UIBlox),
	Localization = require(ParentParent.Localization),
	NotificationModalsManager = require(ParentParent.NotificationModalsManager),
	RobloxAppHooks = require(ParentParent.RobloxAppHooks),
	RobloxAppEnums = require(ParentParent.RobloxAppEnums),
	RoactServiceTags = require(ParentParent.RoactServiceTags),
	Hooks = {
		dependencyArray = require(ParentParent.RoactUtils).Hooks.dependencyArray
	},
	LuauPolyfill = require(ParentParent.LuauPolyfill),
	t = require(ParentParent.t),
	ToastNotificationsProtocol = require(ParentParent.ToastNotificationsProtocol).ToastNotificationProtocol,
	ToastNotificationProtocolEnums = require(ParentParent.ToastNotificationsProtocol).ToastNotificationProtocolEnums,
	UserLib = UserLib,
	getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions,
	UserLibConstants = UserLib.Utils.Constants,
	Lumberyak = require(ParentParent.Lumberyak),
	SharedFlags = require(ParentParent.SharedFlags),
	Signal = require(ParentParent.AppCommonLib).Signal
}
