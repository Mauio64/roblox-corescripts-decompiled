local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local useHasAtLeastOneCatalogOffer = require(script.Parent.useHasAtLeastOneCatalogOffer)

local function useShouldFetchCartPricingForLookPurchasePrompt() -- line: 22
	-- upvalues: useHasAtLeastOneCatalogOffer (copy), AvatarExperienceFlags (copy)
	local v5 = useHasAtLeastOneCatalogOffer()

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingRequireOffer and not v5 then
		return false
	end

	return true
end

return useShouldFetchCartPricingForLookPurchasePrompt
