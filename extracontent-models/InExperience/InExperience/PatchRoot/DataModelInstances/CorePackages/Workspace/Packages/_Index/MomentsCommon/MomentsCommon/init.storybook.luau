local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local v = {
	Default = Foundation.Enums.ColorMode.Dark,
	Light = Foundation.Enums.ColorMode.Light,
	Dark = Foundation.Enums.ColorMode.Dark
}

return {
	name = MomentsCommon.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoot = MomentsCommon,
	mapStory = function(p)
		return function(p2)
			local colorMode = p2 and v[p2.theme] or v.Default
			return React.createElement(Foundation.FoundationProvider, { colorMode = colorMode }, {
				Child = React.createElement(p, p2)
			})
		end
	end
}
