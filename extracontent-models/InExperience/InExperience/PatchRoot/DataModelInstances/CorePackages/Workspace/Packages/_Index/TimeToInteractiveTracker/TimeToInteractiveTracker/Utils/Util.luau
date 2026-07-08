local HttpService = game:GetService("HttpService")
local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

require(TimeToInteractiveTracker.Stores.types)
require(TimeToInteractiveTracker.Milestones.types)

return {
	findLastMilestoneIndex = function(t1: {[any]: any}, p1) -- line: 31
		for i = #t1, 1, -1 do
			if p1 == t1[i].name then
				return i
			end
		end

		return nil
	end,
	deepCloneMilestones = function(t2: {[any]: any}) -- line: 40
		local v7 = table.clone(t2)

		for v8, v9 in v7 do
			local v10 = table.clone(v9)

			if v10.subphases then
				local v11 = table.clone(v10.subphases)

				for v12, v13 in v11 do
					v11[v12] = table.clone(v13)
				end

				v10.subphases = v11
			end

			if v10.requests then
				local v14 = table.clone(v10.requests)

				for v15, v16 in v14 do
					v14[v15] = table.clone(v16)
				end

				v10.requests = v14
			end

			v7[v8] = v10
		end

		return v7
	end,
	encodeMilestonesJSON = function(t3: {[any]: any}) -- line: 63
		-- upvalues: HttpService (copy)
		local ok, result = pcall(function() -- line: 64
			-- upvalues: HttpService (copy), t3 (copy)
			return HttpService:JSONEncode(t3)
		end)

		if ok then
			return result
		end

		return nil
	end,
	milestonesToProto = function(t4: {[any]: any}) -- line: 79
		local t5 = {}

		for _, v23 in t4 do
			local t6 = {
				name = v23.name,
				timestamp_seconds = v23.timestamp,
				delta_ms = v23.deltaMs,
				total_memory_mb = v23.totalMemoryMB,
				lua_heap_mb = v23.luaHeapMB
			}

			if v23.id then
				t6.id = v23.id
			end

			if v23.subphases then
				local t7 = {}

				for _, v27 in v23.subphases do
					table.insert(t7, {
						name = v27.name,
						timestamp_seconds = v27.timestamp,
						delta_ms = v27.deltaMs or 0
					})
				end

				t6.subphases = t7
			end

			if v23.requests then
				local t8 = {}

				for _, v30 in v23.requests do
					table.insert(t8, {
						name = v30.name,
						timestamp_seconds = v30.timestamp,
						delta_ms = v30.deltaMs or 0
					})
				end

				t6.requests = t8
			end

			table.insert(t5, t6)
		end

		return t5
	end,
	generateMilestoneStats = function(s1: string, t9: {[any]: any}) -- line: 145
		local t10 = {}

		for _, v35 in t9 do
			local v36 = s1 .. "_" .. if not v35.id then v35.name else v35.name .. "__" .. v35.id

			table.insert(t10, {
				eventName = v36,
				deltaMs = v35.deltaMs
			})

			if v35.subphases then
				for _, v38 in v35.subphases do
					table.insert(t10, {
						eventName = v36 .. "_sp_" .. v38.name,
						deltaMs = v38.deltaMs or 0
					})
				end
			end

			if v35.requests then
				for _, v40 in v35.requests do
					table.insert(t10, {
						eventName = v36 .. "_rq_" .. v40.name,
						deltaMs = v40.deltaMs or 0
					})
				end
			end
		end

		return t10
	end
}
