local ScrollIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/ScrollIntervalTracker")
local IntervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/IntervalPerformanceTracker")

local defineFastFlag = game:DefineFastFlag("IntervalPerformanceTrackerPerIntervalSampleRate", false)
game:DefineFastInt("ScrollIntervalPerformanceTrackerSampleRate", 1000)

local v5 = {
	"duration",
	"averageFPS",
	"framesCount",
	"longestFrameTime",
	"frameTimeAvgMs",
	"frameTimeStdDevMs",
	"frameTimeDistributionMs",
	"frameBuckets",
	"rawFrameTimesMs",
	"rawScrollPositionSamplesCsv"
}

local function createScrollIntervalPerformanceTracker(p2, p3, p4, data)
	local v6 = if data and data.metricsToTrack then data.metricsToTrack else v5
	local v7 = not data or data.countersEnabled == nil or data.countersEnabled
	local v8 = not data or data.eventStreamEnabled == nil or data.eventStreamEnabled

	local scrollOptions = if data then data.scrollOptions else nil
	local v9 = not data or data.trackScrollType == nil or data.trackScrollType
	local extraFields = if data then data.extraFields else nil

	local v10 = false

	local function buildExtraFields()
		local v11 = v10 and "warm" or "cold"

		if not v9 then
			return extraFields
		end

		local extraFields2 = {}

		if extraFields then
			for k, extraField in extraFields do
				extraFields2[k] = extraField
			end
		end

		extraFields2.scroll_type = v11
		return extraFields2
	end

	local function tryStart(p5): boolean
		local v17 = v10 and "warm" or "cold"
		local extraFields2

		if v9 then
			extraFields2 = {}

			if extraFields then
				for k, extraField in extraFields do
					extraFields2[k] = extraField
				end
			end

			extraFields2.scroll_type = v17
		else
			extraFields2 = extraFields
		end

		local v19 = if defineFastFlag then game:GetFastInt("ScrollIntervalPerformanceTrackerSampleRate") else nil
		IntervalPerformanceTracker:startTracking(p2, nil, v6, v7, v8, extraFields2, p3, v19)

		v10 = true
		return true
	end

	local function finish(p5)
		IntervalPerformanceTracker:stopAndLogTracking(p2)
	end

	return ScrollIntervalTracker.createScrollIntervalTracker(tryStart, finish, p3, p4, scrollOptions)
end

return createScrollIntervalPerformanceTracker
