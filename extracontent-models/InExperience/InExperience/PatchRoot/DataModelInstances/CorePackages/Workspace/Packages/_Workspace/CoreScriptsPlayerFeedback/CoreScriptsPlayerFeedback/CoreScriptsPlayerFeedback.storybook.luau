local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)
local Foundation = require(parent2.Foundation)
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local FoundationProvider = Foundation.FoundationProvider

local localization = Localization.new(LocalizationService.RobloxLocaleId)

local function StoryBookMapStory(p)
	return function(p2)
		return React.createElement(LocalizationProvider, { localization = localization }, {
			FoundationProvider = React.createElement(
				FoundationProvider,
				{ colorMode = Foundation.Enums.ColorMode.Dark },
				{ Child = React.createElement(p, p2) }
			)
		})
	end
end

return {
	name = parent.Name,
	storyRoot = parent,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
