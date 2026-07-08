local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local ReactRoblox = require(MomentsCreationParent.Dev.ReactRoblox)
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider
local t1 = {
	Dark = Theme.Dark,
	Light = Theme.Light
}

return {
	name = "MomentsCreation",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 24
		-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy)
		return function(p2) -- line: 25
			-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy), p1 (copy)
			return React.createElement(FoundationProvider, {
				theme = t1[p2.theme] or Theme.Dark,
				device = Device[p2.platform] or Device.Phone,
				preferences = p2.settings,
				scale = p2.settings and p2.settings.scale
			}, {
				Child = React.createElement(p1, p2)
			})
		end
	end,
	storyRoots = { MomentsCreation }
}
