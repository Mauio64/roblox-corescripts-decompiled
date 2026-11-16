local intervalPerformanceTracker = script:FindFirstAncestor("IntervalPerformanceTracker")
local parent = intervalPerformanceTracker.Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local MockableProxyServices = require(parent.MockableProxyServices)
local RunService = MockableProxyServices.RunService

local Logger = require(intervalPerformanceTracker.Logger)
local v = Logger:new(script.Name)
local IntervalPerformanceTrackerTelemetryConfig = require(script.Parent.IntervalPerformanceTrackerTelemetryConfig)
game:DefineFastFlag("DebugPrintIntervalPerformanceTrackerResults", false)
local sendFPSStat = require(script.Parent.sendFPSStat)
local sendScrollFrameCounters = require(script.Parent.sendScrollFrameCounters)
local defineFastFlag = game:DefineFastFlag("AXFixAverageFPSCasing", false)

local defineFastFlag2 = game:DefineFastFlag("AXIntervalPerformanceTrackerFPSStandardDeviation", false)

local defineFastFlag3 = game:DefineFastFlag("AXIntervalPerformanceTrackerScrollFrameCounters", false)

local defineFastFlag4 = game:DefineFastFlag("IntervalPerformanceTrackerScrollPositionSamples", false)

local defineFastFlag5 = game:DefineFastFlag("IntervalPerformanceTrackerCancelOnAppHide", false)

local SharedFlags = require(parent.SharedFlags)
local GetFIntIntervalPerformanceTrackerEventStream = SharedFlags.GetFIntIntervalPerformanceTrackerEventStream

local v2 = math.random(0, 1000)
local fIntIntervalPerformanceTrackerEventStream = GetFIntIntervalPerformanceTrackerEventStream()
local v3 = v2 < fIntIntervalPerformanceTrackerEventStream

local function isSessionSampled(p: number): boolean
	return p >= 1000 or v2 < math.max(p, fIntIntervalPerformanceTrackerEventStream)
end

local metricsTrackers = {
	averageFPS = {
		reducer = function(p)
			return {
				framesCount = p.framesCount == nil and 0 or p.framesCount + 1,
				startTime = p.startTime or tick()
			}
		end,
		getResult = function(p)
			local now = tick()

			if p.framesCount == nil or p.framesCount == 0 or p.startTime == nil or now == p.startTime then
				return nil
			end

			return p.framesCount / (now - p.startTime)
		end
	},
	framesCount = {
		reducer = function(p)
			return {
				framesCount = p.framesCount == nil and 0 or p.framesCount + 1
			}
		end,
		getResult = function(p)
			return p.framesCount
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
		getResult = function(p)
			if p.framesCount < 1 then
				return nil
			end

			return p.longestFrameTime
		end
	},
	duration = {
		reducer = function(p)
			return {
				startTime = p.startTime or tick()
			}
		end,
		getResult = function(p)
			return tick() - p.startTime
		end
	}
}

if defineFastFlag2 then
	metricsTrackers.standardDeviationFPS = {
		reducer = function(data)
			local now = tick()
			local framesCount = data.framesCount or 0
			local sumFPS = data.sumFPS or 0
			local sumSquaredFPS = data.sumSquaredFPS or 0

			if data.previousTime ~= nil and data.previousTime < now then
				local v4 = 1 / (now - data.previousTime)
				framesCount += 1
				sumFPS += v4
				sumSquaredFPS += v4 * v4
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

			local v4 = (data.sumFPS or 0) / data.framesCount
			return (math.sqrt((math.max((data.sumSquaredFPS or 0) / data.framesCount - v4 * v4, 0))))
		end
	}
end

local availableMetricsEnum = {}
local result = {}

for k, _ in metricsTrackers do
	availableMetricsEnum[k] = k
	table.insert(result, k)
end

local v4

if defineFastFlag3 then
	local ScrollFrameBands = require(script.Parent.ScrollFrameBands)
	v4 = ScrollFrameBands.FRAME_BUCKET_KEYS
else
	v4 = {
		"under_16",
		"16_to_16_7",
		"16_7_to_17_5",
		"17_5_to_18",
		"18_to_21",
		"21_to_25",
		"over_25"
	}
end

local v5 = { "rawFrameTimesMs", "rawScrollPositionSamplesCsv" }

local function bucketKeyForFrameTimeMs(p: number): string -- 1 equivalent call inferred from this helper
	if p < 16 then
		return "under_16"
	end

	if p < 50 / 3 then
		return "16_to_16_7"
	end

	if p < 17.5 then
		return "16_7_to_17_5"
	end

	if p < 18 then
		return "17_5_to_18"
	end

	if p < 21 then
		return "18_to_21"
	end

	return if p < 25 then "21_to_25" else "over_25"
end

local function percentile(list, p: number)
	local count = #list
	local v6 = math.ceil(p / 100 * count)

	if v6 < 1 then
		v6 = 1
	elseif count < v6 then
		v6 = count
	end

	return list[v6]
end

local function roundTo(p: number, p2: number) -- 6 equivalent calls inferred from this helper
	local v6 = 10 ^ p2
	return math.round(p * v6) / v6
end

local function appendFrameSample(frames, previousTime: number?, p: number) -- 2 equivalent calls inferred from this helper
	if previousTime ~= nil then
		table.insert(frames, (p - previousTime) * 1000)
	end
end

local HttpService = game:GetService("HttpService")

metricsTrackers.rawFrameTimesMs = {
	reducer = function(p, previousTime: number)
		local frames = p.frames or {}
		appendFrameSample(frames, p.previousTime, previousTime) -- inferred equivalent call
		return { frames = frames, previousTime = previousTime }
	end,
	getResult = function(p)
		if p.frames == nil or #p.frames < 1 then
			return nil
		end

		local v6 = {}

		for _, frame in p.frames do
			table.insert(v6, roundTo(frame, 2)) -- inferred equivalent call
		end

		return HttpService:JSONEncode(v6)
	end
}

if defineFastFlag4 then
	metricsTrackers.rawScrollPositionSamplesCsv = {
		reducer = function(data, p: number, p2: number?)
			local timestampsMs = data.timestampsMs or {}
			local positionsY = data.positionsY or {}

			if data.startTime ~= nil and p2 ~= nil then
				table.insert(timestampsMs, (p - data.startTime) * 1000)
				table.insert(positionsY, p2)
			end

			return {
				timestampsMs = timestampsMs,
				positionsY = positionsY,
				startTime = data.startTime or p
			}
		end,
		getResult = function(p)
			local timestampsMs = p.timestampsMs
			local positionsY = p.positionsY

			if timestampsMs == nil or positionsY == nil or #timestampsMs < 1 then
				return nil
			end

			local v6 = table.create(#timestampsMs)

			for k, timestampsM in timestampsMs do
				v6[k] = `{roundTo(timestampsM, 2)},{roundTo(positionsY[k], 2)}` -- inferred equivalent call
			end

			return HttpService:JSONEncode(table.concat(v6, "\n"))
		end
	}
end

metricsTrackers.frameTimeAvgMs = {
	reducer = function(data, previousTime: number)
		local framesCount = data.framesCount or 0
		local sumMs = data.sumMs or 0

		if data.previousTime ~= nil then
			framesCount += 1
			sumMs += (previousTime - data.previousTime) * 1000
		end

		return { framesCount = framesCount, sumMs = sumMs, previousTime = previousTime }
	end,
	getResult = function(p)
		if p.framesCount == nil or p.framesCount < 1 then
			return nil
		end

		return p.sumMs / p.framesCount
	end
}

metricsTrackers.frameTimeStdDevMs = {
	reducer = function(data, previousTime: number)
		local framesCount = data.framesCount or 0
		local sumMs = data.sumMs or 0
		local sumSquaredMs = data.sumSquaredMs or 0

		if data.previousTime ~= nil then
			local v6 = (previousTime - data.previousTime) * 1000
			framesCount += 1
			sumMs += v6
			sumSquaredMs += v6 * v6
		end

		return {
			framesCount = framesCount,
			sumMs = sumMs,
			sumSquaredMs = sumSquaredMs,
			previousTime = previousTime
		}
	end,
	getResult = function(data)
		if data.framesCount == nil or data.framesCount < 1 then
			return nil
		end

		local v6 = data.sumMs / data.framesCount
		return (math.sqrt((math.max(data.sumSquaredMs / data.framesCount - v6 * v6, 0))))
	end
}

metricsTrackers.frameTimeDistributionMs = {
	reducer = function(p, previousTime: number)
		local frames = p.frames or {}
		appendFrameSample(frames, p.previousTime, previousTime) -- inferred equivalent call
		return { frames = frames, previousTime = previousTime }
	end,
	getResult = function(p)
		if p.frames == nil or #p.frames < 1 then
			return nil
		end

		local clone = table.clone(p.frames)
		table.sort(clone)
		local count = #clone
		local v6 = math.ceil(count * 0.5)

		if v6 < 1 then
			v6 = 1
		elseif count < v6 then
			v6 = count
		end

		local v7 = { p50 = roundTo(clone[v6], 2), p95 = 0, p99 = 0 } -- inferred equivalent call
		local count2 = #clone
		local v8 = math.ceil(count2 * 0.95)

		if v8 < 1 then
			v8 = 1
		elseif count2 < v8 then
			v8 = count2
		end

		v7.p95 = roundTo(clone[v8], 2) -- inferred equivalent call
		local count3 = #clone
		local v9 = math.ceil(count3 * 0.99)

		if v9 < 1 then
			v9 = 1
		elseif count3 < v9 then
			v9 = count3
		end

		v7.p99 = roundTo(clone[v9], 2) -- inferred equivalent call
		return HttpService:JSONEncode(v7)
	end
}

metricsTrackers.frameBuckets = {
	reducer = function(p, previousTime: number)
		local counts

		if p.counts == nil then
			counts = {}

			for _, v6 in v4 do
				counts[v6] = 0
			end
		else
			counts = p.counts
		end

		if p.previousTime ~= nil then
			local v6 = bucketKeyForFrameTimeMs((previousTime - p.previousTime) * 1000) -- inferred equivalent call

			counts[v6] += 1
		end

		return { counts = counts, previousTime = previousTime }
	end,
	getResult = function(p)
		if p.counts == nil then
			return nil
		end

		return HttpService:JSONEncode(p.counts)
	end
}

for _, v6 in {
	"rawFrameTimesMs",
	"frameTimeAvgMs",
	"frameTimeStdDevMs",
	"frameTimeDistributionMs",
	"frameBuckets"
} do
	availableMetricsEnum[v6] = v6
end

if defineFastFlag4 then
	availableMetricsEnum.rawScrollPositionSamplesCsv = "rawScrollPositionSamplesCsv"
end

local class = {}
class.__index = class

function class.new(timeout: number?, metricsToTrack, countersEnabled: boolean?, eventStreamEnabled: boolean?, extraFields, scrollFrame)
	local v6 = {
		_metricsData = {},
		_timeout = timeout,
		_startTime = nil,
		_metricsToTrack = metricsToTrack,
		_countersEnabled = countersEnabled,
		_eventStreamEnabled = eventStreamEnabled,
		_extraFields = extraFields,
		_scrollFrame = scrollFrame
	}

	setmetatable(v6, class)
	return v6
end

function class:getMetricsToTrack()
	if self._metricsToTrack and #self._metricsToTrack > 0 then
		return self._metricsToTrack
	end

	return result
end

function class:hasReachedTimeout(): boolean
	return self._timeout ~= nil and self._startTime ~= nil and tick() - self._startTime > self._timeout
end

function class:updateMetrics()
	if self._startTime == nil then
		self._startTime = tick()
	end

	local now = tick()
	local y

	if defineFastFlag4 and self._scrollFrame then
		y = self._scrollFrame.CanvasPosition.Y
	end

	local metricsToTrack = self:getMetricsToTrack()

	for _, v6 in metricsToTrack do
		local v7 = metricsTrackers[v6]

		if not v7 then
			continue
		end

		if not self._metricsData[v6] then
			self._metricsData[v6] = {}
		end

		self._metricsData[v6] = v7.reducer(self._metricsData[v6], now, y)
	end
end

function class:getResult()
	local metricsToTrack = self:getMetricsToTrack()
	local result2 = {}

	for _, v6 in metricsToTrack do
		local v7 = metricsTrackers[v6]

		if v7 then
			result2[v6] = v7.getResult(self._metricsData[v6])
		end
	end

	return result2
end

local class2 = {}
class2.__index = class2

function class2.new()
	local v6 = {
		_metricsTrackers = metricsTrackers,
		_intervals = {},
		_renderSteppedConnection = nil,
		availableMetricsEnum = availableMetricsEnum
	}

	setmetatable(v6, class2)

	if defineFastFlag5 then
		local success, result2 = pcall(function()
			return MockableProxyServices.AppLifecycleObserverService
		end)

		if success and result2 then
			result2.OnHide:Connect(function()
				table.clear(v6._intervals)
				v6:disconnectUnusedRenderStepped()
			end)
		end
	end

	return v6
end

function class2:_updateIntervals()
	for k, interval in self._intervals do
		interval:updateMetrics()

		if interval:hasReachedTimeout() then
			self:stopAndLogTracking(k)
		end
	end
end

function class2:startTracking(p: string, p2: number?, p3, flag: boolean?, flag2: boolean?, p4, p5, p6: number?)
	if p6 == nil then
		if not v3 then
			return
		end
	elseif not (p6 >= 1000 or v2 < math.max(p6, fIntIntervalPerformanceTrackerEventStream)) then
		return
	end

	if not self._intervals[p] then
		local v6 = class.new(p2, p3, flag, flag2, p4, p5)
		self._intervals[p] = v6

		v6:updateMetrics()
	end

	if not self._renderSteppedConnection then
		self._renderSteppedConnection = RunService.RenderStepped:Connect(function()
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
		v:warning(`Missing interval {intervalName}`)
		return
	end

	local countersEnabled = interval._countersEnabled
	local eventStreamEnabled = interval._eventStreamEnabled

	local function makeStatName(p: string, intervalName2: string) -- 3 equivalent calls inferred from this helper
		return "IntervalPerformanceTracker_" .. p .. "_" .. intervalName2
	end

	local function cloneWithoutBulkSamples()
		local clone = table.clone(data)

		for _, v6 in v5 do
			clone[v6] = nil
		end

		return clone
	end

	if not ((countersEnabled or eventStreamEnabled) and intervalName) then
		return
	end

	if averageFPS then
		local statName = makeStatName("AverageFPS", intervalName) -- inferred equivalent call
		local clone

		if defineFastFlag4 then
			clone = table.clone(data)

			for _, v6 in v5 do
				clone[v6] = nil
			end
		else
			clone = table.clone(data)
		end

		clone.duration = averageFPS
		local averageFps

		if defineFastFlag then
			averageFps = averageFPS
		end

		clone.averageFps = averageFps
		sendFPSStat({
			statName = statName,
			eventStreamName = intervalName,
			metaData = clone,
			interval = averageFPS,
			excludeCounters = not countersEnabled,
			excludeEventStream = not eventStreamEnabled
		})
	end

	if framesCount and countersEnabled then
		local statName = makeStatName("FramesCount", intervalName) -- inferred equivalent call
		local clone

		if defineFastFlag4 then
			clone = table.clone(data)

			for _, v6 in v5 do
				clone[v6] = nil
			end
		else
			clone = table.clone(data)
		end

		clone.duration = framesCount
		sendFPSStat({ statName = statName, metaData = clone, interval = framesCount })
	end

	if longestFrameTime and interval._countersEnabled then
		local statName = makeStatName("LongestFrameTime", intervalName) -- inferred equivalent call
		local clone

		if defineFastFlag4 then
			clone = table.clone(data)

			for _, v6 in v5 do
				clone[v6] = nil
			end
		else
			clone = table.clone(data)
		end

		clone.duration = longestFrameTime
		sendFPSStat({ statName = statName, metaData = clone, interval = longestFrameTime })
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

function class2:stopAndLogTracking(intervalName: string)
	if not (v3 or self._intervals[intervalName]) then
		return
	end

	local interval = self._intervals[intervalName]

	if interval then
		local result2 = interval:getResult()

		local v6 = { intervalName = intervalName }

		if interval._extraFields then
			for k, extraField in interval._extraFields do
				v6[k] = extraField
			end
		end

		local count = 0

		for k, v7 in result2 do
			if v7 ~= nil then
				count += 1
			end

			v6[k] = v7
		end

		if count > 0 then
			default:logRobloxTelemetryEvent(IntervalPerformanceTrackerTelemetryConfig, nil, v6)

			if game:GetFastFlag("DebugPrintIntervalPerformanceTrackerResults") then
				print("IntervalPerformanceTracker:" .. tostring(intervalName) .. " logged with results:")

				for k, v7 in v6 do
					print("\t" .. tostring(k) .. " = " .. tostring(v7))
				end
			end
		end

		self:_fireStatsTracking(v6)

		self._intervals[intervalName] = nil
	end

	self:disconnectUnusedRenderStepped()
end

function class2:cancelTracking(p: string)
	if v3 or self._intervals[p] then
		self._intervals[p] = nil

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
