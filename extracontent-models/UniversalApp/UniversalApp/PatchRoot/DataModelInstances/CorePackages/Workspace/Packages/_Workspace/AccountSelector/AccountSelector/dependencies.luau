local ParentParent = script.Parent.Parent

return {
	Analytics = require(ParentParent.Analytics),
	CentralOverlay = require(ParentParent.CentralOverlay),
	Cryo = require(ParentParent.Cryo),
	Dash = require(ParentParent.Dash),
	Foundation = require(ParentParent.Foundation),
	LandingPage = require(ParentParent.LandingPage),
	Localization = require(ParentParent.Localization),
	React = require(ParentParent.React),
	RoactAppExperiment = require(ParentParent.RoactAppExperiment),
	RoactNavigation = require(ParentParent.RoactNavigation),
	Style = require(ParentParent.Style),
	UIBlox = require(ParentParent.UIBlox),
	UserLib = require(ParentParent.UserLib),
	PeekView = require(ParentParent.PeekView),
	Hooks = {
		useNavigation = require(ParentParent.Navigation).useNavigation
	},
	RoactRodux = require(ParentParent.RoactRodux),
	RoactUtils = require(ParentParent.RoactUtils),
	RobloxAppEnums = require(ParentParent.RobloxAppEnums),
	SharedFlags = require(ParentParent.SharedFlags),
	UniversalAppPolicy = require(ParentParent.UniversalAppPolicy),
	ExperimentLayers = require(ParentParent.ExperimentLayers),
	NavigationRodux = require(ParentParent.NavigationRodux)
}
