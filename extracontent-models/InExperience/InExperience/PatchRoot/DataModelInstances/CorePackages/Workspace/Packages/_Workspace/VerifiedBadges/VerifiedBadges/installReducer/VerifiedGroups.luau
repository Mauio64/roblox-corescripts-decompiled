local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")

local Rodux = require(VerifiedBadges.Parent.Rodux)
local Cryo = require(VerifiedBadges.Parent.Cryo)

local SharedFlags = require(VerifiedBadges.Parent.SharedFlags)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = SharedFlags.FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local SharedFlags2 = require(VerifiedBadges.Parent.SharedFlags)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = SharedFlags2.FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return Rodux.createReducer({}, {
	AddGameDetails = function(p, p2)
		local v = {}

		for _, gameDetail in pairs(p2.gameDetails) do
			local id = tostring(gameDetail.creator.id)
			local kind = gameDetail.creator.type
			local hasVerifiedBadge = gameDetail.creator.hasVerifiedBadge

			if kind == Enum.CreatorType.Group.Name then
				v[id] = hasVerifiedBadge and true or Cryo.None
			end
		end

		return Cryo.Dictionary.join(p, v)
	end,
	AddGameDetailsV2 = (FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp) and function(p, p2)
		local v = {}

		for _, gameDetail in pairs(p2.gameDetails) do
			local id = tostring(gameDetail.creator.id)
			local kind = gameDetail.creator.type
			local hasVerifiedBadge = gameDetail.creator.hasVerifiedBadge

			if kind == Enum.CreatorType.Group.Name then
				v[id] = hasVerifiedBadge and true or Cryo.None
			end
		end

		return Cryo.Dictionary.join(p, v)
	end or nil,
	SetAssetInfoFromCatalogItemAction = function(p, p2)
		if p2.assetData.creatorType ~= Enum.CreatorType.Group.Name then
			return p
		end

		local creatorTargetId = tostring(p2.assetData.creatorTargetId)
		local creatorHasVerifiedBadge = p2.assetData.creatorHasVerifiedBadge
		return Cryo.Dictionary.join(p, {
			[creatorTargetId] = creatorHasVerifiedBadge and true or Cryo.None
		})
	end
})
