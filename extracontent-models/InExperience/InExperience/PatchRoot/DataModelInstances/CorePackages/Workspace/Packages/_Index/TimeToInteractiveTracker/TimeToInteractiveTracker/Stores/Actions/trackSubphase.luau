local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

local Logger = require(TimeToInteractiveTracker.Logger)
local v = Logger:new(script.Name)
local FFlagDebugTimeToInteractiveTracker = require(TimeToInteractiveTracker.Utils.FFlagDebugTimeToInteractiveTracker)

local FFlagTimeToInteractiveTrackerWarningsRequireDebug = require(TimeToInteractiveTracker.Utils.FFlagTimeToInteractiveTrackerWarningsRequireDebug)

require(script.Parent.Parent.types)

local now = require(TimeToInteractiveTracker.Utils.now)
local Util = require(TimeToInteractiveTracker.Utils.Util)

return function(callback, callback2)
	return function(p: string, p2, name)
		local timestamp = now()
		local v2 = callback(false)[p]

		if v2 and v2.startTime then
			local v3 = {
				name = name,
				timestamp = timestamp,
				deltaMs = (timestamp - v2.startTime) * 1000
			}

			callback2(function(p3)
				local v4 = p3[p]

				if not (v4 and v4.milestones) then
					return p3
				end

				local lastMilestoneIndex = Util.findLastMilestoneIndex(v4.milestones, p2)

				if lastMilestoneIndex then
					local clone = table.clone(p3)
					local clone2 = table.clone(v4)
					local clone3 = table.clone(v4.milestones)
					local clone4 = table.clone(clone3[lastMilestoneIndex])

					local subphases = not clone4.subphases and {} or table.clone(clone4.subphases)
					table.insert(subphases, v3)
					clone4.subphases = subphases

					clone3[lastMilestoneIndex] = clone4
					clone2.milestones = clone3
					clone[p] = clone2
					return clone
				end

				if FFlagTimeToInteractiveTrackerWarningsRequireDebug then
					if FFlagDebugTimeToInteractiveTracker then
						v:warning(`no milestone "{p2}" found for eventName={p}`)
						return p3
					end
				else
					v:warning(`no milestone "{p2}" found for eventName={p}`)
				end

				return p3
			end)
		elseif FFlagTimeToInteractiveTrackerWarningsRequireDebug then
			if FFlagDebugTimeToInteractiveTracker then
				v:warning(`called before trackStart for eventName={p}`)
			end
		else
			v:warning(`called before trackStart for eventName={p}`)
		end
	end
end
