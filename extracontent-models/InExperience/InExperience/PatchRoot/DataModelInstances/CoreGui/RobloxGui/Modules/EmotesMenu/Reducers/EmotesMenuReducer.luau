local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent

local DisplayOptions = require(parent.DisplayOptions)
local EmotesPage = require(parent.EmotesPage)
local EmotesWheel = require(parent.EmotesWheel)
local Layout = require(parent.Layout)
local Locale = require(parent.Locale)

return (Rodux.combineReducers({
	displayOptions = DisplayOptions,
	emotesPage = EmotesPage,
	emotesWheel = EmotesWheel,
	layout = Layout,
	locale = Locale
}))
