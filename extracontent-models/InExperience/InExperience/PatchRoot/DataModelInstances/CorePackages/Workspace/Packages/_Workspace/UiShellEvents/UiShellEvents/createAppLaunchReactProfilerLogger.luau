local TelemetryService = game:GetService("TelemetryService")

local parent = script.Parent.Parent
require(parent.AppCommonLib)
local LoggingProtocol = require(parent.LoggingProtocol)
local RoactUtils = require(parent.RoactUtils)
local isReactProfilingEnabled = RoactUtils.Profiling.isReactProfilingEnabled

local defineFastFlag = game:DefineFastFlag("SupportTerminalMilestoneInReactProfilerLogger", false)

local defineFastInt = game:DefineFastInt("AppLaunchReactProfilerLoggerCollectionTimeoutSec", 30)
local defineFastString = game:DefineFastString(
	"SupportedAppLaunchMilestonesForReactProfilerLogger",
	"lua_app_starter_script_requires_end,fetch_homepage_data_begin,fetch_homepage_data_end,home_page_interactive"
)

local function getSupportedMilestones() -- 1 equivalent call inferred from this helper
	local parts = defineFastString:split(",")
	local partSet = {}

	for _, part in parts do
		partSet[part] = true
	end

	return partSet
end

local v = {
	eventName = "AppLaunchReactProfilerUpdateCount",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v2 = {
	eventName = "AppLaunchReactProfilerRenderDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v3 = {
	eventName = "AppLaunchReactProfilerCommitDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v4 = {
	eventName = "AppLaunchReactProfilerExclusiveRenderDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v5 = {
	eventName = "AppLaunchReactProfilerExclusiveCommitDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local function logProfilerData(items)
	if next(items) == nil then
		return
	end

	for _, item in items do
		TelemetryService:LogStat(v, {
			customFields = { profilerId = item.profilerId, milestoneName = item.milestoneName }
		}, item.updateCount)
		TelemetryService:LogStat(v2, {
			customFields = { profilerId = item.profilerId, milestoneName = item.milestoneName }
		}, item.renderDuration)
		TelemetryService:LogStat(v3, {
			customFields = { profilerId = item.profilerId, milestoneName = item.milestoneName }
		}, item.commitDuration)
		TelemetryService:LogStat(v4, {
			customFields = { profilerId = item.profilerId, milestoneName = item.milestoneName }
		}, item.exclusiveRenderDuration)
		TelemetryService:LogStat(v5, {
			customFields = { profilerId = item.profilerId, milestoneName = item.milestoneName }
		}, item.exclusiveCommitDuration)
	end
end

local function createProfilerData(k: string, eventName: string) -- 2 equivalent calls inferred from this helper
	return {
		profilerId = k,
		milestoneName = eventName,
		updateCount = 0,
		renderDuration = 0,
		commitDuration = 0,
		exclusiveRenderDuration = 0,
		exclusiveCommitDuration = 0
	}
end

local function updateProfilerData(state, p) -- 2 equivalent calls inferred from this helper
	state.updateCount += 1
	state.renderDuration += p.render.duration
	state.commitDuration += p.commit.duration
	state.exclusiveRenderDuration += p.render.exclusiveDuration
	state.exclusiveCommitDuration += p.commit.exclusiveDuration
end

local function createAppLaunchReactProfilerLogger(p, p2: string?)
	if not isReactProfilingEnabled then
		return
	end

	local eventsForProfilers = {}

	local v6 = {}

	local function correlateProfilerData()
		local result = {}

		for k, v7 in eventsForProfilers do
			local v8 = #v7
			local v9 = #v6
			local v10 = 1
			local v11 = 1
			local v12 = nil
			local profilerData = createProfilerData(k, "aggregate") -- inferred equivalent call

			while v10 <= v8 and v11 <= v9 do
				local v13 = v7[v10]
				local v14 = v6[v11]
				v12 = v12 == nil and createProfilerData(k, v14.eventName) or v12 -- inferred equivalent call

				if v13.render.startTime < v14.eventTime then
					updateProfilerData(v12, v13) -- inferred equivalent call
					updateProfilerData(profilerData, v13) -- inferred equivalent call
					v10 += 1
				else
					if v12.updateCount > 0 then
						table.insert(result, v12)
					end

					v11 += 1
					v12 = nil
				end
			end

			if v12 and v12.updateCount > 0 then
				table.insert(result, v12)
			end

			if profilerData.updateCount > 0 then
				table.insert(result, profilerData)
			end
		end

		eventsForProfilers = {}
		v6 = {}

		return result
	end

	local function getOrCreateEventsForProfiler(profilerId: string) -- 2 equivalent calls inferred from this helper
		local eventsForProfiler = eventsForProfilers[profilerId]

		if eventsForProfiler == nil then
			eventsForProfiler = {}
			eventsForProfilers[profilerId] = eventsForProfiler
		end

		return eventsForProfiler
	end

	local onRenderConnection = p.onRender:connect(function(render)
		table.insert(getOrCreateEventsForProfiler(render.profilerId), { -- inferred equivalent call
			render = render,
			commit = {
				profilerId = render.profilerId,
				commitTime = render.commitTime,
				duration = 0,
				exclusiveDuration = 0
			}
		})
	end)

	local onCommitConnection = p.onCommit:connect(function(commit)
		local eventsForProfiler = getOrCreateEventsForProfiler(commit.profilerId) -- inferred equivalent call
		local v7 = eventsForProfiler[#eventsForProfiler]

		if v7 == nil or v7.render.commitTime ~= commit.commitTime then
			warn("Profiler invariants are broken")
		else
			v7.commit = commit
		end
	end)

	local v7 = nil

	if defineFastFlag then
		local supportedMilestones = getSupportedMilestones() -- inferred equivalent call
		v7 = LoggingProtocol.default:setDurationLoggerListener(function(eventName: string)
			if supportedMilestones[eventName] then
				local eventTime = os.clock() * 1000
				table.insert(v6, { eventName = eventName, eventTime = eventTime })
			end

			if p2 ~= nil and eventName == p2 and v7 ~= nil then
				v7:disconnect()
				v7 = nil
			end
		end)
	else
		v7 = LoggingProtocol.default:setDurationLoggerListener(function(eventName: string)
			local eventTime = os.clock() * 1000
			table.insert(v6, { eventName = eventName, eventTime = eventTime })
		end)
	end

	local function disconnectListeners() -- 1 equivalent call inferred from this helper
		if onRenderConnection ~= nil then
			onRenderConnection:disconnect()
			onRenderConnection = nil
		end

		if onCommitConnection ~= nil then
			onCommitConnection:disconnect()
			onCommitConnection = nil
		end

		if v7 ~= nil then
			v7:disconnect()
			v7 = nil
		end
	end

	task.delay(defineFastInt, function()
		disconnectListeners() -- inferred equivalent call
		logProfilerData(correlateProfilerData())
	end)
end

return createAppLaunchReactProfilerLogger
