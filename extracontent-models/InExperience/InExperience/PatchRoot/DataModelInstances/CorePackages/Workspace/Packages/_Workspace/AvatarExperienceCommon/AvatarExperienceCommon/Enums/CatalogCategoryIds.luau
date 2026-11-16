local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	All = 1,
	Characters = 2,
	Accessories = 11,
	Heads = 5,
	AllAnimations = 12,
	Body = 18,
	Clothing = 3
})
