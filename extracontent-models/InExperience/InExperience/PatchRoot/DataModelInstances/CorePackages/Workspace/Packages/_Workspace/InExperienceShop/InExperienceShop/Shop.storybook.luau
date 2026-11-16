local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

local parent = InExperienceShop.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ContextProviders = require(InExperienceShop.Internal.ContextProviders)

return {
	name = InExperienceShop.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { InExperienceShop.Components },
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
