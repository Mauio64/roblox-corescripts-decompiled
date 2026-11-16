local HttpService = game:GetService("HttpService")

local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

require(TimeToInteractiveTracker.Stores.types)

require(TimeToInteractiveTracker.Milestones.types)

local FFlagTTITrackerMemoryTracking = require(script.Parent.FFlagTTITrackerMemoryTracking)

local constants = require(TimeToInteractiveTracker.Milestones.constants)

local set = {}
local set2 = {}

for _, constant in constants do
	if type(constant) == "string" then
		set[constant] = true
	else
		set[constant.Name] = true

		for _, v in constant.Subphase do
			set2[v] = true
		end
	end
end

local function sanitizeIdSegment(id: string) -- 1 equivalent call inferred from this helper
	return id:gsub("[^%w_%-]", "_"):sub(1, 40)
end

local Util = {}

function Util.findLastMilestoneIndex(list, p)
	for i = #list, 1, -1 do
		if list[i].name == p then
			return i
		end
	end

	return nil
end

function Util.deepCloneMilestones(p)
	local clone = table.clone(p)

	for k, v in clone do
		local clone2 = table.clone(v)

		if clone2.subphases then
			local clone3 = table.clone(clone2.subphases)

			for k2, v2 in clone3 do
				clone3[k2] = table.clone(v2)
			end

			clone2.subphases = clone3
		end

		if clone2.requests then
			local clone3 = table.clone(clone2.requests)

			for k2, v2 in clone3 do
				clone3[k2] = table.clone(v2)
			end

			clone2.requests = clone3
		end

		clone[k] = clone2
	end

	return clone
end

function Util.encodeMilestonesJSON(p)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)
	return if success then result else nil
end

function Util.milestonesToProto(items)
	local result = {}

	for _, item in items do
		local v = {
			name = item.name,
			timestamp_seconds = item.timestamp,
			delta_ms = item.deltaMs,
			total_memory_mb = item.totalMemoryMB,
			lua_heap_mb = item.luaHeapMB
		}

		if item.id then
			v.id = item.id
		end

		if item.subphases then
			local subphases = {}

			for _, subphas in item.subphases do
				table.insert(subphases, {
					name = subphas.name,
					timestamp_seconds = subphas.timestamp,
					delta_ms = subphas.deltaMs or 0
				})
			end

			v.subphases = subphases
		end

		if item.requests then
			local requests = {}

			for _, request in item.requests do
				table.insert(requests, {
					name = request.name,
					timestamp_seconds = request.timestamp,
					delta_ms = request.deltaMs or 0
				})
			end

			v.requests = requests
		end

		table.insert(result, v)
	end

	return result
end

function Util.generateMilestoneStats(p: string, items)
	local milestoneStats = {}

	for _, item in items do
		local v

		if item.id then
			v = item.name .. "__" .. item.id
		else
			v = item.name
		end

		local eventName = p .. "_" .. v

		local v2 = { eventName = eventName, deltaMs = item.deltaMs }

		if FFlagTTITrackerMemoryTracking then
			v2.totalMemoryMB = item.totalMemoryMB
			v2.luaHeapMB = item.luaHeapMB
		end

		table.insert(milestoneStats, v2)

		if item.subphases then
			for _, subphas in item.subphases do
				table.insert(milestoneStats, {
					eventName = eventName .. "_sp_" .. subphas.name,
					deltaMs = subphas.deltaMs or 0
				})
			end
		end

		if not item.requests then
			continue
		end

		for _, request in item.requests do
			table.insert(milestoneStats, {
				eventName = eventName .. "_rq_" .. request.name,
				deltaMs = request.deltaMs or 0
			})
		end
	end

	return milestoneStats
end

function Util.milestonesToPointsFields(items)
	local result = {}

	for _, item in items do
		if not set[item.name] then
			continue
		end

		local v = (item.id == nil or item.id == "") and "" or "__" .. sanitizeIdSegment(item.id) -- inferred equivalent call
		local v2 = "ms_" .. item.name .. v
		result[v2] = item.deltaMs

		if FFlagTTITrackerMemoryTracking then
			if item.totalMemoryMB then
				result[v2 .. "_total_memory_mb"] = item.totalMemoryMB
			end

			if item.luaHeapMB then
				result[v2 .. "_lua_heap_mb"] = item.luaHeapMB
			end
		end

		if not item.subphases then
			continue
		end

		for _, subphas in item.subphases do
			if set2[subphas.name] then
				result[v2 .. "_sp_" .. subphas.name] = subphas.deltaMs or 0
			end
		end
	end

	return result
end

return Util
