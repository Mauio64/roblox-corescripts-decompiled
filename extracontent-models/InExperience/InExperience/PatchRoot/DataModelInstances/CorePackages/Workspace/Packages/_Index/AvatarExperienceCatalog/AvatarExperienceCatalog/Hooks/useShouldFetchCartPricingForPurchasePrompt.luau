local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local ItemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local useHasAtLeastOneCatalogOffer = require(script.Parent.useHasAtLeastOneCatalogOffer)

local function isFree(p): boolean -- 1 equivalent call inferred from this helper
	local priceInRobux = p.priceInRobux
	return priceInRobux == nil or priceInRobux <= 0
end

local function isLimitedCollectible(p): boolean -- 1 equivalent call inferred from this helper
	local itemRestrictions = p.itemRestrictions

	if itemRestrictions == nil then
		return false
	end

	return itemRestrictions[ItemRestrictions.Limited] == true
		or itemRestrictions[ItemRestrictions.LimitedUnique] == true
		or itemRestrictions[ItemRestrictions.Collectible] == true
end

local function useShouldFetchCartPricingForPurchasePrompt(p): boolean
	local v = useHasAtLeastOneCatalogOffer()
	local v2 = useNavigation()

	if
		p == nil
		or AvatarExperienceFlags.FFlagPurchasePromptCartPricingSkipFreeItems and isFree(p) -- inferred equivalent call
		or AvatarExperienceFlags.FFlagPurchasePromptCartPricingSkipLimitedCollectibles and isLimitedCollectible(p) -- inferred equivalent call
	then
		return false
	end

	if
		v2
		and v2.state
		and (v2.state.routeName == AvatarScreen.TryOnItem or v2.state.params and v2.state.params.fromProfile)
	then
		return true
	end

	return not (AvatarExperienceFlags.FFlagPurchasePromptCartPricingRequireOffer and not v)
end

return useShouldFetchCartPricingForPurchasePrompt
