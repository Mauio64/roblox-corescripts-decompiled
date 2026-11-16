local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigation
local itemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local useHasAtLeastOneCatalogOffer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useHasAtLeastOneCatalogOffer")

local function isFree(p2): boolean
	local priceInRobux = p2.priceInRobux
	return priceInRobux == nil or priceInRobux <= 0
end

local function isLimitedCollectible(p2): boolean
	local itemRestrictions2 = p2.itemRestrictions

	if itemRestrictions2 == nil then
		return false
	end

	return itemRestrictions2[itemRestrictions.Limited] == true
		or itemRestrictions2[itemRestrictions.LimitedUnique] == true
		or itemRestrictions2[itemRestrictions.Collectible] == true
end

local function useShouldFetchCartPricingForPurchasePrompt(p2): boolean
	local v5 = useHasAtLeastOneCatalogOffer()
	local v6 = useNavigation()

	if p2 == nil then
		return false
	end

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingSkipFreeItems then
		local priceInRobux = p2.priceInRobux

		if priceInRobux == nil or priceInRobux <= 0 then
			return false
		end
	end

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingSkipLimitedCollectibles then
		local itemRestrictions2 = p2.itemRestrictions
		local v7

		if itemRestrictions2 == nil then
			v7 = false
		else
			v7 = itemRestrictions2[itemRestrictions.Limited] == true
				or itemRestrictions2[itemRestrictions.LimitedUnique] == true
				or itemRestrictions2[itemRestrictions.Collectible] == true
		end

		if v7 then
			return false
		end
	end

	if
		v6
		and v6.state
		and (v6.state.routeName == avatarScreen.TryOnItem or v6.state.params and v6.state.params.fromProfile)
	then
		return true
	end

	if AvatarExperienceFlags.FFlagPurchasePromptCartPricingRequireOffer and not v5 then
		return false
	end

	return true
end

return useShouldFetchCartPricingForPurchasePrompt
