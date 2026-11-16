local SettingReactView = script:FindFirstAncestor("SettingReactView")
local parent = SettingReactView.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local v = {
	Default = Foundation.Enums.ColorMode.Dark,
	Light = Foundation.Enums.ColorMode.Light,
	Dark = Foundation.Enums.ColorMode.Dark
}

local v2 = { Default = "Desktop", Desktop = "Desktop", Console = "Console" }

local function StoryBookMapStory(p)
	return function(p2)
		return React.createElement(FoundationProvider, {
			colorMode = p2 and v[p2.theme] or v.Default,
			device = p2 and v2[p2.platform] or "Desktop"
		}, React.createElement(p, p2))
	end
end

return {
	name = SettingReactView.Name,
	storyRoot = SettingReactView,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = StoryBookMapStory
}
