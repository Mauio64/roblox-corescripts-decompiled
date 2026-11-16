local parent = script:FindFirstAncestor("Moments").Parent

local Players = game:GetService("Players")

require(parent.DataHydration.MomentsStoreTypes)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)

local function findByAssetId(items, p: number)
	if items == nil then
		return nil
	end

	for _, item in items do
		if item.assetId == p then
			return item
		end
	end

	return nil
end

local function refreshOwnMomentsAfterPublish(p: number, options)
	local v = options or {}
	local v2

	if v.userStore == nil then
		v2 = MomentsGetMomentsUserStore(false)
	else
		v2 = v.userStore
	end

	local wait = v.wait or function(duration: number)
		task.wait(duration)
	end
	local v3

	if v.getLocalUserId == nil then
		local localPlayer = Players.LocalPlayer

		if localPlayer ~= nil then
			v3 = localPlayer.UserId
		end
	else
		v3 = v.getLocalUserId()
	end

	if v3 == nil then
		return nil
	end

	for i = 1, 6 do
		if i > 1 then
			wait(2)
		end

		v2.invalidateUser(v3)

		local v4, v5 = v2.getUserMoments(v3, nil):await()

		if not v4 then
			continue
		end

		local moments = v5.moments
		local v6

		if moments == nil then
			local moment = nil
			v6 = moment
		else
			for _, moment in moments do
				if moment.assetId == p then
					v6 = moment
					break
				end
			end
		end

		if v6 ~= nil then
			return v6
		end
	end

	return nil
end

return refreshOwnMomentsAfterPublish
