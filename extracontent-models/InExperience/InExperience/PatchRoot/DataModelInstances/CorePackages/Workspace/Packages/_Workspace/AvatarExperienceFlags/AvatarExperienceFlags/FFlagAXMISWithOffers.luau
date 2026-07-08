local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local FFlagMarketplaceOffersRoot = require(Parent.SharedFlags).FFlagMarketplaceOffersRoot

return game:DefineFastFlag("AXMISWithOffers4", false) and FFlagMarketplaceOffersRoot
