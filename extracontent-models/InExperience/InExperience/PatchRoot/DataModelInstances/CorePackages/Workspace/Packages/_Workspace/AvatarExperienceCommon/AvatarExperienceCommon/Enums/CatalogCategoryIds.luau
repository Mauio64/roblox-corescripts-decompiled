local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

return require(Parent.enumerate)(script.Name, {
	All = 1,
	Characters = 2,
	Accessories = 11,
	Heads = 5,
	AllAnimations = 12,
	Body = 18,
	Clothing = 3
})
