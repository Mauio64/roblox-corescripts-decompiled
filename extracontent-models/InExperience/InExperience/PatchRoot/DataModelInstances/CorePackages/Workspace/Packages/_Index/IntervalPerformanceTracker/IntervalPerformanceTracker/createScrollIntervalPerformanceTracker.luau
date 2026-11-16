local parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent

local ScrollIntervalTracker = require(parent.ScrollIntervalTracker)
local IntervalPerformanceTracker = require(script.Parent.IntervalPerformanceTracker)

local defineFastFlag = game:DefineFastFlag("IntervalPerformanceTrackerPerIntervalSampleRate", false)
game:DefineFastInt("ScrollIntervalPerformanceTrackerSampleRate", 1000)

local v = {
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

local function createScrollIntervalPerformanceTracker(p: string, p2, p3, data)
	local v2

	if data and data.metricsToTrack then
		v2 = data.metricsToTrack
	else
		v2 = v
	end

	local v3 = not data or data.countersEnabled == nil or data.countersEnabled
	local v4 = not data or data.eventStreamEnabled == nil or data.eventStreamEnabled
	local scrollOptions

	if data then
		scrollOptions = data.scrollOptions
	end

	local v5 = not data or data.trackScrollType == nil or data.trackScrollType
	local extraFields

	if data then
		extraFields = data.extraFields
	else
		extraFields = nil
	end

	local v6 = false

	local function buildExtraFields() -- 1 equivalent call inferred from this helper
		local scroll_type = v6 and "warm" or "cold"

		if not v5 then
			return extraFields
		end

		local extraFields2 = {}

		if extraFields then
			for k, extraField in extraFields do
				extraFields2[k] = extraField
			end
		end

		extraFields2.scroll_type = scroll_type
		return extraFields2
	end

	local function tryStart(_): boolean
		local extraFields2 = buildExtraFields() -- inferred equivalent call
		local v7

		if defineFastFlag then
			v7 = game:GetFastInt("ScrollIntervalPerformanceTrackerSampleRate")
		end

		IntervalPerformanceTracker:startTracking(p, nil, v2, v3, v4, extraFields2, p2, v7)

		v6 = true
		return true
	end

	local function finish(_)
		IntervalPerformanceTracker:stopAndLogTracking(p)
	end

	return ScrollIntervalTracker.createScrollIntervalTracker(tryStart, finish, p2, p3, scrollOptions)
end

return createScrollIntervalPerformanceTracker
