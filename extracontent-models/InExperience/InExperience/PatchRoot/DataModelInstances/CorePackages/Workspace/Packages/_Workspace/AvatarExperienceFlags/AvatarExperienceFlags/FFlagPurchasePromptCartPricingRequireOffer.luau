local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagMarketplaceOffersOptOutRoot = SharedFlags.FFlagMarketplaceOffersOptOutRoot

return game:DefineFastFlag("PurchasePromptCartPricingRequireOffer2", false) and FFlagMarketplaceOffersOptOutRoot
