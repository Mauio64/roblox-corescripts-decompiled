local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsStoreTypes")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")

local function findByAssetId(items, p2)
	if items == nil then
		return nil
	end

	for k, item in items do
		if item.assetId == p2 then
			return item
		end
	end

	return nil
end

local function refreshOwnMomentsAfterPublish(p2, options)
	local v5 = options or {}
	local v6 = if v5.userStore == nil then MomentsGetMomentsUserStore(false) else v5.userStore

	local wait2 = v5.wait or function(duration)
		task.wait(duration)
	end
	local v7

	if v5.getLocalUserId == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer ~= nil then
			v7 = localPlayer.UserId
		end
	else
		v7 = v5.getLocalUserId()
	end

	if v7 == nil then
		return nil
	end

	for i = 1, 6 do
		if i > 1 then
			wait2(2)
		end

		v6.invalidateUser(v7)

		local v8, v9 = v6.getUserMoments(v7, nil):await()

		if not v8 then
			continue
		end

		local moments = v9.moments
		local v10

		if moments == nil then
			local moment = nil
			v10 = moment
		else
			for k, moment in moments do
				if moment.assetId == p2 then
					v10 = moment
					break
				end
			end
		end

		if v10 ~= nil then
			return v10
		end
	end

	return nil
end

return refreshOwnMomentsAfterPublish
