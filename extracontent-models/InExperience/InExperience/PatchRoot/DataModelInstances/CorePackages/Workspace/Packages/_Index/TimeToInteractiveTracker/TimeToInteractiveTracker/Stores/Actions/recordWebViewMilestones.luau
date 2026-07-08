local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local v2 = require(TimeToInteractiveTracker.Logger):new(script.Name)
local FFlagDebugTimeToInteractiveTracker = require(TimeToInteractiveTracker.Utils.FFlagDebugTimeToInteractiveTracker)

require(script.Parent.Parent.types)
require(TimeToInteractiveTracker.Milestones.types)

local constants = require(TimeToInteractiveTracker.Milestones.constants)

return function(p1, p2) -- line: 35
	-- upvalues: FFlagDebugTimeToInteractiveTracker (copy), v2 (copy), constants (copy)
	return function(s1: string, t1: {[any]: any}) -- line: 36
		-- upvalues: p1 (copy), FFlagDebugTimeToInteractiveTracker (copy), v2 (copy), constants (copy), p2 (copy)
		if #t1 == 0 then
			return
		end

		local v9 = p1(false)[s1]

		if FFlagDebugTimeToInteractiveTracker and (not v9 or not v9.startTime) then
			v2:warning(`called before trackStart for eventName={ s1 }`)
		end

		if not v9 or not v9.startTime then
			return
		end

		local startTime = v9.startTime
		local Subphase = constants.DataProcessingCompleted.Subphase

		local function materializeSubphases(t2: {[any]: any}?) -- line: 63
			-- upvalues: startTime (copy), Subphase (copy)
			if t2 == nil then
				return nil
			end

			local t3 = {}

			for _, v19 in t2 do
				local v20 = startTime + v19.deltaMs / 1000

				table.insert(t3, if v19.name ~= Subphase.Decode and (v19.name ~= Subphase.DataUpdate and v19.name ~= Subphase.TreeBuild) then {
					name = v19.name,
					timestamp = v20,
					deltaMs = v19.deltaMs
				} else {
					name = v19.name,
					timestamp = v20,
					deltaMs = v19.deltaMs
				})
			end

			return t3
		end

		local t4 = {}

		for _, v15 in t1 do
			table.insert(t4, {
				name = v15.name,
				id = v15.id,
				timestamp = startTime + v15.deltaMs / 1000,
				deltaMs = v15.deltaMs,
				subphases = materializeSubphases(v15.subphases)
			})
		end

		p2(function(p3) -- line: 110
			-- upvalues: s1 (copy), t4 (copy)
			local v22 = p3[s1]

			if not v22 then
				return p3
			end

			local v23 = table.clone(p3)
			local v24 = table.clone(v22)
			local v25 = if not v24.milestones then {} else table.clone(v24.milestones)

			for _, v27 in t4 do
				table.insert(v25, v27)
			end

			v24.milestones = v25
			v23[s1] = v24

			return v23
		end)
	end
end
