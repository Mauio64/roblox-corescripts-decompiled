local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")

local parent = AvatarSwitcher.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ContextProviders = require(AvatarSwitcher.Internal.ContextProviders)

return {
	name = AvatarSwitcher.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { AvatarSwitcher.Components },
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
