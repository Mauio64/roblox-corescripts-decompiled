local Http = script:FindFirstAncestor("Http")
local parent = Http.Parent

local Actions = require(Http.Actions)
local UpdateFetchingStatus = Actions.UpdateFetchingStatus
local Actions2 = require(Http.Actions)
local BatchUpdateFetchingStatus = Actions2.BatchUpdateFetchingStatus
local Cryo = require(parent.Cryo)

local function mapStatusToValue(fetchingStatuses)
	local result = {}

	for _, item in pairs(fetchingStatuses) do
		local key = item.key
		local v = item.status

		if v == nil then
			v = Cryo.None
		end

		result[key] = v
	end

	return result
end

return function(options, data)
	local joined = options or {}

	if data.type == UpdateFetchingStatus.name then
		local key = data.key
		local v = data.status

		if v == nil then
			v = Cryo.None
		end

		joined = Cryo.Dictionary.join(joined, { [key] = v })
	end

	if data.type == BatchUpdateFetchingStatus.name then
		local fetchingStatuses = data.fetchingStatuses
		joined = Cryo.Dictionary.join(joined, mapStatusToValue(fetchingStatuses))
	end

	return joined
end
