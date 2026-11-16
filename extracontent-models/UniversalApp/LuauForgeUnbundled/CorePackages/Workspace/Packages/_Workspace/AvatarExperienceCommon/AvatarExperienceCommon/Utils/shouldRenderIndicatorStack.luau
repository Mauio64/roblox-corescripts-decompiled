require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit")

local function shouldRenderIndicatorStack(p2, p3): boolean
	return p2 ~= nil or p3 ~= nil
end

return shouldRenderIndicatorStack
