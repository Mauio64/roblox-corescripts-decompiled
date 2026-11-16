local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

require(parent.AvatarExperienceUIKit)

local function shouldRenderIndicatorStack(p, p2): boolean
	return p ~= nil or p2 ~= nil
end

return shouldRenderIndicatorStack
