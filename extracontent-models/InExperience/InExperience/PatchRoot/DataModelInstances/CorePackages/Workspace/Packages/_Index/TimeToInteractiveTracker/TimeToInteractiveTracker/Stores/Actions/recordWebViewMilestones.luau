local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

local Logger = require(TimeToInteractiveTracker.Logger)
local v = Logger:new(script.Name)
local FFlagDebugTimeToInteractiveTracker = require(TimeToInteractiveTracker.Utils.FFlagDebugTimeToInteractiveTracker)

require(script.Parent.Parent.types)
require(TimeToInteractiveTracker.Milestones.types)
local constants = require(TimeToInteractiveTracker.Milestones.constants)

return function(callback, callback2)
	return function(p: string, list)
		if #list == 0 then
			return
		end

		local v2 = callback(false)[p]

		if FFlagDebugTimeToInteractiveTracker and not (v2 and v2.startTime) then
			v:warning(`called before trackStart for eventName={p}`)
		end

		if not (v2 and v2.startTime) then
			return
		end

		local startTime = v2.startTime
		local subphase = constants.DataProcessingCompleted.Subphase

		local function materializeSubphases(subphases)
			if subphases == nil then
				return nil
			end

			local result = {}

			for _, item in subphases do
				local timestamp = startTime + item.deltaMs / 1000

				if
					item.name == subphase.Decode
					or item.name == subphase.DataUpdate
					or item.name == subphase.TreeBuild
				then
				end

				local v3 = { name = item.name, timestamp = timestamp, deltaMs = item.deltaMs }

				table.insert(result, v3)
			end

			return result
		end

		local v3 = {}

		for _, item in list do
			table.insert(v3, {
				name = item.name,
				id = item.id,
				timestamp = startTime + item.deltaMs / 1000,
				deltaMs = item.deltaMs,
				subphases = materializeSubphases(item.subphases)
			})
		end

		callback2(function(p2)
			local v4 = p2[p]

			if not v4 then
				return p2
			end

			local clone = table.clone(p2)
			local clone2 = table.clone(v4)
			local milestones = not clone2.milestones and {} or table.clone(clone2.milestones)

			for _, v5 in v3 do
				table.insert(milestones, v5)
			end

			clone2.milestones = milestones
			clone[p] = clone2
			return clone
		end)
	end
end
