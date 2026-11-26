require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")

local function getCollapsedTextHeight(p2, p3)
	local bodyLarge = p2.Typography.BodyLarge
	return bodyLarge.FontSize + (p3 - 1) * bodyLarge.FontSize * bodyLarge.LineHeight
end

return getCollapsedTextHeight
