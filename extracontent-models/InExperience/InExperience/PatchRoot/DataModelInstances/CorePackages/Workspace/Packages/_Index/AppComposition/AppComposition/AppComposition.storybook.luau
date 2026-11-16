local AppComposition = script:FindFirstAncestor("AppComposition")

local parent = AppComposition.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local FoundationProvider = Foundation.FoundationProvider

return {
	name = AppComposition.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			return React.createElement(
				FoundationProvider,
				{ colorMode = p2.theme, device = p2.platform },
				React.createElement(p, p2)
			)
		end
	end,
	storyRoots = { AppComposition }
}
