local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local useHasAtLeastOneCatalogOffer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useHasAtLeastOneCatalogOffer")

local function useShouldFetchCartPricingForLookPurchasePrompt(): boolean
	local v5 = useHasAtLeastOneCatalogOffer()

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingRequireOffer and not v5 then
		return false
	end

	return true
end

return useShouldFetchCartPricingForLookPurchasePrompt
