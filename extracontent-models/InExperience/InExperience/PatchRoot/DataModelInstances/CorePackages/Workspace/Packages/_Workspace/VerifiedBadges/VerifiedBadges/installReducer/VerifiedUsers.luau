local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local Rodux = require(VerifiedBadges.Parent.Rodux)
local Cryo = require(VerifiedBadges.Parent.Cryo)
local dependencies = require(VerifiedBadges.dependencies)
local UsersNetworking = dependencies.UsersNetworking
local FriendsNetworking = dependencies.FriendsNetworking
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(VerifiedBadges.Parent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(VerifiedBadges.Parent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function v9(t1: {[any]: any}, t2: {[any]: any}) -- line: 24
	-- upvalues: Cryo (copy)
	local t3 = {}

	for _, v in ipairs(t2) do
		t3[tostring(v.id)] = not not v.hasVerifiedBadge or Cryo.None
	end

	return Cryo.Dictionary.join(t1, t3)
end

return Rodux.createReducer({}, {
	[UsersNetworking.GetUserV2FromUserId.Succeeded.name] = function(t4: {[any]: any}, p1) -- line: 35
		-- upvalues: v9 (copy)
		return v9(t4, { p1.responseBody })
	end,
	[FriendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(t5: {[any]: any}, p2) -- line: 39
		-- upvalues: v9 (copy)
		return v9(t5, p2.responseBody.data)
	end,
	AddGameDetails = function(t6: {[any]: any}, p3) -- line: 43
		-- upvalues: Cryo (copy)
		local t7 = {}

		for _, v in pairs(p3.gameDetails) do
			local str = tostring(v.creator.id)
			local type = v.creator.type
			local hasVerifiedBadge = v.creator.hasVerifiedBadge

			if type == Enum.CreatorType.User.Name then
				t7[str] = not not hasVerifiedBadge or Cryo.None
			end
		end

		return Cryo.Dictionary.join(t6, t7)
	end,
	AddGameDetailsV2 = if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else function(t8: {[any]: any}, p4) -- line: 60
		-- upvalues: Cryo (copy)
		local t9 = {}

		for _, v in pairs(p4.gameDetails) do
			local str = tostring(v.creator.id)
			local type = v.creator.type
			local hasVerifiedBadge = v.creator.hasVerifiedBadge

			if type == Enum.CreatorType.User.Name then
				t9[str] = not not hasVerifiedBadge or Cryo.None
			end
		end

		return Cryo.Dictionary.join(t8, t9)
	end,
	SetAssetInfoFromCatalogItemAction = function(t10: {[any]: any}, p5) -- line: 77
		-- upvalues: Cryo (copy)
		if p5.assetData.creatorType ~= Enum.CreatorType.User.Name then
			return t10
		end

		local str = tostring(p5.assetData.creatorTargetId)
		local creatorHasVerifiedBadge = p5.assetData.creatorHasVerifiedBadge

		return Cryo.Dictionary.join(t10, {
			[str] = not not creatorHasVerifiedBadge or Cryo.None
		})
	end
})
