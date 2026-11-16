local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Logger"):new("trackTTIEventEnd")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")
local sendTTIStat = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/sendTTIStat")
local mergeTTIEventMetadata = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/mergeTTIEventMetadata")
local Util = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/Util")
local getMemoryMb = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/getMemoryMb")
local FFlagTTITrackerMemoryTracking = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerMemoryTracking")

return function(callback)
	return function(p2, p3)
		local v6 = nil
		local v7 = nil
		local milestones = nil
		local v8 = false
		local v9 = not p3 or p3.cleanupAfterSend == nil or p3.cleanupAfterSend

		local samplingRateOverride = if p3 then p3.samplingRateOverride else nil

		callback(function(p4)
			local v10 = p4[p2]

			if v10 == nil then
				v5:warning(`called before trackStart for eventName={p2}`)
				return p4
			end

			if v10.startTime == nil then
				v5:warning(`called before trackStart for eventName={p2}`)
				return p4
			end

			local v11 = now()

			v6 = (v11 - v10.startTime) * 1000
			v8 = v10.sent ~= true

			if v8 then
				local startTime = v10.startTime
				local v12 = v6
				v7 = mergeTTIEventMetadata(v10.metadata, {
					startTime = startTime,
					endTime = v11,
					deltaMs = v12
				})

				if v10.milestones then
					milestones = v10.milestones
				end
			end

			local clone = table.clone(p4)

			if v8 and v9 then
				clone[p2] = nil
				return clone
			end

			local v13 = {
				startTime = v10.startTime,
				endTime = v11,
				deltaMs = v6,
				sent = true,
				metadata = table.clone(v10.metadata),
				milestones = 0
			}
			local v14 = if v10.milestones then Util.deepCloneMilestones(v10.milestones) else nil
			v13.milestones = v14
			clone[p2] = v13

			return clone
		end)

		if v8 and v6 ~= nil and v7 ~= nil then
			local v10 = if FFlagTTITrackerMemoryTracking then getMemoryMb() else nil
			local v12 = {
				statName = p2,
				deltaMs = v6,
				metaData = v7,
				samplingRateOverride = samplingRateOverride,
				milestones = milestones,
				totalMemoryMB = 0,
				luaHeapMB = 0
			}

			local v13 = if v10 then v10.totalMemoryMB else nil
			v12.totalMemoryMB = v13
			local v14 = if v10 then v10.luaHeapMB else nil
			v12.luaHeapMB = v14
			sendTTIStat(v12)
		end
	end
end
