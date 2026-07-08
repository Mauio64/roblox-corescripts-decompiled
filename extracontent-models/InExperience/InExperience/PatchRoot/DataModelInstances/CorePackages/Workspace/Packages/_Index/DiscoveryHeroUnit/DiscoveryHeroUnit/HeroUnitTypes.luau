local Parent = script:FindFirstAncestor("DiscoveryHeroUnit").Parent

require(Parent.Foundation)

return {
	HeroNarrowLayout = {
		Compact = "Compact",
		Square = "Square",
		Tall = "Tall"
	}
}
