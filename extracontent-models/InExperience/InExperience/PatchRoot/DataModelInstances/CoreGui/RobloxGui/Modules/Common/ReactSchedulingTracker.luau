local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local defineFastInt = game:DefineFastInt("ReactSchedulingTracker", 0)
local defineFastInt2 = game:DefineFastInt("ReactSchedulingTrackerPeriodMs", 30000)
local engineFeature = game:GetEngineFeature("TelemetryServiceMemoryCPUInfoEnabled")
local defineFastFlag = game:DefineFastFlag("DisableReactSchedulingTimePctStats", false)
local defineFastFlag2 = game:DefineFastFlag("DisableReactSchedulingAvgMaxMsStats", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringReactSchedulingContext = SharedFlags.FStringReactSchedulingContext
local defineFastString = game:DefineFastString("ReactSchedulingPercentiles", "10,50,95,99")
local defineFastInt3 = game:DefineFastInt("ReactSchedulingKllSketchMaxSize", 200)
local defineFastFlag3 = game:DefineFastFlag("DebugReactSchedulingEnableErrorEvents", false)
local defineFastFlag4 = game:DefineFastFlag("ReactSchedulingTrackerLayoutEffects", false)
local defineFastFlag5 = game:DefineFastFlag("ReactSchedulingTrackerDataModelUpdate", false)
local engineFeature2 = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local defineFastFlag6 = game:DefineFastFlag("EnableCorescriptExecutionTime", false)
local engineFeature3 = game:GetEngineFeature("ScriptPlusExecutionTimeEnabled")

function applicationId()
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local item = AppStorageService:GetItem("AppInstallationId")
	local typeName = typeof(item)

	if typeName == "number" then
		return tonumber(item) or nil
	end

	if typeName ~= "string" or string.len(item) <= 0 then
		return nil
	end

	return (tonumber((string.sub(item, -string.len((tostring(10000)))))))
end

local flag, flag2

if defineFastInt > 0 then
	flag = true
	flag2 = true
else
	flag = false
	flag2 = false
end

local v = math.random(0, 10000)
local v2 = applicationId()

if v2 ~= nil then
	v = (v2 + 1409) % 10000
end

if not (v < defineFastInt) then
	flag = false
	flag2 = false
end

local TelemetryService = game:GetService("TelemetryService")
local Loggers = require(CorePackages.Workspace.Packages.Loggers)
local mutedError = Loggers.mutedError
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
require(CorePackages.Packages.ReactReconciler)
local InExperiencePerformance = require(CorePackages.Workspace.Packages.InExperiencePerformance)
local KllSketch = InExperiencePerformance.KllSketch

local v3 = string.split(defineFastString)
local CorePackages2 = game:GetService("CorePackages")
local Devices = require(CorePackages2.Workspace.Packages.Devices)
local DeviceTier = Devices.DeviceTier

local schedulingProfiler = ReactRoblox.schedulingProfiler
local profilerEventTypes = schedulingProfiler.profilerEventTypes

local _ = { Idle = "Idle", Render = "Render", Commit = "Commit", PassiveEffects = "PassiveEffects" }

local function getCurrentTimeMs() -- 16 equivalent calls inferred from this helper
	return os.clock() * 1000
end

local deviceMemoryTier = DeviceTier.GetDeviceMemoryTier()

local class = {}
class.__index = class

function class.new(frameReporter, rootReporter)
	return (setmetatable({
		frameReporter = frameReporter,
		rootReporter = rootReporter,
		currentState = "Idle",
		timerStartMs = 0,
		layoutTimerStartMs = defineFastFlag4 and 0 or nil,
		rootUpdateInProgress = false,
		rootUpdateTime = {
			tag = "RootUpdateTime",
			RenderMs = 0,
			CommitMs = 0,
			LayoutEffectsMs = defineFastFlag4 and 0 or nil,
			StartTimeMs = 0
		},
		rootPassiveEffectsTime = { tag = "RootPassiveEffectsTime", PassiveEffectsMs = 0 },
		renderLevel = 0,
		states = {
			Idle = function(p, p2: number): nil | string
				if p2 == profilerEventTypes.RenderStart then
					p.timerStartMs = getCurrentTimeMs() -- inferred equivalent call

					if not p.rootUpdateInProgress then
						p.rootUpdateInProgress = true
						p.rootUpdateTime = {
							tag = "RootUpdateTime",
							RenderMs = 0,
							CommitMs = 0,
							LayoutEffectsMs = defineFastFlag4 and 0 or nil,
							StartTimeMs = getCurrentTimeMs() -- inferred equivalent call
						}
					end

					return "Render"
				elseif p2 == profilerEventTypes.PassiveEffectsStart then
					p.timerStartMs = getCurrentTimeMs() -- inferred equivalent call
					p.rootPassiveEffectsTime = {
						tag = "RootPassiveEffectsTime",
						PassiveEffectsMs = 0
					}

					return "PassiveEffects"
				else
					if p2 ~= profilerEventTypes.CommitStart then
						return nil
					end

					p.timerStartMs = getCurrentTimeMs() -- inferred equivalent call
					return "Commit"
				end
			end,
			Render = function(data, p: number): string
				if p ~= profilerEventTypes.RenderYield and p ~= profilerEventTypes.RenderStop then
					mutedError("Invalid event in Render: " .. p)
					return "Idle"
				end

				local v4 = getCurrentTimeMs() - data.timerStartMs -- inferred equivalent call
				data.rootUpdateTime.RenderMs += v4
				data.frameReporter(v4)
				return "Idle"
			end,
			Commit = function(state, p: number, p2): nil | string
				if p == profilerEventTypes.CommitStop then
					if state.renderLevel > 0 then
						if defineFastFlag4 and state.renderLevel == 1 then
							state.rootUpdateTime.LayoutEffectsMs += getCurrentTimeMs() - state.layoutTimerStartMs -- inferred equivalent call
						end

						state.renderLevel -= 1
						return nil
					else
						local v4 = getCurrentTimeMs() - state.timerStartMs -- inferred equivalent call
						state.rootUpdateTime.CommitMs += v4
						state.frameReporter(v4)
						state.rootReporter(state.rootUpdateTime, p2)
						state.rootUpdateInProgress = false
						return "Idle"
					end
				elseif p == profilerEventTypes.RenderStart then
					state.renderLevel += 1

					if defineFastFlag4 and state.renderLevel == 1 then
						state.layoutTimerStartMs = getCurrentTimeMs() -- inferred equivalent call
					end

					return nil
				elseif
					defineFastFlag4
					and (p == profilerEventTypes.LayoutEffectsStart or p == profilerEventTypes.PassiveEffectsStart)
				then
					if state.renderLevel == 0 then
						state.layoutTimerStartMs = getCurrentTimeMs() -- inferred equivalent call
					end

					return nil
				elseif
					defineFastFlag4
					and (p == profilerEventTypes.LayoutEffectsStop or p == profilerEventTypes.PassiveEffectsStop)
				then
					if state.renderLevel == 0 then
						state.rootUpdateTime.LayoutEffectsMs += getCurrentTimeMs() - state.layoutTimerStartMs -- inferred equivalent call
					end

					return nil
				else
					if p ~= profilerEventTypes.RenderYield then
						return nil
					end

					mutedError("Invalid event in Commit: " .. p)
					return "Idle"
				end
			end,
			PassiveEffects = function(data, p: number, p2): string
				if p ~= profilerEventTypes.PassiveEffectsStop then
					mutedError("Invalid event in PassiveEffects: " .. p)
					return "Idle"
				end

				local v4 = getCurrentTimeMs() - data.timerStartMs -- inferred equivalent call
				data.rootPassiveEffectsTime.PassiveEffectsMs += v4
				data.frameReporter(v4)
				data.rootReporter(data.rootPassiveEffectsTime, p2)
				return "Idle"
			end
		}
	}, class))
end

function class:transition(p: number, p2)
	local currentState = self.currentState
	local currentState2 = self.states[currentState](self, p, p2)

	if currentState2 then
		self.currentState = currentState2
	end
end

local standardizedFields = engineFeature
	and {
		"addPlaceId",
		"addUniverseId",
		"addSessionId",
		"addOSInfo",
		"addSessionInfo",
		"addMemoryInfo",
		"addCPUInfo"
	}
	or { "addPlaceId", "addUniverseId", "addSessionId", "addOSInfo", "addSessionInfo" }

if engineFeature2 then
	table.insert(standardizedFields, "addPlaySessionId")
end

local v4 = {
	eventName = "ReactSessionSummary",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ReactSessionSummaryEventThrottleHunderedthsPercent", 0),
	lastUpdated = { 2025, 7, 10 },
	description = "Summary of React performance over a game session",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local v5 = defineFastFlag3 and {
	eventName = "ReactSessionErrorEvent",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("DebugReactSessionErrorEventThrottleHunderedthsPercent", 0),
	lastUpdated = { 2025, 8, 7 },
	description = "Summary of React performance over a game session",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
} or nil

local v6 = {
	eventName = "ReactPeriodSummary",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ReactPeriodSummaryEventThrottleHunderedthsPercent", 0),
	lastUpdated = { 2025, 2, 18 },
	description = "Summary of React performance over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local v7 = {
	eventName = "ReactPeriod",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 18 },
	description = "Stats for React performance over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local v8 = {
	eventName = "ReactFrameCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2025, 2, 18 },
	description = "Frame counts for React performance over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local v9 = {
	eventName = "ReactRootSummary",
	backends = { "EventIngest" },
	lastUpdated = { 2025, 2, 18 },
	throttlingPercentage = game:DefineFastInt("ReactRootSummaryEventThrottleHunderedthsPercent2", 0),
	description = "Summary of React performance for a root",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local v10 = not defineFastFlag and {
	eventName = "ReactRootPeriod",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 18 },
	description = "Stats for React performance for a root over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
} or nil

local v11 = {
	eventName = "ReactRootTaskCount",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2025, 2, 18 },
	description = "Task counts for React performance for a root over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local v12 = not defineFastFlag2 and {
	eventName = "ReactRootPeriodTask",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 18 },
	description = "Task stats for React performance for a root over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
} or nil

local v13 = {
	eventName = "ReactRootUpdate",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 18 },
	description = "Task stats for individual React root updates, all in milliseconds",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8"
}

local class2 = {}
class2.__index = class2

function class2.new(context: string?)
	local sketches = {}
	local sketches2 = {}
	local sketches3 = {}
	local v14 = {}
	local v15 = {}
	local v16 = {}
	sketches.all = KllSketch.new(defineFastInt3)
	sketches2.all = KllSketch.new(defineFastInt3)
	sketches3.all = KllSketch.new(defineFastInt3)

	if defineFastFlag3 then
		v14.all = {}
		v15.all = {}
		v16.all = {}
	end

	local object = setmetatable({
		started = false,
		periodStartMs = 0,
		reactFrameTimeMs = 0,
		frameMetrics = {
			totalFrameCount = 0,
			reactFrameCount = 0,
			totalReactTimeMs = 0,
			totalCorescriptTimeMs = 0,
			maxReactFrameTimeMs = 0,
			allFrameHistogram = { 0, 0, 0, 0 },
			reactFrameHistogram = { 0, 0, 0, 0 },
			reactDropChangeHistogram = { 0, 0, 0, 0 }
		},
		rootsMetrics = {},
		sessionMetrics = {
			updateTime = {
				sketches = sketches,
				allData = not defineFastFlag3 and {} or v14,
				numRoots = 1
			},
			commitTime = {
				sketches = sketches2,
				allData = not defineFastFlag3 and {} or v15,
				numRoots = 1
			},
			timeToUpdate = {
				sketches = sketches3,
				allData = not defineFastFlag3 and {} or v16,
				numRoots = 1
			},
			timePerFrame = { sketch = KllSketch.new(defineFastInt3), allData = {} },
			timePerReactFrame = { sketch = KllSketch.new(defineFastInt3), allData = {} }
		},
		context = context
	}, class2)

	object.schedulerStateMachine = class.new(function(p)
		object:addToFrame(p)
	end, function(p, p2)
		object:trackSessionSketches(p, p2)

		if flag then
			object:reportRoot(p, p2)
		end
	end)

	return object
end

function class2:start()
	self.started = true
	self:resetState()

	schedulingProfiler.registerProfilerEventCallback(function(p: number, p2)
		self.schedulerStateMachine:transition(p, p2)
	end)

	RunService.Heartbeat:Connect(function(dt)
		self:processFrame(dt * 1000)
		self.reactFrameTimeMs = 0

		if defineFastInt2 < getCurrentTimeMs() - self.periodStartMs then -- inferred equivalent call
			if flag2 then
				self:reportPeriod()
			end

			self:resetState()
		end
	end)
end

function class2:resetState()
	self.periodStartMs = getCurrentTimeMs() -- inferred equivalent call
	self.frameMetrics = {
		totalFrameCount = 0,
		reactFrameCount = 0,
		totalReactTimeMs = 0,
		totalCorescriptTimeMs = 0,
		maxReactFrameTimeMs = 0,
		allFrameHistogram = { 0, 0, 0, 0 },
		reactFrameHistogram = { 0, 0, 0, 0 },
		reactDropChangeHistogram = { 0, 0, 0, 0 }
	}

	self.rootsMetrics = {}
end

function class2:getRootName(p)
	local v14 = "Unknown"

	if not p then
		return v14
	end

	if p.containerInfo.Name ~= "Folder" then
		return p.containerInfo.Name
	end

	if p.current and p.current.child and p.current.child.memoizedProps then
		for k, _ in p.current.child.memoizedProps do
			if typeof(k) == "string" then
				return k
			end
		end
	end

	return v14
end

function class2:addToFrame(p)
	self.reactFrameTimeMs += p
end

function class2:trackSessionSketches(data, p)
	if not self.sessionMetrics then
		return
	end

	local rootName = self:getRootName(p)

	if data.tag == "RootUpdateTime" then
		local v14 = getCurrentTimeMs() - data.StartTimeMs -- inferred equivalent call

		if defineFastFlag3 then
			table.insert(self.sessionMetrics.updateTime.allData.all, data.RenderMs + data.CommitMs)
			table.insert(self.sessionMetrics.commitTime.allData.all, data.CommitMs)
			table.insert(self.sessionMetrics.timeToUpdate.allData.all, v14)
		end

		self.sessionMetrics.updateTime.sketches.all:insert(data.RenderMs + data.CommitMs)
		self.sessionMetrics.commitTime.sketches.all:insert(data.CommitMs)
		self.sessionMetrics.timeToUpdate.sketches.all:insert(v14)

		if not self.sessionMetrics.updateTime.sketches[rootName] then
			self.sessionMetrics.updateTime.sketches[rootName] = KllSketch.new(defineFastInt3)

			if defineFastFlag3 then
				self.sessionMetrics.updateTime.allData[rootName] = {}
			end

			self.sessionMetrics.updateTime.numRoots += 1
		end

		self.sessionMetrics.updateTime.sketches[rootName]:insert(data.RenderMs + data.CommitMs)

		if defineFastFlag3 then
			table.insert(self.sessionMetrics.updateTime.allData[rootName], data.RenderMs + data.CommitMs)
		end

		if not self.sessionMetrics.commitTime.sketches[rootName] then
			self.sessionMetrics.commitTime.sketches[rootName] = KllSketch.new(defineFastInt3)

			if defineFastFlag3 then
				self.sessionMetrics.commitTime.allData[rootName] = {}
			end

			self.sessionMetrics.commitTime.numRoots += 1
		end

		self.sessionMetrics.commitTime.sketches[rootName]:insert(data.CommitMs)

		if defineFastFlag3 then
			table.insert(self.sessionMetrics.commitTime.allData[rootName], data.CommitMs)
		end

		if not self.sessionMetrics.timeToUpdate.sketches[rootName] then
			self.sessionMetrics.timeToUpdate.sketches[rootName] = KllSketch.new(defineFastInt3)

			if defineFastFlag3 then
				self.sessionMetrics.timeToUpdate.allData[rootName] = {}
			end

			self.sessionMetrics.timeToUpdate.numRoots += 1
		end

		self.sessionMetrics.timeToUpdate.sketches[rootName]:insert(v14)

		if defineFastFlag3 then
			table.insert(self.sessionMetrics.timeToUpdate.allData[rootName], v14)
		end
	end
end

function class2:reportRoot(data, p)
	local rootName = self:getRootName(p)

	if not self.rootsMetrics[rootName] then
		self.rootsMetrics[rootName] = {
			update_count = 0,
			layout_effects_count = defineFastFlag4 and 0 or nil,
			render_total_time_ms = 0,
			commit_total_time_ms = 0,
			layout_effects_total_time_ms = defineFastFlag4 and 0 or nil,
			data_model_update_total_time_ms = defineFastFlag4 and defineFastFlag5 and 0 or nil,
			max_render_time_ms = 0,
			max_commit_time_ms = 0,
			max_update_time_ms = 0,
			max_layout_effects_time_ms = defineFastFlag4 and 0 or nil,
			max_data_model_update_time_ms = defineFastFlag4 and defineFastFlag5 and 0 or nil,
			passive_effects_count = 0,
			passive_effects_total_time_ms = 0,
			max_passive_effects_time_ms = 0,
			total_time_to_update_ms = 0,
			max_time_to_update_ms = 0
		}
	end

	local rootsMetric = self.rootsMetrics[rootName]

	if data.tag == "RootPassiveEffectsTime" then
		TelemetryService:LogStat(v13, {
			customFields = {
				rootName = rootName,
				deviceTier = deviceMemoryTier,
				updateType = "PassiveEffects",
				context = self.context
			}
		}, data.PassiveEffectsMs)

		rootsMetric.passive_effects_count += 1
		rootsMetric.passive_effects_total_time_ms += data.PassiveEffectsMs

		if data.PassiveEffectsMs > rootsMetric.max_passive_effects_time_ms then
			rootsMetric.max_passive_effects_time_ms = data.PassiveEffectsMs
		end
	elseif data.tag == "RootUpdateTime" then
		local max_time_to_update_ms = getCurrentTimeMs() - data.StartTimeMs -- inferred equivalent call
		TelemetryService:LogStat(v13, {
			customFields = {
				rootName = rootName,
				deviceTier = deviceMemoryTier,
				updateType = "TimeToComplete",
				context = self.context
			}
		}, max_time_to_update_ms)

		rootsMetric.total_time_to_update_ms += max_time_to_update_ms

		if rootsMetric.max_time_to_update_ms < max_time_to_update_ms then
			rootsMetric.max_time_to_update_ms = max_time_to_update_ms
		end

		TelemetryService:LogStat(v13, {
			customFields = {
				rootName = rootName,
				deviceTier = deviceMemoryTier,
				updateType = "RenderAndCommit",
				context = self.context
			}
		}, data.RenderMs + data.CommitMs)

		TelemetryService:LogStat(v13, {
			customFields = {
				rootName = rootName,
				deviceTier = deviceMemoryTier,
				updateType = "Commit",
				context = self.context
			}
		}, data.CommitMs)

		if defineFastFlag4 then
			if data.LayoutEffectsMs > 0 then
				TelemetryService:LogStat(v13, {
					customFields = {
						rootName = rootName,
						deviceTier = deviceMemoryTier,
						updateType = "LayoutEffects",
						context = self.context
					}
				}, data.LayoutEffectsMs)
			end

			if defineFastFlag5 then
				TelemetryService:LogStat(v13, {
					customFields = {
						rootName = rootName,
						deviceTier = deviceMemoryTier,
						updateType = "DataModelUpdate",
						context = self.context
					}
				}, data.CommitMs - data.LayoutEffectsMs)
			end
		end

		rootsMetric.update_count += 1

		if data.RenderMs + data.CommitMs > rootsMetric.max_update_time_ms then
			rootsMetric.max_update_time_ms = data.RenderMs + data.CommitMs
		end

		rootsMetric.render_total_time_ms += data.RenderMs
		rootsMetric.commit_total_time_ms += data.CommitMs

		if data.RenderMs > rootsMetric.max_render_time_ms then
			rootsMetric.max_render_time_ms = data.RenderMs
		end

		if data.CommitMs > rootsMetric.max_commit_time_ms then
			rootsMetric.max_commit_time_ms = data.CommitMs
		end

		if defineFastFlag4 then
			if data.LayoutEffectsMs > 0 then
				rootsMetric.layout_effects_count += 1
				rootsMetric.layout_effects_total_time_ms += data.LayoutEffectsMs

				if data.LayoutEffectsMs > rootsMetric.max_layout_effects_time_ms then
					rootsMetric.max_layout_effects_time_ms = data.LayoutEffectsMs
				end
			end

			if defineFastFlag5 then
				rootsMetric.data_model_update_total_time_ms += data.CommitMs - data.LayoutEffectsMs

				if data.CommitMs - data.LayoutEffectsMs > rootsMetric.max_data_model_update_time_ms then
					rootsMetric.max_data_model_update_time_ms = data.CommitMs - data.LayoutEffectsMs
				end
			end
		end
	end
end

function class2:getFrameBucket(p: number)
	return (math.min(4, math.floor(math.max(0, p - 2) / (50 / 3)) + 1))
end

function class2:processFrame(p: number)
	local frameMetrics = self.frameMetrics
	local reactFrameTimeMs = self.reactFrameTimeMs

	if engineFeature3 and defineFastFlag6 then
		local totalScriptPlusExecutionTime = RunService:GetTotalScriptPlusExecutionTime()

		if totalScriptPlusExecutionTime > 0 then
			frameMetrics.totalCorescriptTimeMs += totalScriptPlusExecutionTime
		end
	end

	frameMetrics.totalFrameCount += 1
	local frameBucket = self:getFrameBucket(p)
	frameMetrics.allFrameHistogram[frameBucket] += 1
	self.sessionMetrics.timePerFrame.sketch:insert(reactFrameTimeMs)

	if defineFastFlag3 then
		table.insert(self.sessionMetrics.timePerFrame.allData, reactFrameTimeMs)
	end

	if reactFrameTimeMs > 0 then
		frameMetrics.totalReactTimeMs += reactFrameTimeMs
		frameMetrics.reactFrameHistogram[frameBucket] += 1
		self.sessionMetrics.timePerReactFrame.sketch:insert(reactFrameTimeMs)

		if defineFastFlag3 then
			table.insert(self.sessionMetrics.timePerReactFrame.allData, reactFrameTimeMs)
		end

		frameMetrics.reactFrameCount += 1

		if frameMetrics.maxReactFrameTimeMs < reactFrameTimeMs then
			frameMetrics.maxReactFrameTimeMs = reactFrameTimeMs
		end

		local v14 = frameBucket - self:getFrameBucket(p - reactFrameTimeMs)
		local reactDropChangeHistogram = frameMetrics.reactDropChangeHistogram
		local v15 = v14 + 1
		reactDropChangeHistogram[v15] += 1
	end
end

function class2:reportPeriod()
	local frameMetrics = self.frameMetrics
	local period_length_ms = getCurrentTimeMs() - self.periodStartMs -- inferred equivalent call
	local customFields = {
		period_length_ms = period_length_ms,
		react_total_time_ms = frameMetrics.totalReactTimeMs,
		react_total_time_pct = frameMetrics.totalReactTimeMs / period_length_ms,
		react_frame_count = frameMetrics.reactFrameCount,
		total_frame_count = frameMetrics.totalFrameCount,
		corescript_total_time_ms = frameMetrics.totalCorescriptTimeMs,
		corescript_total_time_pct = frameMetrics.totalCorescriptTimeMs / period_length_ms,
		average_react_all_frame_ms = frameMetrics.totalReactTimeMs / frameMetrics.totalFrameCount,
		average_react_only_frame_ms = not (frameMetrics.reactFrameCount > 0) and 0 or frameMetrics.totalReactTimeMs / frameMetrics.reactFrameCount,
		max_react_frame_ms = frameMetrics.maxReactFrameTimeMs,
		all_frame_drop0 = frameMetrics.allFrameHistogram[1],
		all_frame_drop1 = frameMetrics.allFrameHistogram[2],
		all_frame_drop2 = frameMetrics.allFrameHistogram[3],
		all_frame_drop3 = frameMetrics.allFrameHistogram[4],
		react_frame_drop0 = frameMetrics.reactFrameHistogram[1],
		react_frame_drop1 = frameMetrics.reactFrameHistogram[2],
		react_frame_drop2 = frameMetrics.reactFrameHistogram[3],
		react_frame_drop3 = frameMetrics.reactFrameHistogram[4],
		react_drop_change0 = frameMetrics.reactDropChangeHistogram[1],
		react_drop_change1 = frameMetrics.reactDropChangeHistogram[2],
		react_drop_change2 = frameMetrics.reactDropChangeHistogram[3],
		react_drop_change3 = frameMetrics.reactDropChangeHistogram[4]
	}

	TelemetryService:LogEvent(v6, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})

	TelemetryService:LogStat(v7, {
		customFields = {
			stat = "ReactTotalTimePct",
			context = self.context,
			deviceTier = deviceMemoryTier
		}
	}, customFields.react_total_time_pct)

	if engineFeature3 and defineFastFlag6 then
		TelemetryService:LogStat(v7, {
			customFields = {
				stat = "TotalCorescriptTimePct",
				context = self.context,
				deviceTier = deviceMemoryTier
			}
		}, customFields.corescript_total_time_pct)
	end

	TelemetryService:LogStat(v7, {
		customFields = {
			stat = "AverageReactAllFrameMs",
			context = self.context,
			deviceTier = deviceMemoryTier
		}
	}, customFields.average_react_all_frame_ms)
	TelemetryService:LogStat(v7, {
		customFields = {
			stat = "AverageReactOnlyFrameMs",
			context = self.context,
			deviceTier = deviceMemoryTier
		}
	}, customFields.average_react_only_frame_ms)
	TelemetryService:LogStat(v7, {
		customFields = {
			stat = "MaxReactFrameMs",
			context = self.context,
			deviceTier = deviceMemoryTier
		}
	}, customFields.max_react_frame_ms)

	for i = 1, 4 do
		local bucket = i - 1
		TelemetryService:LogCounter(v8, {
			customFields = {
				category = "AllFrame",
				bucket = bucket,
				context = self.context,
				deviceTier = deviceMemoryTier
			}
		}, frameMetrics.allFrameHistogram[i])

		TelemetryService:LogCounter(v8, {
			customFields = {
				category = "ReactFrame",
				bucket = bucket,
				context = self.context,
				deviceTier = deviceMemoryTier
			}
		}, frameMetrics.reactFrameHistogram[i])

		TelemetryService:LogCounter(v8, {
			customFields = {
				category = "ReactDropChange",
				bucket = bucket,
				context = self.context,
				deviceTier = deviceMemoryTier
			}
		}, frameMetrics.reactDropChangeHistogram[i])
	end

	for k, rootsMetric in self.rootsMetrics do
		rootsMetric.root_name = k
		rootsMetric.update_total_time_ms = rootsMetric.render_total_time_ms + rootsMetric.commit_total_time_ms
		rootsMetric.total_time_ms = rootsMetric.update_total_time_ms + rootsMetric.passive_effects_total_time_ms
		rootsMetric.avg_render_time_ms = rootsMetric.render_total_time_ms / rootsMetric.update_count
		rootsMetric.context = self.context
		rootsMetric.total_time_pct = (rootsMetric.update_total_time_ms + rootsMetric.passive_effects_total_time_ms) / customFields.react_total_time_ms
		rootsMetric.avg_update_time_ms = rootsMetric.update_total_time_ms / rootsMetric.update_count
		rootsMetric.avg_commit_time_ms = rootsMetric.commit_total_time_ms / rootsMetric.update_count

		if defineFastFlag4 then
			rootsMetric.avg_layout_effects_time_ms = rootsMetric.layout_effects_total_time_ms / rootsMetric.layout_effects_count

			if defineFastFlag5 then
				rootsMetric.avg_data_model_update_time_ms = rootsMetric.data_model_update_total_time_ms / rootsMetric.update_count
			end
		end

		rootsMetric.avg_passive_effects_time_ms = rootsMetric.passive_effects_total_time_ms / rootsMetric.passive_effects_count
		rootsMetric.avg_time_to_update_ms = rootsMetric.total_time_to_update_ms / rootsMetric.update_count

		TelemetryService:LogEvent(v9, {
			standardizedFields = standardizedFields,
			customFields = rootsMetric
		})

		if not defineFastFlag then
			TelemetryService:LogStat(v10, {
				customFields = {
					rootName = rootsMetric.root_name,
					deviceTier = deviceMemoryTier,
					stat = "TotalTimePct",
					context = self.context
				}
			}, rootsMetric.total_time_pct)
		end

		TelemetryService:LogCounter(v11, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "RenderAndCommit",
				context = self.context
			}
		}, rootsMetric.update_count)

		if defineFastFlag4 then
			TelemetryService:LogCounter(v11, {
				customFields = {
					rootName = rootsMetric.root_name,
					deviceTier = deviceMemoryTier,
					task = "LayoutEffects",
					context = self.context
				}
			}, rootsMetric.layout_effects_count)
		end

		TelemetryService:LogCounter(v11, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "PassiveEffects",
				context = self.context
			}
		}, rootsMetric.passive_effects_count)

		if defineFastFlag2 then
			continue
		end

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "RenderAndCommit",
				stat = "AvgMs",
				context = self.context
			}
		}, rootsMetric.avg_update_time_ms)

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "Commit",
				stat = "AvgMs",
				context = self.context
			}
		}, rootsMetric.avg_commit_time_ms)

		if defineFastFlag4 then
			TelemetryService:LogStat(v12, {
				customFields = {
					rootName = rootsMetric.root_name,
					deviceTier = deviceMemoryTier,
					task = "LayoutEffects",
					stat = "AvgMs",
					context = self.context
				}
			}, rootsMetric.avg_layout_effects_time_ms)

			if defineFastFlag5 then
				TelemetryService:LogStat(v12, {
					customFields = {
						rootName = rootsMetric.root_name,
						deviceTier = deviceMemoryTier,
						task = "DataModelUpdate",
						stat = "AvgMs",
						context = self.context
					}
				}, rootsMetric.avg_data_model_update_time_ms)
			end
		end

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "TimeToUpdateMs",
				stat = "AvgMs",
				context = self.context
			}
		}, rootsMetric.avg_time_to_update_ms)

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "PassiveEffects",
				stat = "AvgMs",
				context = self.context
			}
		}, rootsMetric.avg_passive_effects_time_ms)

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "RenderAndCommit",
				stat = "MaxMs",
				context = self.context
			}
		}, rootsMetric.max_update_time_ms)

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "Commit",
				stat = "MaxMs",
				context = self.context
			}
		}, rootsMetric.max_commit_time_ms)

		if defineFastFlag4 then
			TelemetryService:LogStat(v12, {
				customFields = {
					rootName = rootsMetric.root_name,
					deviceTier = deviceMemoryTier,
					task = "LayoutEffects",
					stat = "MaxMs",
					context = self.context
				}
			}, rootsMetric.max_layout_effects_time_ms)

			if defineFastFlag5 then
				TelemetryService:LogStat(v12, {
					customFields = {
						rootName = rootsMetric.root_name,
						deviceTier = deviceMemoryTier,
						task = "DataModelUpdate",
						stat = "MaxMs",
						context = self.context
					}
				}, rootsMetric.max_data_model_update_time_ms)
			end
		end

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "TimeToUpdateMs",
				stat = "MaxMs",
				context = self.context
			}
		}, rootsMetric.max_time_to_update_ms)

		TelemetryService:LogStat(v12, {
			customFields = {
				rootName = rootsMetric.root_name,
				deviceTier = deviceMemoryTier,
				task = "PassiveEffects",
				stat = "MaxMs",
				context = self.context
			}
		}, rootsMetric.max_passive_effects_time_ms)
	end
end

function generatePercentilesFromSingleSketch(object)
	local v14 = "{"

	for k, v15 in v3 do
		v14 = (v14 .. "\"p" .. v15 .. "\":") .. object:getPercentile(tonumber(v15) or 0)

		if k < #v3 then
			v14 ..= ","
		end
	end

	return v14 .. "}"
end

function generatePercentilesFromSketches(items, p: number)
	local v14 = "{"

	for k, v15 in v3 do
		local v16 = v14 .. "\"p" .. v15 .. "\":{"
		local v17 = tonumber(v15) or 0
		local count = 0

		for k2, item in items do
			count += 1
			v16 ..= "\"" .. k2 .. "\":" .. item:getPercentile(v17)

			if count < p then
				v16 ..= ","
			end
		end

		v14 = v16 .. (k < #v3 and "}," or "}")
	end

	return v14 .. "}"
end

function class2:reportPercentError(list, p, metric, rootName)
	table.sort(list)
	local count = #list

	if count < 1 then
		return
	end

	for _, percentile in v3 do
		local item = list[math.ceil((tonumber(percentile) or 0) / 100 * count)]
		local v14

		if p.sketches then
			v14 = p.sketches[rootName]:getPercentile(percentile)
		else
			v14 = p.sketch:getPercentile(percentile)
		end

		local approxError = 0

		if not (item ~= 0 or v14 == 0) then
			continue
		end

		if item ~= 0 then
			approxError = (v14 - item) * 100 / item
		end

		TelemetryService:LogEvent(v5, {
			standardizedFields = standardizedFields,
			customFields = {
				rootName = rootName,
				percentile = percentile,
				metric = metric,
				numDatapoints = count,
				context = self.context,
				approxError = approxError
			}
		})
	end
end

function class2:reportSession()
	if not self.started then
		return
	end

	local customFields = {
		reactUpdateTime = generatePercentilesFromSketches(
			self.sessionMetrics.updateTime.sketches,
			self.sessionMetrics.updateTime.numRoots
		),
		reactCommitTime = generatePercentilesFromSketches(
			self.sessionMetrics.commitTime.sketches,
			self.sessionMetrics.commitTime.numRoots
		),
		reactTimeToUpdate = generatePercentilesFromSketches(
			self.sessionMetrics.timeToUpdate.sketches,
			self.sessionMetrics.timeToUpdate.numRoots
		),
		timePerFrame = generatePercentilesFromSingleSketch(self.sessionMetrics.timePerFrame.sketch),
		timePerReactFrame = generatePercentilesFromSingleSketch(self.sessionMetrics.timePerReactFrame.sketch)
	}

	if defineFastFlag3 then
		for k, sessionMetric in self.sessionMetrics do
			if sessionMetric.sketches then
				for k2, v14 in sessionMetric.allData do
					self:reportPercentError(v14, sessionMetric, k, k2)
				end
			else
				self:reportPercentError(sessionMetric.allData, sessionMetric, k, "all")
			end
		end
	end

	TelemetryService:LogEvent(v4, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

return (class2.new(FStringReactSchedulingContext))
