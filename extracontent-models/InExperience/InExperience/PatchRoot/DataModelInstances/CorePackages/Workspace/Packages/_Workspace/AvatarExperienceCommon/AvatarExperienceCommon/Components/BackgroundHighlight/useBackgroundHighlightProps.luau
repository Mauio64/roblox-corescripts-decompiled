local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Foundation = require(Parent.Foundation)

require(script.Parent.BackgroundHighlight)

local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: useTokens (copy)
	local Surface_100 = useTokens().Color.Surface.Surface_100

	return {
		ZIndex = t1.ZIndex or 0,
		highlightColor = Surface_100
	}
end
