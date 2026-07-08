local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local ItemRestrictions = require(AvatarExperienceInspectAndBuyParent.AXCommon).Enums.ItemRestrictions
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local VerifiedBadges = require(AvatarExperienceInspectAndBuyParent.VerifiedBadges)
local Constants = require(AvatarExperienceInspectAndBuy.Constants)

require(AvatarExperienceInspectAndBuy.Types)

return {
	isCollectible = function(p1) -- line: 17
		-- upvalues: ItemRestrictions (copy)
		if not p1 then
			return false
		end

		if not p1.itemRestrictions then
			return false
		end

		local v8 = p1.itemRestrictions[ItemRestrictions.Collectible]
		local v9 = p1.itemRestrictions[ItemRestrictions.Limited]
		local v10 = p1.itemRestrictions[ItemRestrictions.LimitedUnique]

		if v8 or v9 or v10 then
			return true
		end

		return false
	end,
	isInExperienceCreationPlayable = function(p2) -- line: 37
		-- upvalues: Constants (copy)
		local v12 = if not p2 then nil else p2.playabilityStatus

		if v12 and Constants.ShowPlayableAttributionMapper[v12] then
			return true
		end

		return false
	end,
	isTradeable = function(p3) -- line: 76
		-- upvalues: ItemRestrictions (copy)
		return p3 and (p3.itemRestrictions and (p3.itemRestrictions[ItemRestrictions.Limited] or p3.itemRestrictions[ItemRestrictions.LimitedUnique]))
	end,
	getPriceInRobux = function(p4, p5) -- line: 85
		-- upvalues: PriceStatus (copy)
		if p4 and (p5 == PriceStatus.PurchaseFromResale and p4.collectibleItemDetails) then
			return p4.collectibleItemDetails.lowestResalePrice
		end

		if p4 then
			return p4.priceInRobux
		end

		return nil
	end,
	getItemWidth = function(n1: number, n2: number, n3: number) -- line: 93
		local v24 = math.floor((n1 - (n2 - 1) * n3) / n2)

		if v24 < 0 then
			return 0
		end

		return v24
	end,
	getCreatorName = function(p6) -- line: 103
		-- upvalues: VerifiedBadges (copy)
		if p6 and (p6.creator and p6.creator.creatorHasVerifiedBadge and p6.creator.creatorName) then
			return `{ p6.creator.creatorName }{ VerifiedBadges.emoji.verified }`
		end

		if p6 and p6.creator and p6.creator.creatorName then
			return p6.creator.creatorName
		end

		return ""
	end,
	getOriginalPrice = function(p7, s1: string, p8: ((...any) -> ...any)) -- line: 113
		if p7 and p7.isOffSale then
			return s1
		end

		if p7 and p7.priceInRobux then
			return p8(p7.priceInRobux)
		end

		return ""
	end,
	getQuantitySold = function(p9, p10: ((...any) -> ...any)) -- line: 123
		if p9 and (p9.collectibleItemDetails and p9.collectibleItemDetails.totalQuantity and p9.collectibleItemDetails.unitsAvailableForConsumption) then
			return p10(p9.collectibleItemDetails.totalQuantity - p9.collectibleItemDetails.unitsAvailableForConsumption) .. "/" .. p10(p9.collectibleItemDetails.totalQuantity)
		end

		return ""
	end,
	calculatePurchaseStatusForItem = function(p11, p12) -- line: 55
		-- upvalues: PriceStatus (copy)
		local lowestResalePrice = nil
		local collectibleLowestAvailableResaleProductId = nil
		local collectibleLowestAvailableResaleItemInstanceId = nil

		if p12 == PriceStatus.PurchaseFromResale and p11.collectibleItemDetails then
			lowestResalePrice = p11.collectibleItemDetails.lowestResalePrice
			collectibleLowestAvailableResaleProductId = p11.collectibleItemDetails.collectibleLowestAvailableResaleProductId
			collectibleLowestAvailableResaleItemInstanceId = p11.collectibleItemDetails.collectibleLowestAvailableResaleItemInstanceId
		end

		return {
			collectibleItemId = p11.collectibleItemId,
			collectibleLowestResalePrice = lowestResalePrice,
			collectibleLowestAvailableResaleProductId = collectibleLowestAvailableResaleProductId,
			collectibleLowestAvailableResaleItemInstanceId = collectibleLowestAvailableResaleItemInstanceId
		}
	end,
	shouldShowPriceLabel = function(p13) -- line: 147
		-- upvalues: PriceStatus (copy)
		return p13 == nil or (p13 == PriceStatus.PurchaseFromResale or p13 == PriceStatus.PurchaseFromRoblox)
	end
}
