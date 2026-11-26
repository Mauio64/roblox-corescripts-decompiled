local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Cryo")

return Rodux.createReducer({}, {
	AddGameDetails = function(p2, p3)
		local v5 = {}

		for k, gameDetail in pairs(p3.gameDetails) do
			local id = tostring(gameDetail.creator.id)
			local kind = gameDetail.creator.type
			local hasVerifiedBadge = gameDetail.creator.hasVerifiedBadge

			if kind == Enum.CreatorType.Group.Name then
				v5[id] = hasVerifiedBadge and true or Cryo.None
			end
		end

		return Cryo.Dictionary.join(p2, v5)
	end,
	AddGameDetailsV2 = function(p2, p3)
		local v5 = {}

		for k, gameDetail in pairs(p3.gameDetails) do
			local id = tostring(gameDetail.creator.id)
			local kind = gameDetail.creator.type
			local hasVerifiedBadge = gameDetail.creator.hasVerifiedBadge

			if kind == Enum.CreatorType.Group.Name then
				v5[id] = hasVerifiedBadge and true or Cryo.None
			end
		end

		return Cryo.Dictionary.join(p2, v5)
	end,
	SetAssetInfoFromCatalogItemAction = function(p2, p3)
		if p3.assetData.creatorType ~= Enum.CreatorType.Group.Name then
			return p2
		end

		local creatorTargetId = tostring(p3.assetData.creatorTargetId)
		local creatorHasVerifiedBadge = p3.assetData.creatorHasVerifiedBadge
		return Cryo.Dictionary.join(p2, {
			[creatorTargetId] = creatorHasVerifiedBadge and true or Cryo.None
		})
	end
})
