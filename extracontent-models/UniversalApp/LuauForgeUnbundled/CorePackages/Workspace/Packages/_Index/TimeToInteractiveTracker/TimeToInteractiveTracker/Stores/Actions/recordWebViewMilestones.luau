local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Logger"):new("recordWebViewMilestones")
local FFlagDebugTimeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagDebugTimeToInteractiveTracker")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")
require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/types")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/constants")

return function(callback, callback2)
	return function(p2, list)
		if #list == 0 then
			return
		end

		local v6 = callback(false)[p2]

		if FFlagDebugTimeToInteractiveTracker and not (v6 and v6.startTime) then
			v5:warning(`called before trackStart for eventName={p2}`)
		end

		if not (v6 and v6.startTime) then
			return
		end

		local startTime = v6.startTime
		local subphase = constants.DataProcessingCompleted.Subphase

		local function materializeSubphases(subphases)
			if subphases == nil then
				return nil
			end

			local result = {}

			for k, item in subphases do
				local v7 = startTime + item.deltaMs / 1000

				if
					item.name == subphase.Decode
					or item.name == subphase.DataUpdate
					or item.name == subphase.TreeBuild
				then
				end

				local v8 = { name = item.name, timestamp = v7, deltaMs = item.deltaMs }

				table.insert(result, v8)
			end

			return result
		end

		local v7 = {}

		for k, item in list do
			table.insert(v7, {
				name = item.name,
				id = item.id,
				timestamp = startTime + item.deltaMs / 1000,
				deltaMs = item.deltaMs,
				subphases = materializeSubphases(item.subphases)
			})
		end

		callback2(function(p3)
			local v8 = p3[p2]

			if not v8 then
				return p3
			end

			local clone = table.clone(p3)
			local clone2 = table.clone(v8)
			local v9 = not clone2.milestones and {} or table.clone(clone2.milestones)

			for k, v10 in v7 do
				table.insert(v9, v10)
			end

			clone2.milestones = v9
			clone[p2] = clone2
			return clone
		end)
	end
end
