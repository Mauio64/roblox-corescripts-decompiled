local parent = script:FindFirstAncestor("DiscoveryHeroUnit").Parent
require(parent.Foundation)

return {
	HeroNarrowLayout = { Compact = "Compact", Square = "Square", Tall = "Tall" }
}
