local LocalizationService = game:GetService("LocalizationService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local ReactRoblox = require(scriptParentParent.ReactRoblox)
local Foundation = require(scriptParentParent.Foundation)
local Localization = require(scriptParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider
local FoundationProvider = Foundation.FoundationProvider
local v10 = Localization.new(LocalizationService.RobloxLocaleId)

local function StoryBookMapStory(p1) -- line: 16
	-- upvalues: React (copy), LocalizationProvider (copy), v10 (copy), FoundationProvider (copy), Foundation (copy)
	return function(p2) -- line: 17
		-- upvalues: React (copy), LocalizationProvider (copy), v10 (copy), FoundationProvider (copy), Foundation (copy), p1 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v10
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				theme = Foundation.Enums.Theme.Dark
			}, {
				Child = React.createElement(p1, p2)
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
