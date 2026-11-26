require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local mergeTTIEventMetadata = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/mergeTTIEventMetadata")
local getMemoryMb = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/getMemoryMb")
local FFlagTTITrackerMemoryTracking = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerMemoryTracking")

local function buildTTIStatArgs(data, p2)
	local v5 = (p2 - data.startTime) * 1000
	local v6 = if FFlagTTITrackerMemoryTracking then getMemoryMb() else nil
	local ttiStatArgs = {
		statName = data.statName,
		deltaMs = v5,
		metaData = mergeTTIEventMetadata(data.metaData, {
			startTime = data.startTime,
			endTime = p2,
			deltaMs = v5
		}),
		samplingRateOverride = data.samplingRateOverride,
		milestones = data.milestones,
		totalMemoryMB = 0,
		luaHeapMB = 0
	}
	local v7 = if v6 then v6.totalMemoryMB else nil
	ttiStatArgs.totalMemoryMB = v7
	local v8 = if v6 then v6.luaHeapMB else nil
	ttiStatArgs.luaHeapMB = v8
	return ttiStatArgs
end

return buildTTIStatArgs
