local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
require(parent.Foundation)

local function getCollapsedTextHeight(p, p2: number)
	local bodyLarge = p.Typography.BodyLarge
	return bodyLarge.FontSize + (p2 - 1) * bodyLarge.FontSize * bodyLarge.LineHeight
end

return getCollapsedTextHeight
