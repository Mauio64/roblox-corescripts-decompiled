local HttpService = game:GetService("HttpService")
local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

require(TimeToInteractiveTracker.Stores.types)
require(TimeToInteractiveTracker.Milestones.types)

local FFlagTTITrackerMemoryTracking = require(script.Parent.FFlagTTITrackerMemoryTracking)

return {
	findLastMilestoneIndex = function(t1: {[any]: any}, p1) -- line: 33
		for i = #t1, 1, -1 do
			if p1 == t1[i].name then
				return i
			end
		end

		return nil
	end,
	deepCloneMilestones = function(t2: {[any]: any}) -- line: 42
		local v8 = table.clone(t2)

		for v9, v10 in v8 do
			local v11 = table.clone(v10)

			if v11.subphases then
				local v12 = table.clone(v11.subphases)

				for v13, v14 in v12 do
					v12[v13] = table.clone(v14)
				end

				v11.subphases = v12
			end

			if v11.requests then
				local v15 = table.clone(v11.requests)

				for v16, v17 in v15 do
					v15[v16] = table.clone(v17)
				end

				v11.requests = v15
			end

			v8[v9] = v11
		end

		return v8
	end,
	encodeMilestonesJSON = function(t3: {[any]: any}) -- line: 65
		-- upvalues: HttpService (copy)
		local ok, result = pcall(function() -- line: 66
			-- upvalues: HttpService (copy), t3 (copy)
			return HttpService:JSONEncode(t3)
		end)

		if ok then
			return result
		end

		return nil
	end,
	milestonesToProto = function(t4: {[any]: any}) -- line: 81
		local t5 = {}

		for _, v24 in t4 do
			local t6 = {
				name = v24.name,
				timestamp_seconds = v24.timestamp,
				delta_ms = v24.deltaMs,
				total_memory_mb = v24.totalMemoryMB,
				lua_heap_mb = v24.luaHeapMB
			}

			if v24.id then
				t6.id = v24.id
			end

			if v24.subphases then
				local t7 = {}

				for _, v28 in v24.subphases do
					table.insert(t7, {
						name = v28.name,
						timestamp_seconds = v28.timestamp,
						delta_ms = v28.deltaMs or 0
					})
				end

				t6.subphases = t7
			end

			if v24.requests then
				local t8 = {}

				for _, v31 in v24.requests do
					table.insert(t8, {
						name = v31.name,
						timestamp_seconds = v31.timestamp,
						delta_ms = v31.deltaMs or 0
					})
				end

				t6.requests = t8
			end

			table.insert(t5, t6)
		end

		return t5
	end,
	generateMilestoneStats = function(s1: string, t9: {[any]: any}) -- line: 150
		-- upvalues: FFlagTTITrackerMemoryTracking (copy)
		local t10 = {}

		for _, v36 in t9 do
			local v37 = s1 .. "_" .. if not v36.id then v36.name else v36.name .. "__" .. v36.id
			local t11 = {
				eventName = v37,
				deltaMs = v36.deltaMs
			}

			if FFlagTTITrackerMemoryTracking then
				t11.totalMemoryMB = v36.totalMemoryMB
				t11.luaHeapMB = v36.luaHeapMB
			end

			table.insert(t10, t11)

			if v36.subphases then
				for _, v40 in v36.subphases do
					table.insert(t10, {
						eventName = v37 .. "_sp_" .. v40.name,
						deltaMs = v40.deltaMs or 0
					})
				end
			end

			if v36.requests then
				for _, v42 in v36.requests do
					table.insert(t10, {
						eventName = v37 .. "_rq_" .. v42.name,
						deltaMs = v42.deltaMs or 0
					})
				end
			end
		end

		return t10
	end
}
