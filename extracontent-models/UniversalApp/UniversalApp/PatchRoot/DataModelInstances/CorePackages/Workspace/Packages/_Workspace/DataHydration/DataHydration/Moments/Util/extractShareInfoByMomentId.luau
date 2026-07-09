local DataHydration = script:FindFirstAncestor("DataHydration")

require(DataHydration.Moments.MomentsStoreTypes)

local function extractShareInfo(p1) -- line: 13
	local stats = p1.stats

	if stats == nil or type(stats.shareCount) ~= "number" then
		return nil
	end

	return {
		hasShared = false,
		shareCount = math.max(stats.shareCount, 0)
	}
end
local function extractShareInfoByMomentId(t1: {[any]: any}?) -- line: 25
	local t2 = {}

	if t1 == nil then
		return t2
	end

	for _, v9 in t1 do
		local v10 = v9.entityId or v9.id

		if v10 ~= nil then
			local stats = v9.stats
			local v12 = if stats ~= nil and type(stats.shareCount) == "number" then {
				hasShared = false,
				shareCount = math.max(stats.shareCount, 0)
			} else nil

			if v12 ~= nil then
				t2[v10] = v12
			end
		end
	end

	return t2
end

return extractShareInfoByMomentId
