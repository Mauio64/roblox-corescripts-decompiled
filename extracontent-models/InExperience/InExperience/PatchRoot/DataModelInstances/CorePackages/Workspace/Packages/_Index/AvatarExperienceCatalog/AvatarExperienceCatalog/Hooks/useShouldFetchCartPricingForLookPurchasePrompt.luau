local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local useHasAtLeastOneCatalogOffer = require(script.Parent.useHasAtLeastOneCatalogOffer)

local function useShouldFetchCartPricingForLookPurchasePrompt(): boolean
	local v = useHasAtLeastOneCatalogOffer()

	return not (AvatarExperienceFlags.FFlagPurchasePromptCartPricingRequireOffer and not v)
end

return useShouldFetchCartPricingForLookPurchasePrompt
