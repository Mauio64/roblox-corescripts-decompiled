local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Rodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Cryo")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/dependencies")

local usersNetworking = dependencies.UsersNetworking
local friendsNetworking = dependencies.FriendsNetworking

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local function fn(p2, list)
	local v5 = {}

	for i, item in ipairs(list) do
		v5[tostring(item.id)] = item.hasVerifiedBadge and true or Cryo.None
	end

	return Cryo.Dictionary.join(p2, v5)
end

return Rodux.createReducer({}, {
	[usersNetworking.GetUserV2FromUserId.Succeeded.name] = function(p2, p3)
		return fn(p2, { p3.responseBody })
	end,
	[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, p3)
		return fn(p2, p3.responseBody.data)
	end,
	AddGameDetails = function(p2, p3)
		local v6 = {}

		for k, gameDetail in pairs(p3.gameDetails) do
			local id = tostring(gameDetail.creator.id)
			local kind = gameDetail.creator.type
			local hasVerifiedBadge = gameDetail.creator.hasVerifiedBadge

			if kind == Enum.CreatorType.User.Name then
				v6[id] = hasVerifiedBadge and true or Cryo.None
			end
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	AddGameDetailsV2 = (fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp) and function(p2, p3)
		local v6 = {}

		for k, gameDetail in pairs(p3.gameDetails) do
			local id = tostring(gameDetail.creator.id)
			local kind = gameDetail.creator.type
			local hasVerifiedBadge = gameDetail.creator.hasVerifiedBadge

			if kind == Enum.CreatorType.User.Name then
				v6[id] = hasVerifiedBadge and true or Cryo.None
			end
		end

		return Cryo.Dictionary.join(p2, v6)
	end or nil,
	SetAssetInfoFromCatalogItemAction = function(p2, p3)
		if p3.assetData.creatorType ~= Enum.CreatorType.User.Name then
			return p2
		end

		local creatorTargetId = tostring(p3.assetData.creatorTargetId)
		local creatorHasVerifiedBadge = p3.assetData.creatorHasVerifiedBadge
		return Cryo.Dictionary.join(p2, {
			[creatorTargetId] = creatorHasVerifiedBadge and true or Cryo.None
		})
	end
})
