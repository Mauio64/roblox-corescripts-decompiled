local LocalizationService = game:GetService("LocalizationService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local Foundation = require(scriptParentParent.Foundation)
local ReactRoblox = require(scriptParentParent.ReactRoblox)
local Localization = require(scriptParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider
local KeybindContextProvider = require(scriptParent.Context.KeybindContextProvider)
local v10 = Localization.new(LocalizationService.RobloxLocaleId)
local FoundationProvider = Foundation.FoundationProvider

local function StoryBookMapStory(p1) -- line: 19
	-- upvalues: React (copy), LocalizationProvider (copy), v10 (copy), KeybindContextProvider (copy), FoundationProvider (copy), Foundation (copy)
	return function(p2) -- line: 20
		-- upvalues: React (copy), LocalizationProvider (copy), v10 (copy), KeybindContextProvider (copy), FoundationProvider (copy), Foundation (copy), p1 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v10
		}, {
			KeybindContextProvider = React.createElement(KeybindContextProvider, nil, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = Foundation.Enums.Theme.Dark
				}, { React.createElement(p1, p2) })
			})
		})
	end
end

return {
	name = scriptParent.Name,
	storyRoot = scriptParent,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
