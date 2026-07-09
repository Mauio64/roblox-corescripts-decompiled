local ParentParent = script.Parent.Parent

return {
	Analytics = require(ParentParent.Analytics),
	CentralOverlay = require(ParentParent.CentralOverlay),
	Foundation = require(ParentParent.Foundation),
	Localization = require(ParentParent.Localization),
	NavigationRodux = require(ParentParent.NavigationRodux),
	Promise = require(ParentParent.Promise),
	React = require(ParentParent.React),
	RoactRodux = require(ParentParent.RoactRodux),
	RoactServices = require(ParentParent.RoactServices),
	RoactServiceTags = require(ParentParent.RoactServiceTags),
	RobloxAppHooks = require(ParentParent.RobloxAppHooks),
	Style = require(ParentParent.Style),
	UIBlox = require(ParentParent.UIBlox),
	UrlBuilder = require(ParentParent.UrlBuilder),
	SharedFlags = require(ParentParent.SharedFlags)
}
