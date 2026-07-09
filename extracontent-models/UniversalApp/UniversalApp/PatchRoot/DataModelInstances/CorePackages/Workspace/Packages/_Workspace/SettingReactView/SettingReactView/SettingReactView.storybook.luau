local SettingReactView = script:FindFirstAncestor("SettingReactView")
local SettingReactViewParent = SettingReactView.Parent
local React = require(SettingReactViewParent.React)
local ReactRoblox = require(SettingReactViewParent.ReactRoblox)
local Foundation = require(SettingReactViewParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local t1 = {
	Default = Foundation.Enums.Theme.Dark,
	Light = Foundation.Enums.Theme.Light,
	Dark = Foundation.Enums.Theme.Dark
}
local t2 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Console = "Console"
}

local function StoryBookMapStory(p1) -- line: 26
	-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), t2 (copy)
	return function(p2) -- line: 27
		-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), t2 (copy), p1 (copy)
		return React.createElement(FoundationProvider, {
			theme = p2 and t1[p2.theme] or t1.Default,
			device = p2 and t2[p2.platform] or t2.Default
		}, React.createElement(p1, p2))
	end
end

return {
	name = SettingReactView.Name,
	storyRoot = SettingReactView,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
