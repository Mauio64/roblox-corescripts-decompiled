local updateFetchingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Actions").UpdateFetchingStatus
local batchUpdateFetchingStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Http/Actions").BatchUpdateFetchingStatus
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Http/Cryo")

local function mapStatusToValue(fetchingStatuses)
	local result = {}

	for k, item in pairs(fetchingStatuses) do
		local key = item.key
		local v5 = item.status

		if v5 == nil then
			v5 = Cryo.None
		end

		result[key] = v5
	end

	return result
end

return function(options, data)
	local joined = options or {}

	if data.type == updateFetchingStatus.name then
		local key = data.key
		local v5 = data.status

		if v5 == nil then
			v5 = Cryo.None
		end

		joined = Cryo.Dictionary.join(joined, { [key] = v5 })
	end

	if data.type == batchUpdateFetchingStatus.name then
		local fetchingStatuses = data.fetchingStatuses
		joined = Cryo.Dictionary.join(joined, mapStatusToValue(fetchingStatuses))
	end

	return joined
end
