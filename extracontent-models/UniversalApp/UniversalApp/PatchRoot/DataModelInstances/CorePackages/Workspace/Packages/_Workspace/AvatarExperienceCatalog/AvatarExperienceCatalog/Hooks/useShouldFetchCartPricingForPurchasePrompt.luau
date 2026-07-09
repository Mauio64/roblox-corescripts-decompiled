local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local ItemRestrictions = require(Parent.AvatarExperienceCommon).Enums.ItemRestrictions
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local useHasAtLeastOneCatalogOffer = require(script.Parent.useHasAtLeastOneCatalogOffer)

local function isFree(t1: {[any]: any}) -- line: 52
	local priceInRobux = t1.priceInRobux

	return priceInRobux == nil or priceInRobux <= 0
end
local function isLimitedCollectible(t2: {[any]: any}) -- line: 57
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t2.itemRestrictions

	if itemRestrictions == nil then
		return false
	end

	return itemRestrictions[ItemRestrictions.Limited] == true or (itemRestrictions[ItemRestrictions.LimitedUnique] == true or itemRestrictions[ItemRestrictions.Collectible] == true)
end
local function useShouldFetchCartPricingForPurchasePrompt(t3: {[any]: any}?) -- line: 67
	-- upvalues: useHasAtLeastOneCatalogOffer (copy), AvatarExperienceFlags (copy), ItemRestrictions (copy)
	local v13 = useHasAtLeastOneCatalogOffer()

	if t3 == nil then
		return false
	end

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingSkipFreeItems then
		local priceInRobux = t3.priceInRobux

		if priceInRobux == nil or priceInRobux <= 0 then
			return false
		end
	end

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingSkipLimitedCollectibles then
		local itemRestrictions = t3.itemRestrictions

		if itemRestrictions ~= nil and (itemRestrictions[ItemRestrictions.Limited] == true or (itemRestrictions[ItemRestrictions.LimitedUnique] == true or itemRestrictions[ItemRestrictions.Collectible] == true)) then
			return false
		end
	end

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingRequireOffer and not v13 then
		return false
	end

	return true
end

return useShouldFetchCartPricingForPurchasePrompt
