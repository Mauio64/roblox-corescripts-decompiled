local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Foundation = require(parent.Foundation)

require(script.Parent.BackgroundHighlight)

local useTokens = Foundation.Hooks.useTokens

return function(p)
	local surface_100 = useTokens().Color.Surface.Surface_100

	return {
		ZIndex = p.ZIndex or 0,
		highlightColor = surface_100
	}
end
