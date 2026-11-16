local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.Moments.MomentsStoreTypes)

local function extractShareInfo(item) -- 1 equivalent call inferred from this helper
	local stats = item.stats

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

	for _, item in items do
		local entityId = item.entityId or item.id

		if entityId == nil then
			continue
		end

		local shareInfo = extractShareInfo(item) -- inferred equivalent call

		if shareInfo ~= nil then
			shareInfoByMomentId[entityId] = shareInfo
		end
	end

	return shareInfoByMomentId
end

return extractShareInfoByMomentId
