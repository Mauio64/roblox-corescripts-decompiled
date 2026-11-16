local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")

local parent = AvatarWorkshop.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ContextProviders = require(AvatarWorkshop.Internal.ContextProviders)

return {
	name = AvatarWorkshop.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { AvatarWorkshop },
	mapStory = function(p)
		return function(p2)
			return React.createElement(
				ContextProviders,
				{ theme = p2.theme, overlayGui = p2.focus },
				React.createElement(p, p2)
			)
		end
	end
}
