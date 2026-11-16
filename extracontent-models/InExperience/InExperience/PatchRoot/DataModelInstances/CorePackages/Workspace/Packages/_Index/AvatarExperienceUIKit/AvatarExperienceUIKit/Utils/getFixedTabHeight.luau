local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
require(parent.Foundation)

local function getFixedTabHeight(p)
	return p.Size.Size_800
end

return getFixedTabHeight
