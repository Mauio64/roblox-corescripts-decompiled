local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local DisplayOptions = require(scriptParent.DisplayOptions)
local EmotesPage = require(scriptParent.EmotesPage)
local EmotesWheel = require(scriptParent.EmotesWheel)
local Layout = require(scriptParent.Layout)
local Locale = require(scriptParent.Locale)

return (Rodux.combineReducers({
	displayOptions = DisplayOptions,
	emotesPage = EmotesPage,
	emotesWheel = EmotesWheel,
	layout = Layout,
	locale = Locale
}))
