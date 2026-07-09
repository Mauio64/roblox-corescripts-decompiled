local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Modules = CoreGui.RobloxGui.Modules
local GenerateStringId = require(CorePackages.Workspace.Packages.AppCommonLib).GenerateStringId
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping

return {
	mock = function() -- line: 60
		-- upvalues: GenerateStringId (copy), CatalogConstants (copy)
		return {
			collectibleItemId = GenerateStringId(),
			collectibleProductId = GenerateStringId(),
			name = "",
			description = "",
			creator = {
				name = "",
				type = "",
				targetId = "",
				hasVerifiedBadge = false,
				id = GenerateStringId()
			},
			price = 1,
			lowestPrice = 0,
			unitsAvailableForConsumption = 0,
			offsaleDeadline = "",
			assetStock = 0,
			recentAveragePrice = 0,
			saleLocationType = "ShopAndAllExperiences",
			quantityLimitPerUser = 0,
			resaleRestriction = CatalogConstants.ResaleRestriction.None
		}
	end,
	fromGetCollectibleItemData = function(p1) -- line: 90
		-- upvalues: FFlagAXMISEnableMultiShopping (copy)
		local t1 = {
			collectibleItemId = p1.collectibleItemId,
			collectibleProductId = p1.collectibleProductId,
			name = p1.name,
			description = p1.description,
			creator = {
				id = p1.creatorId,
				name = p1.creatorName,
				type = p1.creatorType,
				targetId = p1.creatorTargetId,
				hasVerifiedBadge = p1.creatorHasVerifiedBadge
			},
			price = p1.price,
			lowestPrice = p1.lowestPrice,
			unitsAvailableForConsumption = p1.unitsAvailableForConsumption,
			offsaleDeadline = p1.offsaleDeadline,
			assetStock = p1.assetStock,
			saleLocationType = p1.saleLocationType,
			quantityLimitPerUser = p1.quantityLimitPerUser,
			experiences = p1.experiences,
			resaleRestriction = p1.resaleRestriction
		}

		if FFlagAXMISEnableMultiShopping then
			t1.lowestAvailableResaleProductId = p1.lowestAvailableResaleProductId
			t1.lowestAvailableResaleItemInstanceId = p1.lowestAvailableResaleItemInstanceId
		end

		return t1
	end,
	fromGetResellers = function(p2) -- line: 125
		return {
			hasResellers = #p2 > 0
		}
	end,
	fromGetResaleData = function(p3) -- line: 132
		return {
			recentAveragePrice = p3.recentAveragePrice
		}
	end
}
