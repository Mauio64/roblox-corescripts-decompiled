local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local Rodux = require(VerifiedBadges.Parent.Rodux)
local Cryo = require(VerifiedBadges.Parent.Cryo)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(VerifiedBadges.Parent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(VerifiedBadges.Parent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return Rodux.createReducer({}, {
	AddGameDetails = function(t1: {[any]: any}, p1) -- line: 16
		-- upvalues: Cryo (copy)
		local t2 = {}

		for _, v in pairs(p1.gameDetails) do
			local str = tostring(v.creator.id)
			local type = v.creator.type
			local hasVerifiedBadge = v.creator.hasVerifiedBadge

			if type == Enum.CreatorType.Group.Name then
				t2[str] = not not hasVerifiedBadge or Cryo.None
			end
		end

		return Cryo.Dictionary.join(t1, t2)
	end,
	AddGameDetailsV2 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else function(t3: {[any]: any}, p2) -- line: 33
		-- upvalues: Cryo (copy)
		local t4 = {}

		for _, v in pairs(p2.gameDetails) do
			local str = tostring(v.creator.id)
			local type = v.creator.type
			local hasVerifiedBadge = v.creator.hasVerifiedBadge

			if type == Enum.CreatorType.Group.Name then
				t4[str] = not not hasVerifiedBadge or Cryo.None
			end
		end

		return Cryo.Dictionary.join(t3, t4)
	end,
	SetAssetInfoFromCatalogItemAction = function(t5: {[any]: any}, p3) -- line: 48
		-- upvalues: Cryo (copy)
		if p3.assetData.creatorType ~= Enum.CreatorType.Group.Name then
			return t5
		end

		local str = tostring(p3.assetData.creatorTargetId)
		local creatorHasVerifiedBadge = p3.assetData.creatorHasVerifiedBadge

		return Cryo.Dictionary.join(t5, {
			[str] = not not creatorHasVerifiedBadge or Cryo.None
		})
	end
})
