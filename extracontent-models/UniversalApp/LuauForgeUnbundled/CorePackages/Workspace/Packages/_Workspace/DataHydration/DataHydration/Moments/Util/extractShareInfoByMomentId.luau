require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local function extractShareInfo(p2)
	local stats = p2.stats

	if stats == nil or type(stats.shareCount) ~= "number" then
		return nil
	end

	return { shareCount = math.max(stats.shareCount, 0), hasShared = false }
end

local function extractShareInfoByMomentId(items)
	local shareInfoByMomentId = {}

	if items == nil then
		return shareInfoByMomentId
	end

	for k, item in items do
		local entityId = item.entityId or item.id

		if entityId == nil then
			continue
		end

		local stats = item.stats
		local v5 = stats ~= nil
			and type(stats.shareCount) == "number"
			and { shareCount = math.max(stats.shareCount, 0), hasShared = false }
			or nil

		if v5 ~= nil then
			shareInfoByMomentId[entityId] = v5
		end
	end

	return shareInfoByMomentId
end

return extractShareInfoByMomentId
