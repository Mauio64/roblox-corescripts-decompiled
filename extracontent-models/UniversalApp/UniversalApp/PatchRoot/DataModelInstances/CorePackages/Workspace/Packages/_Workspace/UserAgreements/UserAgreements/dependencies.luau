local ParentParent = script.Parent.Parent

return {
	AppCommonLib = require(ParentParent.AppCommonLib),
	ArgCheck = require(ParentParent.ArgCheck),
	AuthenticationStatus = require(ParentParent.AuthenticationStatus),
	CentralOverlay = require(ParentParent.CentralOverlay),
	Cryo = require(ParentParent.Cryo),
	FitFrame = require(ParentParent.FitFrame),
	Http = require(ParentParent.Http),
	Localization = require(ParentParent.Localization),
	Loggers = require(ParentParent.Loggers),
	NavigationRodux = require(ParentParent.NavigationRodux),
	React = require(ParentParent.React),
	Roact = require(ParentParent.Roact),
	RoactRodux = require(ParentParent.RoactRodux),
	RoactServices = require(ParentParent.RoactServices),
	RoactServiceTags = require(ParentParent.RoactServiceTags),
	RoactUtils = require(ParentParent.RoactUtils),
	RobloxAppAssets = require(ParentParent.RobloxAppAssets),
	RobloxAppEnums = require(ParentParent.RobloxAppEnums),
	RobloxAppHooks = require(ParentParent.RobloxAppHooks),
	SharedFlags = require(ParentParent.SharedFlags),
	t = require(ParentParent.t),
	UIBlox = require(ParentParent.UIBlox),
	Foundation = require(ParentParent.Foundation),
	UniversalAppPolicy = require(ParentParent.UniversalAppPolicy),
	Dash = require(ParentParent.Dash)
}
