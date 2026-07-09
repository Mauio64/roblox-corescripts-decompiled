local Http = script:FindFirstAncestor("Http")
local HttpParent = Http.Parent
local UpdateFetchingStatus = require(Http.Actions).UpdateFetchingStatus
local BatchUpdateFetchingStatus = require(Http.Actions).BatchUpdateFetchingStatus
local Cryo = require(HttpParent.Cryo)

local function mapStatusToValue(p1) -- line: 8
	-- upvalues: Cryo (copy)
	local t1 = {}

	for _, v in pairs(p1) do
		local key = v.key
		local status = v.status

		t1[key] = if status == nil then Cryo.None else status
	end

	return t1
end

return function(p2, p3) -- line: 27
	-- upvalues: UpdateFetchingStatus (copy), Cryo (copy), BatchUpdateFetchingStatus (copy), mapStatusToValue (copy)
	local v15 = p2 or {}

	if p3.type == UpdateFetchingStatus.name then
		local key = p3.key
		local status = p3.status
		local v18 = if status == nil then Cryo.None else status

		v15 = Cryo.Dictionary.join(v15, {
			[key] = v18
		})
	end

	if p3.type == BatchUpdateFetchingStatus.name then
		local fetchingStatuses = p3.fetchingStatuses

		v15 = Cryo.Dictionary.join(v15, (mapStatusToValue(fetchingStatuses)))
	end

	return v15
end
