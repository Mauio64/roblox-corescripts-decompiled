local IntervalPerformanceTracker = script:FindFirstAncestor("IntervalPerformanceTracker")
local IntervalPerformanceTrackerParent = IntervalPerformanceTracker.Parent
local default = require(IntervalPerformanceTrackerParent.LoggingProtocol).default
local RunService = require(IntervalPerformanceTrackerParent.MockableProxyServices).RunService
local v5 = require(IntervalPerformanceTracker.Logger):new(script.Name)
local IntervalPerformanceTrackerTelemetryConfig = require(script.Parent.IntervalPerformanceTrackerTelemetryConfig)

game:DefineFastFlag("DebugPrintIntervalPerformanceTrackerResults", false)

local GetFFlagAXFPSEventStreamAndCounters = require(IntervalPerformanceTrackerParent.SharedFlags).GetFFlagAXFPSEventStreamAndCounters
local FFlagLuaAppPerfTrackerUseLogger = require(IntervalPerformanceTrackerParent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger
local sendFPSStat = require(script.Parent.sendFPSStat)
local v10 = game:DefineFastFlag("AXFixAverageFPSCasing", false)
local v11 = game:DefineFastFlag("AXIntervalPerformanceTrackerFPSStandardDeviation", false)
local v12 = game:DefineFastFlag("AXIntervalPerformanceTrackerScrollFrameTime", false)
local GetFIntIntervalPerformanceTrackerEventStream = require(IntervalPerformanceTrackerParent.SharedFlags).GetFIntIntervalPerformanceTrackerEventStream
local v14 = math.random(0, 1000) < GetFIntIntervalPerformanceTrackerEventStream()
local t6 = {
	averageFPS = {
		reducer = function(t1: {[any]: any}) -- line: 66
			return {
				framesCount = if t1.framesCount ~= nil then t1.framesCount + 1 else 0,
				startTime = t1.startTime or tick()
			}
		end,
		getResult = function(t2: {[any]: any}) -- line: 72
			local timestamp = tick()

			if t2.framesCount == nil or (t2.framesCount == 0 or t2.startTime == nil or timestamp == t2.startTime) then
				return nil
			end

			return t2.framesCount / (timestamp - t2.startTime)
		end
	},
	framesCount = {
		reducer = function(t3: {[any]: any}) -- line: 87
			return {
				framesCount = if t3.framesCount ~= nil then t3.framesCount + 1 else 0
			}
		end,
		getResult = function(p1) -- line: 92
			return p1.framesCount
		end
	},
	longestFrameTime = {
		reducer = function(t4: {[any]: any}) -- line: 97
			return {
				framesCount = if t4.framesCount ~= nil then t4.framesCount + 1 else 0,
				longestFrameTime = if t4.longestFrameTime ~= nil and t4.previousTime ~= nil then math.max(t4.longestFrameTime, tick() - t4.previousTime) else 0,
				previousTime = tick()
			}
		end,
		getResult = function(p2) -- line: 106
			if p2.framesCount < 1 then
				return nil
			end

			return p2.longestFrameTime
		end
	},
	duration = {
		reducer = function(t5: {[any]: any}) -- line: 114
			return {
				startTime = t5.startTime or tick()
			}
		end,
		getResult = function(p3) -- line: 119
			return tick() - p3.startTime
		end
	}
}

if v11 then
	t6.standardDeviationFPS = {
		reducer = function(t7: {[any]: any}) -- line: 127
			local timestamp = tick()
			local v41 = t7.framesCount or 0
			local v42 = t7.sumFPS or 0
			local v43 = t7.sumSquaredFPS or 0

			if t7.previousTime ~= nil and timestamp > t7.previousTime then
				local v44 = 1 / (timestamp - t7.previousTime)

				v41 += 1
				v42 += v44
				v43 += v44 * v44
			end

			return {
				framesCount = v41,
				previousTime = timestamp,
				sumFPS = v42,
				sumSquaredFPS = v43
			}
		end,
		getResult = function(t8: {[any]: any}) -- line: 147
			if t8.framesCount == nil or t8.framesCount < 1 then
				return nil
			end

			local v46 = (t8.sumFPS or 0) / t8.framesCount

			return (math.sqrt((math.max((t8.sumSquaredFPS or 0) / t8.framesCount - v46 * v46, 0))))
		end
	}
end

local t9 = {}
local t10 = {}

for v18, _ in t6 do
	t9[v18] = v18
	table.insert(t10, v18)
end

local t11 = {
	"under_16",
	"16_to_16_7",
	"16_7_to_17_5",
	"17_5_to_18",
	"18_to_21",
	"21_to_25",
	"over_25"
}

local function bucketKeyForFrameTimeMs(n1: number) -- line: 198
	if n1 < 16 then
		return "under_16"
	end

	if n1 < 16.666666666666668 then
		return "16_to_16_7"
	end

	if n1 < 17.5 then
		return "16_7_to_17_5"
	end

	if n1 < 18 then
		return "17_5_to_18"
	end

	if n1 < 21 then
		return "18_to_21"
	end

	if n1 < 25 then
		return "21_to_25"
	end

	return "over_25"
end
local function percentile(t12: {[any]: any}, n2: number) -- line: 217
	local v50 = #t12
	local v51 = math.ceil(n2 / 100 * v50)

	if v51 < 1 then
		v51 = 1
	elseif v50 < v51 then
		v51 = v50
	end

	return t12[v51]
end
local function roundTo(n3: number, n4: number) -- line: 228
	local v54 = 10 ^ n4

	return math.round(n3 * v54) / v54
end
local function appendFrameSample(t13: {[any]: any}, n5: number?, n6: number) -- line: 253
	if n5 ~= nil then
		table.insert(t13, (n6 - n5) * 1000)
	end
end

if v12 then
	local HttpService = game:GetService("HttpService")

	t6.rawFrameTimesMs = {
		reducer = function(t14: {[any]: any}, n7: number) -- line: 266
			local v60 = t14.frames or {}
			local previousTime = t14.previousTime

			if previousTime ~= nil then
				table.insert(v60, (n7 - previousTime) * 1000)
			end

			return {
				frames = v60,
				previousTime = n7
			}
		end,
		getResult = function(t15: {[any]: any}) -- line: 274
			-- upvalues: HttpService (copy)
			if t15.frames == nil or #t15.frames < 1 then
				return nil
			end

			local t16 = {}

			for _, v65 in t15.frames do
				table.insert(t16, math.round(v65 * 100) / 100)
			end

			return HttpService:JSONEncode(t16)
		end
	}
	t6.frameTimeAvgMs = {
		reducer = function(t17: {[any]: any}, n8: number) -- line: 288
			local v68 = t17.framesCount or 0
			local v69 = t17.sumMs or 0

			if t17.previousTime ~= nil then
				v68 += 1
				v69 += (n8 - t17.previousTime) * 1000
			end

			return {
				framesCount = v68,
				sumMs = v69,
				previousTime = n8
			}
		end,
		getResult = function(t18: {[any]: any}) -- line: 301
			if t18.framesCount == nil or t18.framesCount < 1 then
				return nil
			end

			return t18.sumMs / t18.framesCount
		end
	}
	t6.frameTimeStdDevMs = {
		reducer = function(t19: {[any]: any}, n9: number) -- line: 311
			local v73 = t19.framesCount or 0
			local v74 = t19.sumMs or 0
			local v75 = t19.sumSquaredMs or 0

			if t19.previousTime ~= nil then
				local v76 = (n9 - t19.previousTime) * 1000

				v73 += 1
				v74 += v76
				v75 += v76 * v76
			end

			return {
				framesCount = v73,
				sumMs = v74,
				sumSquaredMs = v75,
				previousTime = n9
			}
		end,
		getResult = function(t20: {[any]: any}) -- line: 328
			if t20.framesCount == nil or t20.framesCount < 1 then
				return nil
			end

			local v78 = t20.sumMs / t20.framesCount

			return (math.sqrt((math.max(t20.sumSquaredMs / t20.framesCount - v78 * v78, 0))))
		end
	}
	t6.frameTimeDistributionMs = {
		reducer = function(t21: {[any]: any}, n10: number) -- line: 341
			local v81 = t21.frames or {}
			local previousTime = t21.previousTime

			if previousTime ~= nil then
				table.insert(v81, (n10 - previousTime) * 1000)
			end

			return {
				frames = v81,
				previousTime = n10
			}
		end,
		getResult = function(t22: {[any]: any}) -- line: 349
			-- upvalues: HttpService (copy)
			if t22.frames == nil or #t22.frames < 1 then
				return nil
			end

			local v84 = table.clone(t22.frames)

			table.sort(v84)

			local v85 = HttpService
			local t23 = {}
			local v87 = #v84
			local v88 = math.ceil(v87 * 0.5)

			if v88 < 1 then
				v88 = 1
			elseif v87 < v88 then
				v88 = v87
			end

			t23.p50 = math.round(v84[v88] * 100) / 100

			local v89 = #v84
			local v90 = math.ceil(v89 * 0.95)

			if v90 < 1 then
				v90 = 1
			elseif v89 < v90 then
				v90 = v89
			end

			t23.p95 = math.round(v84[v90] * 100) / 100

			local v91 = #v84
			local v92 = math.ceil(v91 * 0.99)

			if v92 < 1 then
				v92 = 1
			elseif v91 < v92 then
				v92 = v91
			end

			t23.p99 = math.round(v84[v92] * 100) / 100

			return v85:JSONEncode(t23)
		end
	}
	t6.frameBuckets = {
		reducer = function(t24: {[any]: any}, n11: number) -- line: 365
			-- upvalues: t11 (copy)
			local counts

			if t24.counts ~= nil then
				counts = t24.counts
			else
				counts = {}

				for _, v97 in t11 do
					counts[v97] = 0
				end
			end

			if t24.previousTime ~= nil then
				local v98 = (n11 - t24.previousTime) * 1000
				local v99 = if not (v98 < 16) then if not (v98 < 16.666666666666668) then if not (v98 < 17.5) then if not (v98 < 18) then if not (v98 < 21) then not (v98 < 25) and "over_25" or "21_to_25" else "18_to_21" else "17_5_to_18" else "16_7_to_17_5" else "16_to_16_7" else "under_16"

				counts[v99] = counts[v99] + 1
			end

			return {
				counts = counts,
				previousTime = n11
			}
		end,
		getResult = function(t25: {[any]: any}) -- line: 385
			-- upvalues: HttpService (copy)
			if t25.counts == nil then
				return nil
			end

			return HttpService:JSONEncode(t25.counts)
		end
	}

	for _, v27 in {
		"rawFrameTimesMs",
		"frameTimeAvgMs",
		"frameTimeStdDevMs",
		"frameTimeDistributionMs",
		"frameBuckets"
	} do
		t9[v27] = v27
	end
end

local t26 = {}

t26.__index = t26

function t26.new(n12: number?, t27: {[any]: any}?, b1: boolean?, b2: boolean?, t28: {[any]: any}?) -- line: 417
	-- upvalues: GetFFlagAXFPSEventStreamAndCounters (copy), t26 (copy)
	local t29 = {
		_startTime = nil,
		_metricsData = {},
		_timeout = n12,
		_metricsToTrack = t27,
		_countersEnabled = if not GetFFlagAXFPSEventStreamAndCounters() then nil else b1,
		_eventStreamEnabled = if not GetFFlagAXFPSEventStreamAndCounters() then nil else b2,
		_extraFields = t28
	}

	setmetatable(t29, t26)

	return t29
end
function t26.getMetricsToTrack(p4) -- line: 437
	-- upvalues: t10 (copy)
	if p4._metricsToTrack and #p4._metricsToTrack > 0 then
		return p4._metricsToTrack
	end

	return t10
end
function t26.hasReachedTimeout(p5) -- line: 445
	if p5._timeout ~= nil and p5._startTime ~= nil then
		return tick() - p5._startTime > p5._timeout
	end

	return false
end
function t26.updateMetrics(p6) -- line: 452
	-- upvalues: v12 (copy), t6 (copy)
	if p6._startTime == nil then
		p6._startTime = tick()
	end

	local v110 = if not v12 then nil else tick()

	for _, v112 in (p6:getMetricsToTrack()) do
		local v113 = t6[v112]

		if v113 then
			if not p6._metricsData[v112] then
				p6._metricsData[v112] = {}
			end

			p6._metricsData[v112] = v113.reducer(p6._metricsData[v112], v110)
		end
	end
end
function t26.getResult(p7) -- line: 479
	-- upvalues: t6 (copy)
	local t30 = {}

	for _, v117 in (p7:getMetricsToTrack()) do
		local v118 = t6[v117]

		if v118 then
			t30[v117] = v118.getResult(p7._metricsData[v117])
		end
	end

	return t30
end

local t31 = {}

t31.__index = t31

function t31.new() -- line: 507
	-- upvalues: t6 (copy), t9 (copy), t31 (copy)
	local t32 = {
		_renderSteppedConnection = nil,
		_metricsTrackers = t6,
		_intervals = {},
		availableMetricsEnum = t9
	}

	setmetatable(t32, t31)

	return t32
end
function t31._updateIntervals(p8) -- line: 520
	for v121, v122 in p8._intervals do
		v122:updateMetrics()

		if v122:hasReachedTimeout() then
			p8:stopAndLogTracking(v121)
		end
	end
end
function t31.startTracking(p9, s1: string, n13: number?, t33: {[any]: any}?, b3: boolean?, b4: boolean?, t34: {[any]: any}?) -- line: 530
	-- upvalues: v14 (copy), t26 (copy), GetFFlagAXFPSEventStreamAndCounters (copy), RunService (copy)
	if not v14 then
		return
	end

	if not p9._intervals[s1] then
		local v130 = t26.new(n13, t33, if not GetFFlagAXFPSEventStreamAndCounters() then nil else b3, if not GetFFlagAXFPSEventStreamAndCounters() then nil else b4, t34)

		p9._intervals[s1] = v130
		v130:updateMetrics()
	end

	if not p9._renderSteppedConnection then
		p9._renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 558
			-- upvalues: p9 (copy)
			p9:_updateIntervals()
		end)
	end
end
function t31._fireStatsTracking(p10, t35: {[any]: any}) -- line: 572
	-- upvalues: FFlagLuaAppPerfTrackerUseLogger (copy), v5 (copy), v10 (copy), sendFPSStat (copy)
	local averageFPS = t35.averageFPS
	local framesCount = t35.framesCount
	local longestFrameTime = t35.longestFrameTime
	local intervalName = t35.intervalName
	local v137 = p10._intervals[intervalName]

	if not v137 then
		if FFlagLuaAppPerfTrackerUseLogger then
			v5:warning(`Missing interval { intervalName }`)

			return
		end

		warn("Missing interval for interval perfomance trackerstat", intervalName)

		return
	end

	local _countersEnabled = v137._countersEnabled
	local _eventStreamEnabled = v137._eventStreamEnabled

	local function makeStatName(s2: string, s3: string) -- line: 595
		return "IntervalPerformanceTracker_" .. s2 .. "_" .. s3
	end

	if not _countersEnabled and not _eventStreamEnabled or not intervalName then
		return
	end

	if averageFPS then
		local v141 = "IntervalPerformanceTracker_" .. "AverageFPS" .. "_" .. intervalName
		local v142 = table.clone(t35)

		v142.duration = averageFPS
		v142.averageFps = if not v10 then nil else averageFPS
		sendFPSStat({
			statName = v141,
			eventStreamName = intervalName,
			metaData = v142,
			interval = averageFPS,
			excludeCounters = not _countersEnabled,
			excludeEventStream = not _eventStreamEnabled
		})
	end

	if framesCount and _countersEnabled then
		local v143 = "IntervalPerformanceTracker_" .. "FramesCount" .. "_" .. intervalName
		local v144 = table.clone(t35)

		v144.duration = framesCount
		sendFPSStat({
			statName = v143,
			metaData = v144,
			interval = framesCount
		})
	end

	if longestFrameTime and v137._countersEnabled then
		local v145 = "IntervalPerformanceTracker_" .. "LongestFrameTime" .. "_" .. intervalName
		local v146 = table.clone(t35)

		v146.duration = longestFrameTime
		sendFPSStat({
			statName = v145,
			metaData = v146,
			interval = longestFrameTime
		})
	end
end
function t31.stopAndLogTracking(p11, s4: string) -- line: 650
	-- upvalues: v14 (copy), v12 (copy), default (copy), IntervalPerformanceTrackerTelemetryConfig (copy), GetFFlagAXFPSEventStreamAndCounters (copy)
	if not v14 then
		return
	end

	local v149 = p11._intervals[s4]

	if v149 then
		local v150 = v149:getResult()
		local t36 = {
			intervalName = s4
		}

		if v12 and v149._extraFields then
			for v152, v153 in v149._extraFields do
				t36[v152] = v153
			end
		end

		local n14 = 0

		for v155, v156 in v150 do
			if v156 ~= nil then
				n14 += 1
			end

			t36[v155] = v156
		end

		if n14 > 0 then
			default:logRobloxTelemetryEvent(IntervalPerformanceTrackerTelemetryConfig, nil, t36)

			if game:GetFastFlag("DebugPrintIntervalPerformanceTrackerResults") then
				print("IntervalPerformanceTracker:" .. tostring(s4) .. " logged with results:")

				for v157, v158 in t36 do
					print("\t" .. tostring(v157) .. " = " .. tostring(v158))
				end
			end
		end

		if GetFFlagAXFPSEventStreamAndCounters() then
			p11:_fireStatsTracking(t36)
		end

		p11._intervals[s4] = nil
	end

	p11:disconnectUnusedRenderStepped()
end
function t31.cancelTracking(p12, s5: string) -- line: 706
	-- upvalues: v14 (copy)
	if not v14 then
		return
	end

	p12._intervals[s5] = nil
	p12:disconnectUnusedRenderStepped()
end
function t31.disconnectUnusedRenderStepped(p13) -- line: 716
	if not next(p13._intervals) and p13._renderSteppedConnection then
		p13._renderSteppedConnection:Disconnect()
		p13._renderSteppedConnection = nil
	end
end

t31.class = t31

return t31.new()
