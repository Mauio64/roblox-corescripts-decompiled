local ParentParent = script.Parent.Parent

return {
	Mock = require(ParentParent.LuaSocialLibrariesDeps).Mock,
	UIBlox = require(ParentParent.UIBlox),
	UnitTestHelpers = require(ParentParent.UnitTestHelpers),
	Roact = require(ParentParent.Roact),
	Dash = require(ParentParent.Dash),
	Rodux = require(ParentParent.Rodux),
	RoactRodux = require(ParentParent.RoactRodux),
	RoactNavigation = require(ParentParent.RoactNavigation),
	ReactRoblox = require(ParentParent.ReactRoblox),
	LocalizationProvider = require(ParentParent.Localization).LocalizationProvider,
	RobloxAppLocales = require(ParentParent.RobloxAppLocales),
	GraphQLServer = require(ParentParent.GraphQLServer),
	ApolloClient = require(ParentParent.ApolloClient),
	BuilderIcons = require(ParentParent.BuilderIcons),
	SharedFlags = require(ParentParent.SharedFlags)
}
