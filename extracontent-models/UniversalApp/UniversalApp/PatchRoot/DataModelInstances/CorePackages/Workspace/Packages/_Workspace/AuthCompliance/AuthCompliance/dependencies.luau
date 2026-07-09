local ParentParent = script.Parent.Parent

return {
	Analytics = require(ParentParent.Analytics),
	CentralOverlay = require(ParentParent.CentralOverlay),
	Cryo = require(ParentParent.Cryo),
	Dash = require(ParentParent.Dash),
	FitFrame = require(ParentParent.FitFrame),
	FormFactor = require(ParentParent.FormFactor),
	Localization = require(ParentParent.Localization),
	React = require(ParentParent.React),
	RoactNavigation = require(ParentParent.RoactNavigation),
	Style = require(ParentParent.Style),
	UIBlox = require(ParentParent.UIBlox),
	Foundation = require(ParentParent.Foundation),
	UserLib = require(ParentParent.UserLib),
	PeekView = require(ParentParent.PeekView),
	Hooks = {
		useNavigation = require(ParentParent.Navigation).useNavigation,
		useDispatch = require(ParentParent.RoactUtils).Hooks.RoactRodux.useDispatch
	},
	RoactRodux = require(ParentParent.RoactRodux),
	RoactUtils = require(ParentParent.RoactUtils),
	RobloxAppEnums = require(ParentParent.RobloxAppEnums),
	NavigationRodux = require(ParentParent.NavigationRodux),
	UserAgreements = require(ParentParent.UserAgreements),
	llama = require(ParentParent.llama),
	SharedFlags = require(ParentParent.SharedFlags)
}
