local ParentParent = script.Parent.Parent

return {
	React = require(ParentParent.React),
	Roact = require(ParentParent.Roact),
	Rodux = require(ParentParent.Rodux),
	RoactRodux = require(ParentParent.RoactRodux),
	Dash = require(ParentParent.Dash),
	Hooks = {
		useNavigation = require(ParentParent.Navigation).useNavigation,
		useLocalization = require(ParentParent.Localization).Hooks.useLocalization,
		useDidUpdate = require(ParentParent.RoactUtils).Hooks.useDidUpdate,
		dependencyArray = require(ParentParent.RoactUtils).Hooks.dependencyArray
	},
	UIBlox = require(ParentParent.UIBlox),
	SharedFlags = require(ParentParent.SharedFlags),
	LocalizationProvider = require(ParentParent.Localization).LocalizationProvider,
	RoactNavigation = require(ParentParent.RoactNavigation)
}
