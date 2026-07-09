local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local FFlagMarketplaceOffersRoot = require(Parent.SharedFlags).FFlagMarketplaceOffersRoot

return game:DefineFastFlag("AXPartialPageModalBackgroundShim2", false) and FFlagMarketplaceOffersRoot
