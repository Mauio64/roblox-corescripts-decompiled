local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagMarketplaceOffersRoot = SharedFlags.FFlagMarketplaceOffersRoot
local FFlagMarketplaceOffersOptOutRoot = SharedFlags.FFlagMarketplaceOffersOptOutRoot

return game:DefineFastFlag("PurchasePromptCartPricingRequireOffer2", false) and (FFlagMarketplaceOffersRoot and FFlagMarketplaceOffersOptOutRoot)
