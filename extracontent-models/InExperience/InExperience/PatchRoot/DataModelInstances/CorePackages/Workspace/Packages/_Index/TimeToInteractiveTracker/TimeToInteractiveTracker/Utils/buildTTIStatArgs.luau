local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

require(TimeToInteractiveTracker.Stores.types)

local mergeTTIEventMetadata = require(TimeToInteractiveTracker.Utils.mergeTTIEventMetadata)
local getMemoryMb = require(TimeToInteractiveTracker.Utils.getMemoryMb)
local FFlagTTITrackerMemoryTracking = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerMemoryTracking)

local function buildTTIStatArgs(data, endTime: number)
	local deltaMs = (endTime - data.startTime) * 1000
	local v

	if FFlagTTITrackerMemoryTracking then
		v = getMemoryMb()
	end

	local ttiStatArgs = {
		statName = data.statName,
		deltaMs = deltaMs,
		metaData = mergeTTIEventMetadata(data.metaData, {
			startTime = data.startTime,
			endTime = endTime,
			deltaMs = deltaMs
		}),
		samplingRateOverride = data.samplingRateOverride,
		milestones = data.milestones,
		totalMemoryMB = 0,
		luaHeapMB = 0
	}
	local totalMemoryMB

	if v then
		totalMemoryMB = v.totalMemoryMB
	end

	ttiStatArgs.totalMemoryMB = totalMemoryMB
	local luaHeapMB

	if v then
		luaHeapMB = v.luaHeapMB
	end

	ttiStatArgs.luaHeapMB = luaHeapMB
	return ttiStatArgs
end

return buildTTIStatArgs
