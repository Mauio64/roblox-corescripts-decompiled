local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent

require(Parent.Foundation)

local function getFixedTabHeight(p1) -- line: 11
	return p1.Size.Size_800
end

return getFixedTabHeight
