local LocalizationService = game:GetService("LocalizationService")

local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local ReactRoblox = require(parent2.ReactRoblox)
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local KeybindContextProvider = require(parent.Context.KeybindContextProvider)
local localization = Localization.new(LocalizationService.RobloxLocaleId)

local FoundationProvider = Foundation.FoundationProvider

local function StoryBookMapStory(p)
	return function(p2)
		return React.createElement(LocalizationProvider, { localization = localization }, {
			KeybindContextProvider = React.createElement(KeybindContextProvider, nil, {
				FoundationProvider = React.createElement(
					FoundationProvider,
					{ colorMode = Foundation.Enums.ColorMode.Dark },
					{ React.createElement(p, p2) }
				)
			})
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
