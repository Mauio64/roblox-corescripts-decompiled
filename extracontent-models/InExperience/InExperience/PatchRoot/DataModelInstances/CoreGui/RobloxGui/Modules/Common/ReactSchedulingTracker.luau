local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local v3 = game:DefineFastInt("ReactSchedulingTracker", 0)
local v4 = game:DefineFastInt("ReactSchedulingTrackerPeriodMs", 30000)
local EngineFeature = game:GetEngineFeature("TelemetryServiceMemoryCPUInfoEnabled")
local v6 = game:DefineFastFlag("DisableReactSchedulingTimePctStats", false)
local v7 = game:DefineFastFlag("DisableReactSchedulingAvgMaxMsStats", false)
local FStringReactSchedulingContext = require(CorePackages.Workspace.Packages.SharedFlags).FStringReactSchedulingContext
local v9 = game:DefineFastString("ReactSchedulingPercentiles", "10,50,95,99")
local v10 = game:DefineFastInt("ReactSchedulingKllSketchMaxSize", 200)
local v11 = game:DefineFastFlag("DebugReactSchedulingEnableErrorEvents", false)
local v12 = game:DefineFastFlag("ReactSchedulingTrackerLayoutEffects", false)
local v13 = game:DefineFastFlag("ReactSchedulingTrackerDataModelUpdate", false)
local EngineFeature2 = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local v15 = game:DefineFastFlag("EnableCorescriptExecutionTime", false)
local EngineFeature3 = game:GetEngineFeature("ScriptPlusExecutionTimeEnabled")

function applicationId() -- line: 22
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local Item = AppStorageService:GetItem("AppInstallationId")
	local v49 = typeof(Item)

	if v49 == "number" then
		return tonumber(Item) or nil
	end

	if v49 == "string" then
		if string.len(Item) <= 0 then
			return nil
		end

		return (tonumber((string.sub(Item, -string.len((tostring(10000)))))))
	end

	return nil
end

local v17 = v3 > 0
local u18 = true
local u19 = true

if not v17 then
	u19 = false
	u18 = false
end

local v20 = math.random(0, 10000)
local v21 = applicationId()

if v21 ~= nil then
	v20 = (v21 + 1409) % 10000
end

if not (v20 < v3) then
	u19 = false
	u18 = false
end

local TelemetryService = game:GetService("TelemetryService")
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

require(CorePackages.Packages.ReactReconciler)

local KllSketch = require(CorePackages.Workspace.Packages.InExperiencePerformance).KllSketch
local parts = string.split(v9)
local CorePackages2 = game:GetService("CorePackages")
local DeviceTier = require(CorePackages2.Workspace.Packages.Devices).DeviceTier
local schedulingProfiler = ReactRoblox.schedulingProfiler
local profilerEventTypes = schedulingProfiler.profilerEventTypes
local _ = {
	Idle = "Idle",
	Render = "Render",
	Commit = "Commit",
	PassiveEffects = "PassiveEffects"
}

local function getCurrentTimeMs() -- line: 98
	return os.clock() * 1000
end

local v33 = DeviceTier.GetDeviceMemoryTier()
local t1 = {}

t1.__index = t1

function t1.new(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 141
	-- upvalues: v12 (copy), profilerEventTypes (copy), mutedError (copy), t1 (copy)
	return (setmetatable({
		currentState = "Idle",
		timerStartMs = 0,
		rootUpdateInProgress = false,
		renderLevel = 0,
		frameReporter = p1,
		rootReporter = p2,
		layoutTimerStartMs = if not v12 then nil else 0,
		rootUpdateTime = {
			tag = "RootUpdateTime",
			RenderMs = 0,
			CommitMs = 0,
			StartTimeMs = 0,
			LayoutEffectsMs = if not v12 then nil else 0
		},
		rootPassiveEffectsTime = {
			tag = "RootPassiveEffectsTime",
			PassiveEffectsMs = 0
		},
		states = {
			Idle = function(p3, n1: number) -- line: 165
				-- upvalues: profilerEventTypes (copy), v12 (copy)
				if n1 == profilerEventTypes.RenderStart then
					p3.timerStartMs = os.clock() * 1000

					if not p3.rootUpdateInProgress then
						p3.rootUpdateInProgress = true
						p3.rootUpdateTime = {
							tag = "RootUpdateTime",
							RenderMs = 0,
							CommitMs = 0,
							LayoutEffectsMs = if not v12 then nil else 0,
							StartTimeMs = os.clock() * 1000
						}
					end

					return "Render"
				end

				if n1 == profilerEventTypes.PassiveEffectsStart then
					p3.timerStartMs = os.clock() * 1000
					p3.rootPassiveEffectsTime = {
						tag = "RootPassiveEffectsTime",
						PassiveEffectsMs = 0
					}

					return "PassiveEffects"
				end

				if n1 == profilerEventTypes.CommitStart then
					p3.timerStartMs = os.clock() * 1000

					return "Commit"
				end

				return nil
			end,
			Render = function(p4, n2: number) -- line: 194
				-- upvalues: profilerEventTypes (copy), mutedError (copy)
				if n2 == profilerEventTypes.RenderYield or n2 == profilerEventTypes.RenderStop then
					local v149 = os.clock() * 1000 - p4.timerStartMs
					local rootUpdateTime = p4.rootUpdateTime

					rootUpdateTime.RenderMs = rootUpdateTime.RenderMs + v149
					p4.frameReporter(v149)

					return "Idle"
				end

				mutedError("Invalid event in Render: " .. n2)

				return "Idle"
			end,
			Commit = function(p5, n3: number, p6) -- line: 206
				-- upvalues: profilerEventTypes (copy), v12 (copy), mutedError (copy)
				if n3 == profilerEventTypes.CommitStop then
					if p5.renderLevel > 0 then
						if v12 and p5.renderLevel == 1 then
							local rootUpdateTime = p5.rootUpdateTime

							rootUpdateTime.LayoutEffectsMs = rootUpdateTime.LayoutEffectsMs + (os.clock() * 1000 - p5.layoutTimerStartMs)
						end

						p5.renderLevel = p5.renderLevel - 1

						return nil
					end

					local v155 = os.clock() * 1000 - p5.timerStartMs
					local rootUpdateTime = p5.rootUpdateTime

					rootUpdateTime.CommitMs = rootUpdateTime.CommitMs + v155
					p5.frameReporter(v155)
					p5.rootReporter(p5.rootUpdateTime, p6)
					p5.rootUpdateInProgress = false

					return "Idle"
				end

				if n3 == profilerEventTypes.RenderStart then
					p5.renderLevel = p5.renderLevel + 1

					if v12 and p5.renderLevel == 1 then
						p5.layoutTimerStartMs = os.clock() * 1000
					end

					return nil
				end

				if v12 and (n3 == profilerEventTypes.LayoutEffectsStart or n3 == profilerEventTypes.PassiveEffectsStart) then
					if p5.renderLevel == 0 then
						p5.layoutTimerStartMs = os.clock() * 1000
					end

					return nil
				end

				if v12 and (n3 == profilerEventTypes.LayoutEffectsStop or n3 == profilerEventTypes.PassiveEffectsStop) then
					if p5.renderLevel == 0 then
						local rootUpdateTime = p5.rootUpdateTime

						rootUpdateTime.LayoutEffectsMs = rootUpdateTime.LayoutEffectsMs + (os.clock() * 1000 - p5.layoutTimerStartMs)
					end

					return nil
				end

				if n3 ~= profilerEventTypes.RenderYield then
					return nil
				end

				mutedError("Invalid event in Commit: " .. n3)

				return "Idle"
			end,
			PassiveEffects = function(p7, n4: number, p8) -- line: 253
				-- upvalues: profilerEventTypes (copy), mutedError (copy)
				if n4 == profilerEventTypes.PassiveEffectsStop then
					local v161 = os.clock() * 1000 - p7.timerStartMs
					local rootPassiveEffectsTime = p7.rootPassiveEffectsTime

					rootPassiveEffectsTime.PassiveEffectsMs = rootPassiveEffectsTime.PassiveEffectsMs + v161
					p7.frameReporter(v161)
					p7.rootReporter(p7.rootPassiveEffectsTime, p8)

					return "Idle"
				end

				mutedError("Invalid event in PassiveEffects: " .. n4)

				return "Idle"
			end
		}
	}, t1))
end
function t1.transition(t2: {[any]: any}, n5: number, p9) -- line: 276
	local currentState = t2.currentState
	local v56 = t2.states[currentState](t2, n5, p9)

	if v56 then
		t2.currentState = v56
	end
end

local t3 = {
	"addPlaceId",
	"addUniverseId",
	"addSessionId",
	"addOSInfo",
	"addSessionInfo"
}

if EngineFeature then
	t3 = {
		"addPlaceId",
		"addUniverseId",
		"addSessionId",
		"addOSInfo",
		"addSessionInfo",
		"addMemoryInfo",
		"addCPUInfo"
	}
end

if EngineFeature2 then
	table.insert(t3, "addPlaySessionId")
end

local t4 = {
	eventName = "ReactSessionSummary",
	description = "Summary of React performance over a game session",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ReactSessionSummaryEventThrottleHunderedthsPercent", 0),
	lastUpdated = {
		2025,
		7,
		10
	}
}
local t5 = nil

if v11 then
	t5 = {
		eventName = "ReactSessionErrorEvent",
		description = "Summary of React performance over a game session",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
		backends = { "EventIngest" },
		throttlingPercentage = game:DefineFastInt("DebugReactSessionErrorEventThrottleHunderedthsPercent", 0),
		lastUpdated = {
			2025,
			8,
			7
		}
	}
end

local t6 = {
	eventName = "ReactPeriodSummary",
	description = "Summary of React performance over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("ReactPeriodSummaryEventThrottleHunderedthsPercent", 0),
	lastUpdated = {
		2025,
		2,
		18
	}
}
local t7 = {
	eventName = "ReactPeriod",
	description = "Stats for React performance over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		18
	}
}
local t8 = {
	eventName = "ReactFrameCounter",
	description = "Frame counts for React performance over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2025,
		2,
		18
	}
}
local t9 = {
	eventName = "ReactRootSummary",
	description = "Summary of React performance for a root",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "EventIngest" },
	lastUpdated = {
		2025,
		2,
		18
	},
	throttlingPercentage = game:DefineFastInt("ReactRootSummaryEventThrottleHunderedthsPercent2", 0)
}
local t10 = nil

if not v6 then
	t10 = {
		eventName = "ReactRootPeriod",
		description = "Stats for React performance for a root over a period",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			2,
			18
		}
	}
end

local t11 = {
	eventName = "ReactRootTaskCount",
	description = "Task counts for React performance for a root over a period",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2025,
		2,
		18
	}
}
local t12 = nil

if not v7 then
	t12 = {
		eventName = "ReactRootPeriodTask",
		description = "Task stats for React performance for a root over a period",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2025,
			2,
			18
		}
	}
end

local t13 = {
	eventName = "ReactRootUpdate",
	description = "Task stats for individual React root updates, all in milliseconds",
	links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/3321660204/React+Profiler+Metric+Issues+and+Path+Forward#New-Metrics-%E2%9C%A8",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		18
	}
}
local t14 = {}

t14.__index = t14

function t14.new(s1: string?) -- line: 464
	-- upvalues: KllSketch (copy), v10 (copy), v11 (copy), t14 (copy), t1 (copy), u19 (ref)
	local t15 = {}
	local t16 = {}
	local t17 = {}
	local t18 = {}
	local t19 = {}
	local t20 = {}

	t15.all = KllSketch.new(v10)
	t16.all = KllSketch.new(v10)
	t17.all = KllSketch.new(v10)

	if v11 then
		t18.all = {}
		t19.all = {}
		t20.all = {}
	end

	local v64 = setmetatable({
		started = false,
		periodStartMs = 0,
		reactFrameTimeMs = 0,
		frameMetrics = {
			totalFrameCount = 0,
			reactFrameCount = 0,
			totalReactTimeMs = 0,
			totalCorescriptTimeMs = 0,
			maxReactFrameTimeMs = 0,
			allFrameHistogram = {
				0,
				0,
				0,
				0
			},
			reactFrameHistogram = {
				0,
				0,
				0,
				0
			},
			reactDropChangeHistogram = {
				0,
				0,
				0,
				0
			}
		},
		rootsMetrics = {},
		sessionMetrics = {
			updateTime = {
				numRoots = 1,
				sketches = t15,
				allData = if not v11 then {} else t18
			},
			commitTime = {
				numRoots = 1,
				sketches = t16,
				allData = if not v11 then {} else t19
			},
			timeToUpdate = {
				numRoots = 1,
				sketches = t17,
				allData = if not v11 then {} else t20
			},
			timePerFrame = {
				sketch = KllSketch.new(v10),
				allData = {}
			},
			timePerReactFrame = {
				sketch = KllSketch.new(v10),
				allData = {}
			}
		},
		context = s1
	}, t14)

	v64.schedulerStateMachine = t1.new(function(p10) -- line: 519
		-- upvalues: v64 (copy)
		v64:addToFrame(p10)
	end, function(p11, p12) -- line: 521
		-- upvalues: v64 (copy), u19 (ref)
		v64:trackSessionSketches(p11, p12)

		if u19 then
			v64:reportRoot(p11, p12)
		end
	end)

	return v64
end
function t14.start(p13) -- line: 531
	-- upvalues: schedulingProfiler (copy), RunService (copy), v4 (copy), u18 (ref)
	p13.started = true
	p13:resetState()
	schedulingProfiler.registerProfilerEventCallback(function(n6: number, p14) -- line: 535
		-- upvalues: p13 (copy)
		p13.schedulerStateMachine:transition(n6, p14)
	end)
	RunService.Heartbeat:Connect(function(dt) -- line: 539
		-- upvalues: p13 (copy), v4 (copy), u18 (ref)
		p13:processFrame(dt * 1000)
		p13.reactFrameTimeMs = 0

		if os.clock() * 1000 - p13.periodStartMs > v4 then
			if u18 then
				p13:reportPeriod()
			end

			p13:resetState()
		end
	end)
end
function t14.resetState(p15) -- line: 554
	p15.periodStartMs = os.clock() * 1000
	p15.frameMetrics = {
		totalFrameCount = 0,
		reactFrameCount = 0,
		totalReactTimeMs = 0,
		totalCorescriptTimeMs = 0,
		maxReactFrameTimeMs = 0,
		allFrameHistogram = {
			0,
			0,
			0,
			0
		},
		reactFrameHistogram = {
			0,
			0,
			0,
			0
		},
		reactDropChangeHistogram = {
			0,
			0,
			0,
			0
		}
	}
	p15.rootsMetrics = {}
end
function t14.getRootName(_, p17) -- line: 571
	if p17 then
		if p17.containerInfo.Name ~= "Folder" then
			return p17.containerInfo.Name
		end

		if p17.current and p17.current.child and p17.current.child.memoizedProps then
			for v69, _ in p17.current.child.memoizedProps do
				if typeof(v69) == "string" then
					return v69
				end
			end
		end
	end

	return "Unknown"
end
function t14.addToFrame(p18, p19) -- line: 588
	p18.reactFrameTimeMs = p18.reactFrameTimeMs + p19
end
function t14.trackSessionSketches(p20, p21, p22) -- line: 592
	-- upvalues: v11 (copy), KllSketch (copy), v10 (copy)
	if not p20.sessionMetrics then
		return
	end

	local v76 = p20:getRootName(p22)

	if p21.tag == "RootUpdateTime" then
		local v77 = os.clock() * 1000 - p21.StartTimeMs

		if v11 then
			table.insert(p20.sessionMetrics.updateTime.allData.all, p21.RenderMs + p21.CommitMs)
			table.insert(p20.sessionMetrics.commitTime.allData.all, p21.CommitMs)
			table.insert(p20.sessionMetrics.timeToUpdate.allData.all, v77)
		end

		p20.sessionMetrics.updateTime.sketches.all:insert(p21.RenderMs + p21.CommitMs)
		p20.sessionMetrics.commitTime.sketches.all:insert(p21.CommitMs)
		p20.sessionMetrics.timeToUpdate.sketches.all:insert(v77)

		if not p20.sessionMetrics.updateTime.sketches[v76] then
			p20.sessionMetrics.updateTime.sketches[v76] = KllSketch.new(v10)

			if v11 then
				p20.sessionMetrics.updateTime.allData[v76] = {}
			end

			local updateTime = p20.sessionMetrics.updateTime

			updateTime.numRoots = updateTime.numRoots + 1
		end

		p20.sessionMetrics.updateTime.sketches[v76]:insert(p21.RenderMs + p21.CommitMs)

		if v11 then
			table.insert(p20.sessionMetrics.updateTime.allData[v76], p21.RenderMs + p21.CommitMs)
		end

		if not p20.sessionMetrics.commitTime.sketches[v76] then
			p20.sessionMetrics.commitTime.sketches[v76] = KllSketch.new(v10)

			if v11 then
				p20.sessionMetrics.commitTime.allData[v76] = {}
			end

			local commitTime = p20.sessionMetrics.commitTime

			commitTime.numRoots = commitTime.numRoots + 1
		end

		p20.sessionMetrics.commitTime.sketches[v76]:insert(p21.CommitMs)

		if v11 then
			table.insert(p20.sessionMetrics.commitTime.allData[v76], p21.CommitMs)
		end

		if not p20.sessionMetrics.timeToUpdate.sketches[v76] then
			p20.sessionMetrics.timeToUpdate.sketches[v76] = KllSketch.new(v10)

			if v11 then
				p20.sessionMetrics.timeToUpdate.allData[v76] = {}
			end

			local timeToUpdate = p20.sessionMetrics.timeToUpdate

			timeToUpdate.numRoots = timeToUpdate.numRoots + 1
		end

		p20.sessionMetrics.timeToUpdate.sketches[v76]:insert(v77)

		if v11 then
			table.insert(p20.sessionMetrics.timeToUpdate.allData[v76], v77)
		end
	end
end
function t14.reportRoot(p23, p24, p25) -- line: 652
	-- upvalues: v12 (copy), v13 (copy), TelemetryService (copy), t13 (copy), v33 (copy)
	local v84 = p23:getRootName(p25)

	if not p23.rootsMetrics[v84] then
		p23.rootsMetrics[v84] = {
			update_count = 0,
			render_total_time_ms = 0,
			commit_total_time_ms = 0,
			max_render_time_ms = 0,
			max_commit_time_ms = 0,
			max_update_time_ms = 0,
			passive_effects_count = 0,
			passive_effects_total_time_ms = 0,
			max_passive_effects_time_ms = 0,
			total_time_to_update_ms = 0,
			max_time_to_update_ms = 0,
			layout_effects_count = if not v12 then nil else 0,
			layout_effects_total_time_ms = if not v12 then nil else 0,
			data_model_update_total_time_ms = if not v12 or not v13 then nil else 0,
			max_layout_effects_time_ms = if not v12 then nil else 0,
			max_data_model_update_time_ms = if not v12 or not v13 then nil else 0
		}
	end

	local v85 = p23.rootsMetrics[v84]

	if p24.tag == "RootPassiveEffectsTime" then
		TelemetryService:LogStat(t13, {
			customFields = {
				updateType = "PassiveEffects",
				rootName = v84,
				deviceTier = v33,
				context = p23.context
			}
		}, p24.PassiveEffectsMs)
		v85.passive_effects_count = v85.passive_effects_count + 1
		v85.passive_effects_total_time_ms = v85.passive_effects_total_time_ms + p24.PassiveEffectsMs

		if p24.PassiveEffectsMs > v85.max_passive_effects_time_ms then
			v85.max_passive_effects_time_ms = p24.PassiveEffectsMs

			return
		end
	elseif p24.tag == "RootUpdateTime" then
		local v86 = os.clock() * 1000 - p24.StartTimeMs

		TelemetryService:LogStat(t13, {
			customFields = {
				updateType = "TimeToComplete",
				rootName = v84,
				deviceTier = v33,
				context = p23.context
			}
		}, v86)
		v85.total_time_to_update_ms = v85.total_time_to_update_ms + v86

		if v86 > v85.max_time_to_update_ms then
			v85.max_time_to_update_ms = v86
		end

		TelemetryService:LogStat(t13, {
			customFields = {
				updateType = "RenderAndCommit",
				rootName = v84,
				deviceTier = v33,
				context = p23.context
			}
		}, p24.RenderMs + p24.CommitMs)
		TelemetryService:LogStat(t13, {
			customFields = {
				updateType = "Commit",
				rootName = v84,
				deviceTier = v33,
				context = p23.context
			}
		}, p24.CommitMs)

		if v12 then
			if p24.LayoutEffectsMs > 0 then
				TelemetryService:LogStat(t13, {
					customFields = {
						updateType = "LayoutEffects",
						rootName = v84,
						deviceTier = v33,
						context = p23.context
					}
				}, p24.LayoutEffectsMs)
			end

			if v13 then
				TelemetryService:LogStat(t13, {
					customFields = {
						updateType = "DataModelUpdate",
						rootName = v84,
						deviceTier = v33,
						context = p23.context
					}
				}, p24.CommitMs - p24.LayoutEffectsMs)
			end
		end

		v85.update_count = v85.update_count + 1

		if p24.RenderMs + p24.CommitMs > v85.max_update_time_ms then
			v85.max_update_time_ms = p24.RenderMs + p24.CommitMs
		end

		v85.render_total_time_ms = v85.render_total_time_ms + p24.RenderMs
		v85.commit_total_time_ms = v85.commit_total_time_ms + p24.CommitMs

		if p24.RenderMs > v85.max_render_time_ms then
			v85.max_render_time_ms = p24.RenderMs
		end

		if p24.CommitMs > v85.max_commit_time_ms then
			v85.max_commit_time_ms = p24.CommitMs
		end

		if v12 then
			if p24.LayoutEffectsMs > 0 then
				v85.layout_effects_count = v85.layout_effects_count + 1
				v85.layout_effects_total_time_ms = v85.layout_effects_total_time_ms + p24.LayoutEffectsMs

				if p24.LayoutEffectsMs > v85.max_layout_effects_time_ms then
					v85.max_layout_effects_time_ms = p24.LayoutEffectsMs
				end
			end

			if v13 then
				v85.data_model_update_total_time_ms = v85.data_model_update_total_time_ms + (p24.CommitMs - p24.LayoutEffectsMs)

				if p24.CommitMs - p24.LayoutEffectsMs > v85.max_data_model_update_time_ms then
					v85.max_data_model_update_time_ms = p24.CommitMs - p24.LayoutEffectsMs
				end
			end
		end
	end
end
function t14.getFrameBucket(_: {[any]: any}, n7: number) -- line: 791
	return (math.min(4, math.floor(math.max(0, n7 - 2) / 16.666666666666668) + 1))
end
function t14.processFrame(t22: {[any]: any}, n8: number) -- line: 798
	-- upvalues: EngineFeature3 (copy), v15 (copy), RunService (copy), v11 (copy)
	local frameMetrics = t22.frameMetrics
	local reactFrameTimeMs = t22.reactFrameTimeMs

	if EngineFeature3 and v15 then
		local TotalScriptPlusExecutionTime = RunService:GetTotalScriptPlusExecutionTime()

		if TotalScriptPlusExecutionTime > 0 then
			frameMetrics.totalCorescriptTimeMs = frameMetrics.totalCorescriptTimeMs + TotalScriptPlusExecutionTime
		end
	end

	frameMetrics.totalFrameCount = frameMetrics.totalFrameCount + 1

	local v94 = t22:getFrameBucket(n8)
	local allFrameHistogram = frameMetrics.allFrameHistogram

	allFrameHistogram[v94] = allFrameHistogram[v94] + 1
	t22.sessionMetrics.timePerFrame.sketch:insert(reactFrameTimeMs)

	if v11 then
		table.insert(t22.sessionMetrics.timePerFrame.allData, reactFrameTimeMs)
	end

	if reactFrameTimeMs > 0 then
		frameMetrics.totalReactTimeMs = frameMetrics.totalReactTimeMs + reactFrameTimeMs

		local reactFrameHistogram = frameMetrics.reactFrameHistogram

		reactFrameHistogram[v94] = reactFrameHistogram[v94] + 1
		t22.sessionMetrics.timePerReactFrame.sketch:insert(reactFrameTimeMs)

		if v11 then
			table.insert(t22.sessionMetrics.timePerReactFrame.allData, reactFrameTimeMs)
		end

		frameMetrics.reactFrameCount = frameMetrics.reactFrameCount + 1

		if reactFrameTimeMs > frameMetrics.maxReactFrameTimeMs then
			frameMetrics.maxReactFrameTimeMs = reactFrameTimeMs
		end

		local v97 = v94 - t22:getFrameBucket(n8 - reactFrameTimeMs)
		local reactDropChangeHistogram = frameMetrics.reactDropChangeHistogram
		local v99 = v97 + 1

		reactDropChangeHistogram[v99] = reactDropChangeHistogram[v99] + 1
	end
end
function t14.reportPeriod(p26) -- line: 837
	-- upvalues: TelemetryService (copy), t6 (copy), t3 (ref), t7 (copy), v33 (copy), EngineFeature3 (copy), v15 (copy), t8 (copy), v12 (copy), v13 (copy), t9 (copy), v6 (copy), t10 (ref), t11 (copy), v7 (copy), t12 (ref)
	local frameMetrics = p26.frameMetrics
	local v102 = os.clock() * 1000 - p26.periodStartMs
	local t23 = {
		period_length_ms = v102,
		react_total_time_ms = frameMetrics.totalReactTimeMs,
		react_total_time_pct = frameMetrics.totalReactTimeMs / v102,
		react_frame_count = frameMetrics.reactFrameCount,
		total_frame_count = frameMetrics.totalFrameCount,
		corescript_total_time_ms = frameMetrics.totalCorescriptTimeMs,
		corescript_total_time_pct = frameMetrics.totalCorescriptTimeMs / v102,
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

	TelemetryService:LogEvent(t6, {
		standardizedFields = t3,
		customFields = t23
	})
	TelemetryService:LogStat(t7, {
		customFields = {
			stat = "ReactTotalTimePct",
			context = p26.context,
			deviceTier = v33
		}
	}, t23.react_total_time_pct)

	if EngineFeature3 and v15 then
		TelemetryService:LogStat(t7, {
			customFields = {
				stat = "TotalCorescriptTimePct",
				context = p26.context,
				deviceTier = v33
			}
		}, t23.corescript_total_time_pct)
	end

	TelemetryService:LogStat(t7, {
		customFields = {
			stat = "AverageReactAllFrameMs",
			context = p26.context,
			deviceTier = v33
		}
	}, t23.average_react_all_frame_ms)
	TelemetryService:LogStat(t7, {
		customFields = {
			stat = "AverageReactOnlyFrameMs",
			context = p26.context,
			deviceTier = v33
		}
	}, t23.average_react_only_frame_ms)
	TelemetryService:LogStat(t7, {
		customFields = {
			stat = "MaxReactFrameMs",
			context = p26.context,
			deviceTier = v33
		}
	}, t23.max_react_frame_ms)

	for i = 1, 4 do
		local v105 = i - 1

		TelemetryService:LogCounter(t8, {
			customFields = {
				category = "AllFrame",
				bucket = v105,
				context = p26.context,
				deviceTier = v33
			}
		}, frameMetrics.allFrameHistogram[i])
		TelemetryService:LogCounter(t8, {
			customFields = {
				category = "ReactFrame",
				bucket = v105,
				context = p26.context,
				deviceTier = v33
			}
		}, frameMetrics.reactFrameHistogram[i])
		TelemetryService:LogCounter(t8, {
			customFields = {
				category = "ReactDropChange",
				bucket = v105,
				context = p26.context,
				deviceTier = v33
			}
		}, frameMetrics.reactDropChangeHistogram[i])
	end

	for v106, v107 in p26.rootsMetrics do
		v107.root_name = v106
		v107.update_total_time_ms = v107.render_total_time_ms + v107.commit_total_time_ms
		v107.total_time_ms = v107.update_total_time_ms + v107.passive_effects_total_time_ms
		v107.avg_render_time_ms = v107.render_total_time_ms / v107.update_count
		v107.context = p26.context
		v107.total_time_pct = (v107.update_total_time_ms + v107.passive_effects_total_time_ms) / t23.react_total_time_ms
		v107.avg_update_time_ms = v107.update_total_time_ms / v107.update_count
		v107.avg_commit_time_ms = v107.commit_total_time_ms / v107.update_count

		if v12 then
			v107.avg_layout_effects_time_ms = v107.layout_effects_total_time_ms / v107.layout_effects_count

			if v13 then
				v107.avg_data_model_update_time_ms = v107.data_model_update_total_time_ms / v107.update_count
			end
		end

		v107.avg_passive_effects_time_ms = v107.passive_effects_total_time_ms / v107.passive_effects_count
		v107.avg_time_to_update_ms = v107.total_time_to_update_ms / v107.update_count
		TelemetryService:LogEvent(t9, {
			standardizedFields = t3,
			customFields = v107
		})

		if not v6 then
			TelemetryService:LogStat(t10, {
				customFields = {
					stat = "TotalTimePct",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.total_time_pct)
		end

		TelemetryService:LogCounter(t11, {
			customFields = {
				task = "RenderAndCommit",
				rootName = v107.root_name,
				deviceTier = v33,
				context = p26.context
			}
		}, v107.update_count)

		if v12 then
			TelemetryService:LogCounter(t11, {
				customFields = {
					task = "LayoutEffects",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.layout_effects_count)
		end

		TelemetryService:LogCounter(t11, {
			customFields = {
				task = "PassiveEffects",
				rootName = v107.root_name,
				deviceTier = v33,
				context = p26.context
			}
		}, v107.passive_effects_count)

		if not v7 then
			TelemetryService:LogStat(t12, {
				customFields = {
					task = "RenderAndCommit",
					stat = "AvgMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.avg_update_time_ms)
			TelemetryService:LogStat(t12, {
				customFields = {
					task = "Commit",
					stat = "AvgMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.avg_commit_time_ms)

			if v12 then
				TelemetryService:LogStat(t12, {
					customFields = {
						task = "LayoutEffects",
						stat = "AvgMs",
						rootName = v107.root_name,
						deviceTier = v33,
						context = p26.context
					}
				}, v107.avg_layout_effects_time_ms)

				if v13 then
					TelemetryService:LogStat(t12, {
						customFields = {
							task = "DataModelUpdate",
							stat = "AvgMs",
							rootName = v107.root_name,
							deviceTier = v33,
							context = p26.context
						}
					}, v107.avg_data_model_update_time_ms)
				end
			end

			TelemetryService:LogStat(t12, {
				customFields = {
					task = "TimeToUpdateMs",
					stat = "AvgMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.avg_time_to_update_ms)
			TelemetryService:LogStat(t12, {
				customFields = {
					task = "PassiveEffects",
					stat = "AvgMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.avg_passive_effects_time_ms)
			TelemetryService:LogStat(t12, {
				customFields = {
					task = "RenderAndCommit",
					stat = "MaxMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.max_update_time_ms)
			TelemetryService:LogStat(t12, {
				customFields = {
					task = "Commit",
					stat = "MaxMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.max_commit_time_ms)

			if v12 then
				TelemetryService:LogStat(t12, {
					customFields = {
						task = "LayoutEffects",
						stat = "MaxMs",
						rootName = v107.root_name,
						deviceTier = v33,
						context = p26.context
					}
				}, v107.max_layout_effects_time_ms)

				if v13 then
					TelemetryService:LogStat(t12, {
						customFields = {
							task = "DataModelUpdate",
							stat = "MaxMs",
							rootName = v107.root_name,
							deviceTier = v33,
							context = p26.context
						}
					}, v107.max_data_model_update_time_ms)
				end
			end

			TelemetryService:LogStat(t12, {
				customFields = {
					task = "TimeToUpdateMs",
					stat = "MaxMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.max_time_to_update_ms)
			TelemetryService:LogStat(t12, {
				customFields = {
					task = "PassiveEffects",
					stat = "MaxMs",
					rootName = v107.root_name,
					deviceTier = v33,
					context = p26.context
				}
			}, v107.max_passive_effects_time_ms)
		end
	end
end
function generatePercentilesFromSingleSketch(p27) -- line: 1141
	-- upvalues: parts (copy)
	local s2 = "{"

	for v110, v111 in parts do
		s2 = (s2 .. "\"p" .. v111 .. "\":") .. p27:getPercentile(tonumber(v111) or 0)

		if v110 < #parts then
			s2 ..= ","
		end
	end

	return s2 .. "}"
end
function generatePercentilesFromSketches(t24: {[any]: any}, n9: number) -- line: 1155
	-- upvalues: parts (copy)
	local s3 = "{"

	for v115, v116 in parts do
		local v117 = s3 .. "\"p" .. v116 .. "\":{"
		local v118 = tonumber(v116) or 0
		local n10 = 0

		for v120, v121 in t24 do
			n10 += 1
			v117 ..= "\"" .. v120 .. "\":" .. v121:getPercentile(v118)

			if n10 < n9 then
				v117 ..= ","
			end
		end

		s3 = v117 .. (not (v115 < #parts) and "}" or "},")
	end

	return s3 .. "}"
end
function t14.reportPercentError(p28, p29, p30, p31, p32) -- line: 1175
	-- upvalues: parts (copy), TelemetryService (copy), t5 (ref), t3 (ref)
	table.sort(p29)

	local v127 = #p29

	if v127 < 1 then
		return
	end

	for _, v129 in parts do
		local v130 = p29[math.ceil((tonumber(v129) or 0) / 100 * v127)]
		local v131 = if not p30.sketches then p30.sketch:getPercentile(v129) else p30.sketches[p32]:getPercentile(v129)
		local n11 = 0

		if v130 ~= 0 or v131 == 0 then
			if v130 ~= 0 then
				n11 = (v131 - v130) * 100 / v130
			end

			local t25 = {
				rootName = p32,
				percentile = v129,
				metric = p31,
				numDatapoints = v127,
				context = p28.context,
				approxError = n11
			}

			TelemetryService:LogEvent(t5, {
				standardizedFields = t3,
				customFields = t25
			})
		end
	end
end
function t14.reportSession(p33) -- line: 1215
	-- upvalues: v11 (copy), TelemetryService (copy), t4 (copy), t3 (ref)
	if not p33.started then
		return
	end

	local v135 = generatePercentilesFromSketches(p33.sessionMetrics.updateTime.sketches, p33.sessionMetrics.updateTime.numRoots)
	local v136 = generatePercentilesFromSketches(p33.sessionMetrics.commitTime.sketches, p33.sessionMetrics.commitTime.numRoots)
	local v137 = generatePercentilesFromSketches(p33.sessionMetrics.timeToUpdate.sketches, p33.sessionMetrics.timeToUpdate.numRoots)
	local v138 = generatePercentilesFromSingleSketch(p33.sessionMetrics.timePerFrame.sketch)
	local v139 = generatePercentilesFromSingleSketch(p33.sessionMetrics.timePerReactFrame.sketch)
	local t26 = {
		reactUpdateTime = v135,
		reactCommitTime = v136,
		reactTimeToUpdate = v137,
		timePerFrame = v138,
		timePerReactFrame = v139
	}

	if v11 then
		for v141, v142 in p33.sessionMetrics do
			if v142.sketches then
				for v143, v144 in v142.allData do
					p33:reportPercentError(v144, v142, v141, v143)
				end
			else
				p33:reportPercentError(v142.allData, v142, v141, "all")
			end
		end
	end

	TelemetryService:LogEvent(t4, {
		standardizedFields = t3,
		customFields = t26
	})
end

return (t14.new(FStringReactSchedulingContext))
