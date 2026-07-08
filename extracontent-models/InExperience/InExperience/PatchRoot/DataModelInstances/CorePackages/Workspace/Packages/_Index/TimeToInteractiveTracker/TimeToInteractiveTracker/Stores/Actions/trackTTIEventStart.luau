local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local FFlagAXTTIEnableColdWarmDetection = require(TimeToInteractiveTrackerParent.SharedFlags).FFlagAXTTIEnableColdWarmDetection

require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)
local FFlagTTITrackerMemoryTracking = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerMemoryTracking)

return function(p1) -- line: 18
	-- upvalues: FFlagTTITrackerMemoryTracking (copy), now (copy), FFlagAXTTIEnableColdWarmDetection (copy)
	local t1 = {}

	return function(s1: string, p2) -- line: 24
		-- upvalues: FFlagTTITrackerMemoryTracking (copy), p1 (copy), now (copy), FFlagAXTTIEnableColdWarmDetection (copy), t1 (copy)
		local u10 = nil
		local u12

		if FFlagTTITrackerMemoryTracking then
			local v11 = if type(p2) ~= "boolean" then p2 else {
				autoDetectColdVsWarm = p2
			}

			u12 = if not v11 then nil else v11.autoDetectColdVsWarm
			u10 = if not v11 then nil else v11.trackMemory
		else
			u12 = if type(p2) ~= "boolean" then nil else p2
		end

		p1(function(p3) -- line: 39
			-- upvalues: s1 (copy), now (copy), u10 (ref), FFlagAXTTIEnableColdWarmDetection (copy), u12 (ref), t1 (copy)
			local v14 = p3[s1]
			local v15 = now()
			local v16 = table.clone(p3)

			v16[s1] = {
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				startTime = v15,
				trackMemory = u10,
				metadata = if v14 == nil then {} else table.clone(v14.metadata)
			}

			if FFlagAXTTIEnableColdWarmDetection and u12 then
				v16[s1].metadata.coldStart = not t1[s1]
				t1[s1] = true
			end

			return v16
		end)
	end
end
