local Parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent
local ScrollIntervalTracker = require(Parent.ScrollIntervalTracker)
local IntervalPerformanceTracker = require(script.Parent.IntervalPerformanceTracker)
local t1 = {
	"duration",
	"averageFPS",
	"framesCount",
	"longestFrameTime",
	"frameTimeAvgMs",
	"frameTimeStdDevMs",
	"frameTimeDistributionMs",
	"frameBuckets",
	"rawFrameTimesMs"
}

local function createScrollIntervalPerformanceTracker(s1: string, p1, p2, t2: {[any]: any}?) -- line: 69
	-- upvalues: t1 (copy), IntervalPerformanceTracker (copy), ScrollIntervalTracker (copy)
	local v10 = if not t2 or not t2.metricsToTrack then t1 else t2.metricsToTrack
	local v11 = not t2 or (t2.countersEnabled == nil or t2.countersEnabled)
	local v12 = not t2 or (t2.eventStreamEnabled == nil or t2.eventStreamEnabled)
	local v13 = if not t2 then nil else t2.scrollOptions
	local v14 = not t2 or (t2.trackScrollType == nil or t2.trackScrollType)
	local v15 = if not t2 then nil else t2.extraFields
	local u16 = false

	local function buildExtraFields() -- line: 88
		-- upvalues: u16 (ref), v14 (copy), v15 (copy)
		local v20 = not u16 and "cold" or "warm"

		if not v14 then
			return v15
		end

		local t3 = {}

		if v15 then
			for v22, v23 in v15 do
				t3[v22] = v23
			end
		end

		t3.scroll_type = v20

		return t3
	end
	local function tryStart(_) -- line: 105
		-- upvalues: IntervalPerformanceTracker (copy), s1 (copy), v10 (copy), v11 (copy), v12 (copy), u16 (ref), v14 (copy), v15 (copy)
		local v25 = IntervalPerformanceTracker
		local v26 = s1
		local v27 = v10
		local v28 = v11
		local v29 = v12
		local v30 = not u16 and "cold" or "warm"
		local v31

		if not v14 then
			v31 = v15
		else
			v31 = {}

			if v15 then
				for v32, v33 in v15 do
					v31[v32] = v33
				end
			end

			v31.scroll_type = v30
		end

		v25:startTracking(v26, nil, v27, v28, v29, v31)
		u16 = true

		return true
	end
	local function finish(_) -- line: 118
		-- upvalues: IntervalPerformanceTracker (copy), s1 (copy)
		IntervalPerformanceTracker:stopAndLogTracking(s1)
	end

	return ScrollIntervalTracker.createScrollIntervalTracker(tryStart, finish, p1, p2, v13)
end

return createScrollIntervalPerformanceTracker
