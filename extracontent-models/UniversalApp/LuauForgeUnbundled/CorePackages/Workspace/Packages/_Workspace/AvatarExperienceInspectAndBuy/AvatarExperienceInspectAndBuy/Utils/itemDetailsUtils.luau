local itemRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon").Enums.ItemRestrictions
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/VerifiedBadges")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Constants")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

return {
	isCollectible = function(p2): boolean
		if not (p2 and p2.itemRestrictions) then
			return false
		end

		local itemRestriction = p2.itemRestrictions[itemRestrictions.Collectible]
		local itemRestriction2 = p2.itemRestrictions[itemRestrictions.Limited]
		local itemRestriction3 = p2.itemRestrictions[itemRestrictions.LimitedUnique]

		if itemRestriction or itemRestriction2 or itemRestriction3 then
			return true
		end

		return false
	end,
	isInExperienceCreationPlayable = function(p2): boolean
		local playabilityStatus = if p2 then p2.playabilityStatus else nil

		if playabilityStatus and Constants.ShowPlayableAttributionMapper[playabilityStatus] then
			return true
		end

		return false
	end,
	isTradeable = function(p2)
		return p2
			and p2.itemRestrictions
			and (p2.itemRestrictions[itemRestrictions.Limited] or p2.itemRestrictions[itemRestrictions.LimitedUnique])
	end,
	getPriceInRobux = function(p2, p3)
		if p2 and p3 == PriceStatus.PurchaseFromResale and p2.collectibleItemDetails then
			return p2.collectibleItemDetails.lowestResalePrice
		end

		if p2 then
			return p2.priceInRobux
		end

		return nil
	end,
	getItemWidth = function(p2, p3, p4)
		local v5 = math.floor((p2 - (p3 - 1) * p4) / p3)

		if v5 < 0 then
			return 0
		end

		return v5
	end,
	getCreatorName = function(p2)
		if p2 and p2.creator and p2.creator.creatorHasVerifiedBadge and p2.creator.creatorName then
			return `{p2.creator.creatorName}{module2.emoji.verified}`
		end

		if p2 and p2.creator and p2.creator.creatorName then
			return p2.creator.creatorName
		end

		return ""
	end,
	getOriginalPrice = function(p2, p3, callback)
		if p2 and p2.isOffSale then
			return p3
		end

		if p2 and p2.priceInRobux then
			return callback(p2.priceInRobux)
		end

		return ""
	end,
	getQuantitySold = function(p2, callback)
		if
			p2
			and p2.collectibleItemDetails
			and p2.collectibleItemDetails.totalQuantity
			and p2.collectibleItemDetails.unitsAvailableForConsumption
		then
			return callback(p2.collectibleItemDetails.totalQuantity - p2.collectibleItemDetails.unitsAvailableForConsumption) .. "/" .. callback(p2.collectibleItemDetails.totalQuantity)
		end

		return ""
	end,
	calculatePurchaseStatusForItem = function(p2, p3)
		local lowestResalePrice, collectibleLowestAvailableResaleProductId, collectibleLowestAvailableResaleItemInstanceId

		if p3 == PriceStatus.PurchaseFromResale and p2.collectibleItemDetails then
			lowestResalePrice = p2.collectibleItemDetails.lowestResalePrice

			collectibleLowestAvailableResaleProductId = p2.collectibleItemDetails.collectibleLowestAvailableResaleProductId

			collectibleLowestAvailableResaleItemInstanceId = p2.collectibleItemDetails.collectibleLowestAvailableResaleItemInstanceId
		end

		return {
			collectibleItemId = p2.collectibleItemId,
			collectibleLowestResalePrice = lowestResalePrice,
			collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
			collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId
		}
	end,
	shouldShowPriceLabel = function(p2): boolean
		return p2 == nil or p2 == PriceStatus.PurchaseFromResale or p2 == PriceStatus.PurchaseFromRoblox
	end
}
