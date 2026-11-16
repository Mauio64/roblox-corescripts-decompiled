local default = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/LoggingProtocol").default
local MockableProxyServices = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/MockableProxyServices")
local runService = MockableProxyServices.RunService

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/Logger"):new("IntervalPerformanceTracker")
local IntervalPerformanceTrackerTelemetryConfig = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/IntervalPerformanceTrackerTelemetryConfig")
game:DefineFastFlag("DebugPrintIntervalPerformanceTrackerResults", false)
local sendFPSStat = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/sendFPSStat")
local sendScrollFrameCounters = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/sendScrollFrameCounters")
local defineFastFlag = game:DefineFastFlag("AXFixAverageFPSCasing", false)

local defineFastFlag2 = game:DefineFastFlag("AXIntervalPerformanceTrackerFPSStandardDeviation", false)

local defineFastFlag3 = game:DefineFastFlag("AXIntervalPerformanceTrackerScrollFrameCounters", false)

local defineFastFlag4 = game:DefineFastFlag("IntervalPerformanceTrackerScrollPositionSamples", false)

local defineFastFlag5 = game:DefineFastFlag("IntervalPerformanceTrackerCancelOnAppHide", false)

local getFIntIntervalPerformanceTrackerEventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/SharedFlags").GetFIntIntervalPerformanceTrackerEventStream

local v6 = math.random(0, 1000)
local fIntIntervalPerformanceTrackerEventStream = getFIntIntervalPerformanceTrackerEventStream()
local v7 = v6 < fIntIntervalPerformanceTrackerEventStream

local function isSessionSampled(p2): boolean
	return p2 >= 1000 or v6 < math.max(p2, fIntIntervalPerformanceTrackerEventStream)
end

local v8 = {
	averageFPS = {
		reducer = function(p2)
			return {
				framesCount = p2.framesCount == nil and 0 or p2.framesCount + 1,
				startTime = p2.startTime or tick()
			}
		end,
		getResult = function(p2)
			local now = tick()

			if
				p2.framesCount == nil
				or p2.framesCount == 0
				or p2.startTime == nil
				or now == p2.startTime
			then
				return nil
			end

			return p2.framesCount / (now - p2.startTime)
		end
	},
	framesCount = {
		reducer = function(p2)
			return {
				framesCount = p2.framesCount == nil and 0 or p2.framesCount + 1
			}
		end,
		getResult = function(p2)
			return p2.framesCount
		end
	},
	longestFrameTime = {
		reducer = function(data)
			return {
				framesCount = data.framesCount == nil and 0 or data.framesCount + 1,
				longestFrameTime = (data.longestFrameTime == nil or data.previousTime == nil) and 0 or math.max(data.longestFrameTime, tick() - data.previousTime),
				previousTime = tick()
			}
		end,
		getResult = function(p2)
			if p2.framesCount < 1 then
				return nil
			end

			return p2.longestFrameTime
		end
	},
	duration = {
		reducer = function(p2)
			return {
				startTime = p2.startTime or tick()
			}
		end,
		getResult = function(p2)
			return tick() - p2.startTime
		end
	}
}

if defineFastFlag2 then
	v8.standardDeviationFPS = {
		reducer = function(data)
			local now = tick()
			local framesCount = data.framesCount or 0
			local sumFPS = data.sumFPS or 0
			local sumSquaredFPS = data.sumSquaredFPS or 0

			if data.previousTime ~= nil and data.previousTime < now then
				local v9 = 1 / (now - data.previousTime)
				framesCount += 1
				sumFPS += v9
				sumSquaredFPS += v9 * v9
			end

			return {
				framesCount = framesCount,
				previousTime = now,
				sumFPS = sumFPS,
				sumSquaredFPS = sumSquaredFPS
			}
		end,
		getResult = function(data)
			if data.framesCount == nil or data.framesCount < 1 then
				return nil
			end

			local v9 = (data.sumFPS or 0) / data.framesCount
			return (math.sqrt((math.max((data.sumSquaredFPS or 0) / data.framesCount - v9 * v9, 0))))
		end
	}
end

local v9 = {}
local result = {}

for k, v10 in v8 do
	v9[k] = k
	table.insert(result, k)
end

local v10 = not defineFastFlag3
	and {
		"under_16",
		"16_to_16_7",
		"16_7_to_17_5",
		"17_5_to_18",
		"18_to_21",
		"21_to_25",
		"over_25"
	}
	or require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/ScrollFrameBands").FRAME_BUCKET_KEYS

local v11 = { "rawFrameTimesMs", "rawScrollPositionSamplesCsv" }

local function bucketKeyForFrameTimeMs(p2): string
	if p2 < 16 then
		return "under_16"
	end

	if p2 < 50 / 3 then
		return "16_to_16_7"
	end

	if p2 < 17.5 then
		return "16_7_to_17_5"
	end

	if p2 < 18 then
		return "17_5_to_18"
	end

	if p2 < 21 then
		return "18_to_21"
	end

	if p2 < 25 then
		return "21_to_25"
	end

	return "over_25"
end

local function percentile(list, p2)
	local count = #list
	local v12 = math.ceil(p2 / 100 * count)

	if v12 < 1 then
		v12 = 1
	elseif count < v12 then
		v12 = count
	end

	return list[v12]
end

local function roundTo(p2, p3)
	local v12 = 10 ^ p3
	return math.round(p2 * v12) / v12
end

local function appendFrameSample(list, p2, p3)
	if p2 ~= nil then
		table.insert(list, (p3 - p2) * 1000)
	end
end

local HttpService = game:GetService("HttpService")

v8.rawFrameTimesMs = {
	reducer = function(p2, p3)
		local frames = p2.frames or {}
		local previousTime = p2.previousTime

		if previousTime ~= nil then
			table.insert(frames, (p3 - previousTime) * 1000)
		end

		return { frames = frames, previousTime = p3 }
	end,
	getResult = function(p2)
		if p2.frames == nil or #p2.frames < 1 then
			return nil
		end

		local v12 = {}

		for k, frame in p2.frames do
			table.insert(v12, math.round(frame * 100) / 100)
		end

		return HttpService:JSONEncode(v12)
	end
}

if defineFastFlag4 then
	v8.rawScrollPositionSamplesCsv = {
		reducer = function(data, p2, p3)
			local timestampsMs = data.timestampsMs or {}
			local positionsY = data.positionsY or {}

			if data.startTime ~= nil and p3 ~= nil then
				table.insert(timestampsMs, (p2 - data.startTime) * 1000)
				table.insert(positionsY, p3)
			end

			return {
				timestampsMs = timestampsMs,
				positionsY = positionsY,
				startTime = data.startTime or p2
			}
		end,
		getResult = function(p2)
			local timestampsMs = p2.timestampsMs
			local positionsY = p2.positionsY

			if timestampsMs == nil or positionsY == nil or #timestampsMs < 1 then
				return nil
			end

			local v12 = table.create(#timestampsMs)

			for k, timestampsM in timestampsMs do
				v12[k] = `{math.round(timestampsM * 100) / 100},{math.round(positionsY[k] * 100) / 100}`
			end

			return HttpService:JSONEncode(table.concat(v12, "\n"))
		end
	}
end

v8.frameTimeAvgMs = {
	reducer = function(data, p2)
		local framesCount = data.framesCount or 0
		local sumMs = data.sumMs or 0

		if data.previousTime ~= nil then
			framesCount += 1
			sumMs += (p2 - data.previousTime) * 1000
		end

		return { framesCount = framesCount, sumMs = sumMs, previousTime = p2 }
	end,
	getResult = function(p2)
		if p2.framesCount == nil or p2.framesCount < 1 then
			return nil
		end

		return p2.sumMs / p2.framesCount
	end
}

v8.frameTimeStdDevMs = {
	reducer = function(data, p2)
		local framesCount = data.framesCount or 0
		local sumMs = data.sumMs or 0
		local sumSquaredMs = data.sumSquaredMs or 0

		if data.previousTime ~= nil then
			local v12 = (p2 - data.previousTime) * 1000
			framesCount += 1
			sumMs += v12
			sumSquaredMs += v12 * v12
		end

		return {
			framesCount = framesCount,
			sumMs = sumMs,
			sumSquaredMs = sumSquaredMs,
			previousTime = p2
		}
	end,
	getResult = function(data)
		if data.framesCount == nil or data.framesCount < 1 then
			return nil
		end

		local v12 = data.sumMs / data.framesCount
		return (math.sqrt((math.max(data.sumSquaredMs / data.framesCount - v12 * v12, 0))))
	end
}

v8.frameTimeDistributionMs = {
	reducer = function(p2, p3)
		local frames = p2.frames or {}
		local previousTime = p2.previousTime

		if previousTime ~= nil then
			table.insert(frames, (p3 - previousTime) * 1000)
		end

		return { frames = frames, previousTime = p3 }
	end,
	getResult = function(p2)
		if p2.frames == nil or #p2.frames < 1 then
			return nil
		end

		local clone = table.clone(p2.frames)
		table.sort(clone)
		local count = #clone
		local v14 = math.ceil(0.5 * count)

		if v14 < 1 then
			v14 = 1
		elseif count < v14 then
			v14 = count
		end

		local v13 = {
			p50 = math.round(clone[v14] * 100) / 100,
			p95 = 0,
			p99 = 0
		}
		local count2 = #clone
		local v15 = math.ceil(0.95 * count2)

		if v15 < 1 then
			v15 = 1
		elseif count2 < v15 then
			v15 = count2
		end

		v13.p95 = math.round(clone[v15] * 100) / 100
		local count3 = #clone
		local v16 = math.ceil(0.99 * count3)

		if v16 < 1 then
			v16 = 1
		elseif count3 < v16 then
			v16 = count3
		end

		v13.p99 = math.round(clone[v16] * 100) / 100
		return HttpService:JSONEncode(v13)
	end
}

v8.frameBuckets = {
	reducer = function(p2, p3)
		local v12

		if p2.counts == nil then
			v12 = {}

			for k, v13 in v10 do
				v12[v13] = 0
			end
		else
			v12 = p2.counts
		end

		if p2.previousTime ~= nil then
			local v13 = (p3 - p2.previousTime) * 1000
			local v14

			if v13 < 16 then
				v14 = "under_16"
			elseif v13 < 50 / 3 then
				v14 = "16_to_16_7"
			elseif v13 < 17.5 then
				v14 = "16_7_to_17_5"
			elseif v13 < 18 then
				v14 = "17_5_to_18"
			else
				v14 = if v13 < 21 then "18_to_21" elseif v13 < 25 then "21_to_25" else "over_25"
			end

			v12[v14] += 1
		end

		return { counts = v12, previousTime = p3 }
	end,
	getResult = function(p2)
		if p2.counts == nil then
			return nil
		end

		return HttpService:JSONEncode(p2.counts)
	end
}

for k, v12 in {
	"rawFrameTimesMs",
	"frameTimeAvgMs",
	"frameTimeStdDevMs",
	"frameTimeDistributionMs",
	"frameBuckets"
} do
	v9[v12] = v12
end

if defineFastFlag4 then
	v9.rawScrollPositionSamplesCsv = "rawScrollPositionSamplesCsv"
end

local class = {}
class.__index = class
function class.new(p2, p3, p4, p5, p6, p7)
	local v12 = {
		_metricsData = {},
		_timeout = p2,
		_startTime = nil,
		_metricsToTrack = p3,
		_countersEnabled = p4,
		_eventStreamEnabled = p5,
		_extraFields = p6,
		_scrollFrame = p7
	}

	setmetatable(v12, class)
	return v12
end

function class:getMetricsToTrack()
	if self._metricsToTrack and #self._metricsToTrack > 0 then
		return self._metricsToTrack
	end

	return result
end

function class:hasReachedTimeout(): boolean
	if self._timeout == nil or self._startTime == nil then
		return false
	end

	return tick() - self._startTime > self._timeout
end

function class:updateMetrics()
	if self._startTime == nil then
		self._startTime = tick()
	end

	local now = tick()
	local y = if defineFastFlag4 and self._scrollFrame then self._scrollFrame.CanvasPosition.Y else nil

	local metricsToTrack = self:getMetricsToTrack()

	for k, v12 in metricsToTrack do
		local v13 = v8[v12]

		if not v13 then
			continue
		end

		if not self._metricsData[v12] then
			self._metricsData[v12] = {}
		end

		self._metricsData[v12] = v13.reducer(self._metricsData[v12], now, y)
	end
end

function class:getResult()
	local metricsToTrack = self:getMetricsToTrack()
	local result2 = {}

	for k, v12 in metricsToTrack do
		local v13 = v8[v12]

		if v13 then
			result2[v12] = v13.getResult(self._metricsData[v12])
		end
	end

	return result2
end

local class2 = {}
class2.__index = class2

function class2.new()
	local v12 = {
		_metricsTrackers = v8,
		_intervals = {},
		_renderSteppedConnection = nil,
		availableMetricsEnum = v9
	}

	setmetatable(v12, class2)

	if defineFastFlag5 then
		local success, result2 = pcall(function()
			return MockableProxyServices.AppLifecycleObserverService
		end)

		if success and result2 then
			result2.OnHide:Connect(function()
				table.clear(v12._intervals)
				v12:disconnectUnusedRenderStepped()
			end)
		end
	end

	return v12
end

function class2:_updateIntervals()
	for k, interval in self._intervals do
		interval:updateMetrics()

		if interval:hasReachedTimeout() then
			self:stopAndLogTracking(k)
		end
	end
end

function class2:startTracking(p2, p3, p4, p5, p6, p7, p8, p9)
	if p9 == nil then
		if not v7 then
			return
		end
	elseif not (p9 >= 1000 or v6 < math.max(p9, fIntIntervalPerformanceTrackerEventStream)) then
		return
	end

	if not self._intervals[p2] then
		local v12 = class.new(p3, p4, p5, p6, p7, p8)
		self._intervals[p2] = v12

		v12:updateMetrics()
	end

	if not self._renderSteppedConnection then
		self._renderSteppedConnection = runService.RenderStepped:Connect(function()
			self:_updateIntervals()
		end)
	end
end

function class2:_fireStatsTracking(data)
	local averageFPS = data.averageFPS
	local framesCount = data.framesCount
	local longestFrameTime = data.longestFrameTime
	local intervalName = data.intervalName

	local interval = self._intervals[intervalName]

	if not interval then
		v5:warning(`Missing interval {intervalName}`)
		return
	end

	local countersEnabled = interval._countersEnabled
	local eventStreamEnabled = interval._eventStreamEnabled

	local function makeStatName(p3, p4)
		return "IntervalPerformanceTracker_" .. p3 .. "_" .. p4
	end

	local function cloneWithoutBulkSamples()
		local clone = table.clone(data)

		for k, v12 in v11 do
			clone[v12] = nil
		end

		return clone
	end

	if not ((countersEnabled or eventStreamEnabled) and intervalName) then
		return
	end

	if averageFPS then
		local v12 = "IntervalPerformanceTracker_" .. "AverageFPS" .. "_" .. intervalName
		local clone

		if defineFastFlag4 then
			clone = table.clone(data)

			for k, v13 in v11 do
				clone[v13] = nil
			end
		else
			clone = table.clone(data)
		end

		clone.duration = averageFPS
		clone.averageFps = if defineFastFlag then averageFPS else nil
		sendFPSStat({
			statName = v12,
			eventStreamName = intervalName,
			metaData = clone,
			interval = averageFPS,
			excludeCounters = not countersEnabled,
			excludeEventStream = not eventStreamEnabled
		})
	end

	if framesCount and countersEnabled then
		local v12 = "IntervalPerformanceTracker_" .. "FramesCount" .. "_" .. intervalName
		local clone

		if defineFastFlag4 then
			clone = table.clone(data)

			for k, v13 in v11 do
				clone[v13] = nil
			end
		else
			clone = table.clone(data)
		end

		clone.duration = framesCount
		sendFPSStat({ statName = v12, metaData = clone, interval = framesCount })
	end

	if longestFrameTime and interval._countersEnabled then
		local v12 = "IntervalPerformanceTracker_" .. "LongestFrameTime" .. "_" .. intervalName
		local clone

		if defineFastFlag4 then
			clone = table.clone(data)

			for k, v13 in v11 do
				clone[v13] = nil
			end
		else
			clone = table.clone(data)
		end

		clone.duration = longestFrameTime
		sendFPSStat({ statName = v12, metaData = clone, interval = longestFrameTime })
	end

	local frameBuckets = defineFastFlag3 and countersEnabled and data.frameBuckets

	if frameBuckets then
		sendScrollFrameCounters({
			intervalName = intervalName,
			scrollType = data.scroll_type,
			frameBucketsJson = frameBuckets
		})
	end
end

function class2:stopAndLogTracking(p2)
	if not (v7 or self._intervals[p2]) then
		return
	end

	local interval = self._intervals[p2]

	if interval then
		local result2 = interval:getResult()

		local v12 = { intervalName = p2 }

		if interval._extraFields then
			for k, extraField in interval._extraFields do
				v12[k] = extraField
			end
		end

		local count = 0

		for k, v13 in result2 do
			if v13 ~= nil then
				count += 1
			end

			v12[k] = v13
		end

		if count > 0 then
			default:logRobloxTelemetryEvent(IntervalPerformanceTrackerTelemetryConfig, nil, v12)

			if game:GetFastFlag("DebugPrintIntervalPerformanceTrackerResults") then
				print("IntervalPerformanceTracker:" .. tostring(p2) .. " logged with results:")

				for k, v13 in v12 do
					print("\t" .. tostring(k) .. " = " .. tostring(v13))
				end
			end
		end

		self:_fireStatsTracking(v12)

		self._intervals[p2] = nil
	end

	self:disconnectUnusedRenderStepped()
end

function class2:cancelTracking(p2)
	if v7 or self._intervals[p2] then
		self._intervals[p2] = nil

		self:disconnectUnusedRenderStepped()
	end
end

function class2:disconnectUnusedRenderStepped()
	if not next(self._intervals) and self._renderSteppedConnection then
		self._renderSteppedConnection:Disconnect()
		self._renderSteppedConnection = nil
	end
end

class2.class = class2
return class2.new()
