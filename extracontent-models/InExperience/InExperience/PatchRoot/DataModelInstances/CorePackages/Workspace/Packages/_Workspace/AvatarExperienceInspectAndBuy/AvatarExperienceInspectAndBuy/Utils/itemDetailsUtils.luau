local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(parent.AXCommon)
local ItemRestrictions = AXCommon.Enums.ItemRestrictions
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local VerifiedBadges = require(parent.VerifiedBadges)
local Constants = require(AvatarExperienceInspectAndBuy.Constants)

require(AvatarExperienceInspectAndBuy.Types)
local ItemDetailsUtils = {}

function ItemDetailsUtils.isCollectible(p): boolean
	if not (p and p.itemRestrictions) then
		return false
	end

	local itemRestriction = p.itemRestrictions[ItemRestrictions.Collectible]
	local itemRestriction2 = p.itemRestrictions[ItemRestrictions.Limited]
	local itemRestriction3 = p.itemRestrictions[ItemRestrictions.LimitedUnique]

	if itemRestriction or itemRestriction2 or itemRestriction3 then
		return true
	end

	return false
end

function ItemDetailsUtils.isInExperienceCreationPlayable(p): boolean
	local playabilityStatus

	if p then
		playabilityStatus = p.playabilityStatus
	end

	if playabilityStatus and Constants.ShowPlayableAttributionMapper[playabilityStatus] then
		return true
	end

	return false
end

function ItemDetailsUtils.isTradeable(p)
	return p
		and p.itemRestrictions
		and (p.itemRestrictions[ItemRestrictions.Limited] or p.itemRestrictions[ItemRestrictions.LimitedUnique])
end

function ItemDetailsUtils.getPriceInRobux(p, p2)
	if p and p2 == PriceStatus.PurchaseFromResale and p.collectibleItemDetails then
		return p.collectibleItemDetails.lowestResalePrice
	end

	return if p then p.priceInRobux else nil
end

function ItemDetailsUtils.getItemWidth(p: number, p2: number, p3: number)
	local v = math.floor((p - (p2 - 1) * p3) / p2)
	return if v < 0 then 0 else v
end

function ItemDetailsUtils.getCreatorName(p)
	if p and p.creator and p.creator.creatorHasVerifiedBadge and p.creator.creatorName then
		return `{p.creator.creatorName}{VerifiedBadges.emoji.verified}`
	end

	if p and p.creator and p.creator.creatorName then
		return p.creator.creatorName
	end

	return ""
end

function ItemDetailsUtils.getOriginalPrice(p, p2: string, callback)
	if p and p.isOffSale then
		return p2
	end

	if p and p.priceInRobux then
		return callback(p.priceInRobux)
	end

	return ""
end

function ItemDetailsUtils.getQuantitySold(p, callback)
	if
		p
		and p.collectibleItemDetails
		and p.collectibleItemDetails.totalQuantity
		and p.collectibleItemDetails.unitsAvailableForConsumption
	then
		return callback(p.collectibleItemDetails.totalQuantity - p.collectibleItemDetails.unitsAvailableForConsumption) .. "/" .. callback(p.collectibleItemDetails.totalQuantity)
	end

	return ""
end

function ItemDetailsUtils.calculatePurchaseStatusForItem(p, p2)
	local lowestResalePrice, collectibleLowestAvailableResaleProductId, collectibleLowestAvailableResaleItemInstanceId

	if p2 == PriceStatus.PurchaseFromResale and p.collectibleItemDetails then
		lowestResalePrice = p.collectibleItemDetails.lowestResalePrice

		collectibleLowestAvailableResaleProductId = p.collectibleItemDetails.collectibleLowestAvailableResaleProductId

		collectibleLowestAvailableResaleItemInstanceId = p.collectibleItemDetails.collectibleLowestAvailableResaleItemInstanceId
	end

	return {
		collectibleItemId = p.collectibleItemId,
		collectibleLowestResalePrice = lowestResalePrice,
		collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
		collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId
	}
end

function ItemDetailsUtils.shouldShowPriceLabel(p): boolean
	return p == nil or p == PriceStatus.PurchaseFromResale or p == PriceStatus.PurchaseFromRoblox
end

return ItemDetailsUtils
