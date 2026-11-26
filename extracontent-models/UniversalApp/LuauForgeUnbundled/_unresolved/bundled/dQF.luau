local generateStringId = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GenerateStringId
local defineFastFlag = game:DefineFastFlag("AXFixResalePurchaseWhenPriceNil", false)

local module = require("@luauforge/bundled/dPU")

return {
	mock = function()
		return {
			["collectibleItemId"] = generateStringId(),
			collectibleProductId = generateStringId(),
			name = "",
			description = "",
			creator = {
				id = generateStringId(),
				name = "",
				type = "",
				targetId = "",
				hasVerifiedBadge = false
			},
			price = 1,
			lowestPrice = 0,
			unitsAvailableForConsumption = 0,
			offsaleDeadline = "",
			assetStock = 0,
			recentAveragePrice = 0,
			saleLocationType = "ShopAndAllExperiences",
			quantityLimitPerUser = 0,
			resaleRestriction = module.ResaleRestriction.None
		}
	end,
	fromGetCollectibleItemData = function(data)
		local v5 = {}

		v5.collectibleItemId = data.collectibleItemId
		v5.collectibleProductId = data.collectibleProductId

		v5.name = data.name
		v5.description = data.description

		v5.creator = {
			id = data.creatorId,
			name = data.creatorName,
			type = data.creatorType,
			targetId = data.creatorTargetId,
			hasVerifiedBadge = data.creatorHasVerifiedBadge
		}

		if defineFastFlag then
			v5.price = data.price or 0
		else
			v5.price = data.price
		end

		v5.lowestPrice = data.lowestPrice
		v5.unitsAvailableForConsumption = data.unitsAvailableForConsumption
		v5.offsaleDeadline = data.offsaleDeadline
		v5.assetStock = data.assetStock
		v5.saleLocationType = data.saleLocationType
		v5.quantityLimitPerUser = data.quantityLimitPerUser
		v5.experiences = data.experiences
		v5.resaleRestriction = data.resaleRestriction
		v5.lowestAvailableResaleProductId = data.lowestAvailableResaleProductId
		v5.lowestAvailableResaleItemInstanceId = data.lowestAvailableResaleItemInstanceId

		return v5
	end,
	fromGetResellers = function(list)
		return {
			hasResellers = #list > 0
		}
	end,
	fromGetResaleData = function(p2)
		return { recentAveragePrice = p2.recentAveragePrice }
	end
}
