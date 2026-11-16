local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/types")

local FFlagTTITrackerMemoryTracking = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerMemoryTracking")

local constants = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/constants")

local set = {}
local set2 = {}

for k, v5 in constants do
	if type(v5) == "string" then
		set[v5] = true
	else
		set[v5.Name] = true

		for k2, v6 in v5.Subphase do
			set2[v6] = true
		end
	end
end

local function sanitizeIdSegment(value)
	return value:gsub("[^%w_%-]", "_"):sub(1, 40)
end

return {
	findLastMilestoneIndex = function(list, p2)
		for i = #list, 1, -1 do
			if list[i].name == p2 then
				return i
			end
		end

		return nil
	end,
	deepCloneMilestones = function(p2)
		local clone = table.clone(p2)

		for k, v5 in clone do
			local clone2 = table.clone(v5)

			if clone2.subphases then
				local clone3 = table.clone(clone2.subphases)

				for k2, v6 in clone3 do
					clone3[k2] = table.clone(v6)
				end

				clone2.subphases = clone3
			end

			if clone2.requests then
				local clone3 = table.clone(clone2.requests)

				for k2, v6 in clone3 do
					clone3[k2] = table.clone(v6)
				end

				clone2.requests = clone3
			end

			clone[k] = clone2
		end

		return clone
	end,
	encodeMilestonesJSON = function(p2)
		local success, result = pcall(function()
			return HttpService:JSONEncode(p2)
		end)

		if success then
			return result
		end

		return nil
	end,
	milestonesToProto = function(items)
		local result = {}

		for k, item in items do
			local v5 = {
				name = item.name,
				timestamp_seconds = item.timestamp,
				delta_ms = item.deltaMs,
				total_memory_mb = item.totalMemoryMB,
				lua_heap_mb = item.luaHeapMB
			}

			if item.id then
				v5.id = item.id
			end

			if item.subphases then
				local v6 = {}

				for k2, subphas in item.subphases do
					table.insert(v6, {
						name = subphas.name,
						timestamp_seconds = subphas.timestamp,
						delta_ms = subphas.deltaMs or 0
					})
				end

				v5.subphases = v6
			end

			if item.requests then
				local v6 = {}

				for k2, request in item.requests do
					table.insert(v6, {
						name = request.name,
						timestamp_seconds = request.timestamp,
						delta_ms = request.deltaMs or 0
					})
				end

				v5.requests = v6
			end

			table.insert(result, v5)
		end

		return result
	end,
	generateMilestoneStats = function(p2, items)
		local milestoneStats = {}

		for k, item in items do
			local v5 = if item.id then item.name .. "__" .. item.id else item.name
			local v6 = p2 .. "_" .. v5

			local v7 = { eventName = v6, deltaMs = item.deltaMs }

			if FFlagTTITrackerMemoryTracking then
				v7.totalMemoryMB = item.totalMemoryMB
				v7.luaHeapMB = item.luaHeapMB
			end

			table.insert(milestoneStats, v7)

			if item.subphases then
				for k2, subphas in item.subphases do
					table.insert(milestoneStats, {
						eventName = v6 .. "_sp_" .. subphas.name,
						deltaMs = subphas.deltaMs or 0
					})
				end
			end

			if not item.requests then
				continue
			end

			for k2, request in item.requests do
				table.insert(milestoneStats, {
					eventName = v6 .. "_rq_" .. request.name,
					deltaMs = request.deltaMs or 0
				})
			end
		end

		return milestoneStats
	end,
	milestonesToPointsFields = function(items)
		local result = {}

		for k, item in items do
			if not set[item.name] then
				continue
			end

			local v5 = (item.id == nil or item.id == "") and ""
				or "__" .. item.id:gsub("[^%w_%-]", "_"):sub(1, 40)
			local v6 = "ms_" .. item.name .. v5
			result[v6] = item.deltaMs

			if FFlagTTITrackerMemoryTracking then
				if item.totalMemoryMB then
					result[v6 .. "_total_memory_mb"] = item.totalMemoryMB
				end

				if item.luaHeapMB then
					result[v6 .. "_lua_heap_mb"] = item.luaHeapMB
				end
			end

			if not item.subphases then
				continue
			end

			for k2, subphas in item.subphases do
				if set2[subphas.name] then
					result[v6 .. "_sp_" .. subphas.name] = subphas.deltaMs or 0
				end
			end
		end

		return result
	end
}
