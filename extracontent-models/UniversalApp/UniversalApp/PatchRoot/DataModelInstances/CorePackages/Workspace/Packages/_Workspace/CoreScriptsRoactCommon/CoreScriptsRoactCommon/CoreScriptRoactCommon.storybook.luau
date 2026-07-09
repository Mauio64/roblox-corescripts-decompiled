local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local CoreScriptsRoactCommonParent = CoreScriptsRoactCommon.Parent
local React = require(CoreScriptsRoactCommonParent.React)
local ReactRoblox = require(CoreScriptsRoactCommonParent.ReactRoblox)
local Localization = require(CoreScriptsRoactCommonParent.InExperienceLocales).Localization
local LocalizationProvider = require(CoreScriptsRoactCommonParent.Localization).LocalizationProvider
local FoundationStorybookMiddleware = require(script.Parent.FoundationStorybookMiddleware)
local v8 = Localization.new("en-us")

local function wrapWithProviders(p1) -- line: 12
	-- upvalues: React (copy), LocalizationProvider (copy), v8 (copy)
	return function(p2) -- line: 13
		-- upvalues: React (copy), LocalizationProvider (copy), v8 (copy), p1 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v8
		}, {
			Child = React.createElement(p1, p2)
		})
	end
end
local function StoryBookMapStory(p3) -- line: 22
	-- upvalues: FoundationStorybookMiddleware (copy), React (copy), LocalizationProvider (copy), v8 (copy)
	return FoundationStorybookMiddleware(function(p4) -- line: 13
		-- upvalues: React (copy), LocalizationProvider (copy), v8 (copy), p3 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v8
		}, {
			Child = React.createElement(p3, p4)
		})
	end)
end

return {
	name = CoreScriptsRoactCommon.Name,
	storyRoot = CoreScriptsRoactCommon,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
