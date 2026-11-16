local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local parent = CoreScriptsRoactCommon.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local FoundationStorybookMiddleware = require(script.Parent.FoundationStorybookMiddleware)

local enus = Localization.new("en-us")

local function wrapWithProviders(p) -- 1 equivalent call inferred from this helper
	return function(p2)
		return React.createElement(LocalizationProvider, { localization = enus }, {
			Child = React.createElement(p, p2)
		})
	end
end

local function StoryBookMapStory(p)
	return FoundationStorybookMiddleware(wrapWithProviders(p)) -- inferred equivalent call
end

return {
	name = CoreScriptsRoactCommon.Name,
	storyRoot = CoreScriptsRoactCommon,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
