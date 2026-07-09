local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)

return {
	Dash = require(ParentParent.Dash),
	Roact = require(ParentParent.Roact),
	RoactNavigation = require(ParentParent.RoactNavigation),
	RoactRodux = require(ParentParent.RoactRodux),
	Rodux = require(ParentParent.Rodux),
	t = require(ParentParent.t),
	UIBlox = require(ParentParent.UIBlox),
	LocalizationProvider = require(ParentParent.Localization).LocalizationProvider,
	withLocalization = require(ParentParent.Localization).withLocalization,
	llama = LuaSocialLibrariesDeps.llama
}
