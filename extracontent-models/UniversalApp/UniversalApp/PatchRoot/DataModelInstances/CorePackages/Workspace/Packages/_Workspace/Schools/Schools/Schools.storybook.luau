local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local Foundation = require(SchoolsParent.Foundation)
local React = require(SchoolsParent.React)
local ReactRoblox = require(SchoolsParent.Dev.ReactRoblox)
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider
local t1 = {
	Dark = Theme.Dark,
	Light = Theme.Light
}

return {
	name = "Schools",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 17
		-- upvalues: React (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy)
		return function(p2) -- line: 18
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
	storyRoots = { Schools }
}
