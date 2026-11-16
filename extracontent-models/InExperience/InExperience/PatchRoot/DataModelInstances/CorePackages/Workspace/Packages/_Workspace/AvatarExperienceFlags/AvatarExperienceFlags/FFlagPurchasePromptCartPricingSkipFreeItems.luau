local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagMarketplaceOffersOptOutRoot = SharedFlags.FFlagMarketplaceOffersOptOutRoot

return game:DefineFastFlag("PurchasePromptCartPricingSkipFreeItems2", false) and FFlagMarketplaceOffersOptOutRoot
