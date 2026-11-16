local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

local Logger = require(TimeToInteractiveTracker.Logger)
local v = Logger:new(script.Name)
local FFlagDebugTimeToInteractiveTracker = require(TimeToInteractiveTracker.Utils.FFlagDebugTimeToInteractiveTracker)

local FFlagTimeToInteractiveTrackerWarningsRequireDebug = require(TimeToInteractiveTracker.Utils.FFlagTimeToInteractiveTrackerWarningsRequireDebug)

require(script.Parent.Parent.types)

local now = require(TimeToInteractiveTracker.Utils.now)
local getMemoryMb = require(TimeToInteractiveTracker.Utils.getMemoryMb)
local FFlagTTITrackerMemoryTracking = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerMemoryTracking)

return function(callback, callback2)
	return function(p: string, name, p2)
		local timestamp = now()
		local v2 = callback(false)[p]

		if v2 and v2.startTime then
			local deltaMs = (timestamp - v2.startTime) * 1000
			local v3

			if FFlagTTITrackerMemoryTracking then
				v3 = getMemoryMb()
			end

			local v4 = {
				name = name,
				id = 0,
				timestamp = 0,
				deltaMs = 0,
				totalMemoryMB = 0,
				luaHeapMB = 0
			}
			local id

			if p2 then
				id = p2.id
			end

			v4.id = id
			v4.timestamp = timestamp
			v4.deltaMs = deltaMs
			local totalMemoryMB

			if v3 then
				totalMemoryMB = v3.totalMemoryMB
			end

			v4.totalMemoryMB = totalMemoryMB
			local luaHeapMB

			if v3 then
				luaHeapMB = v3.luaHeapMB
			end

			v4.luaHeapMB = luaHeapMB

			callback2(function(p3)
				local v5 = p3[p]

				if not v5 then
					return p3
				end

				local clone = table.clone(p3)
				local clone2 = table.clone(v5)
				local milestones = not clone2.milestones and {} or table.clone(clone2.milestones)
				table.insert(milestones, v4)
				clone2.milestones = milestones

				clone[p] = clone2
				return clone
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
