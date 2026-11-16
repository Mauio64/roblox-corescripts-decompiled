local SocialUpsell = script:FindFirstAncestor("SocialUpsell")

local parent = SocialUpsell.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)

local FoundationProvider = Foundation.FoundationProvider

return {
	name = SocialUpsell.Name,
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
	storyRoots = { SocialUpsell }
}
