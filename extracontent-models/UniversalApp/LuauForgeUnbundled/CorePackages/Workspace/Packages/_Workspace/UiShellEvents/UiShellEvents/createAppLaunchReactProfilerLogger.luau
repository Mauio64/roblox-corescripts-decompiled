local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/AppCommonLib")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/LoggingProtocol")
local isReactProfilingEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/RoactUtils").Profiling.isReactProfilingEnabled

local defineFastFlag = game:DefineFastFlag("SupportTerminalMilestoneInReactProfilerLogger", false)

local defineFastInt = game:DefineFastInt("AppLaunchReactProfilerLoggerCollectionTimeoutSec", 30)
local defineFastString = game:DefineFastString(
	"SupportedAppLaunchMilestonesForReactProfilerLogger",
	"lua_app_starter_script_requires_end,fetch_homepage_data_begin,fetch_homepage_data_end,home_page_interactive"
)

local function getSupportedMilestones()
	local parts = defineFastString:split(",")
	local partSet = {}

	for k, part in parts do
		partSet[part] = true
	end

	return partSet
end

local v5 = {
	eventName = "AppLaunchReactProfilerUpdateCount",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v6 = {
	eventName = "AppLaunchReactProfilerRenderDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v7 = {
	eventName = "AppLaunchReactProfilerCommitDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v8 = {
	eventName = "AppLaunchReactProfilerExclusiveRenderDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local v9 = {
	eventName = "AppLaunchReactProfilerExclusiveCommitDuration",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2025, 2, 25 },
	throttlingPercentage = 0
}

local function logProfilerData(items)
	if next(items) == nil then
		return
	end

	for k, item in items do
		TelemetryService:LogStat(v5, {
			customFields = {
				profilerId = item.profilerId,
				milestoneName = item.milestoneName
			}
		}, item.updateCount)
		TelemetryService:LogStat(v6, {
			customFields = {
				profilerId = item.profilerId,
				milestoneName = item.milestoneName
			}
		}, item.renderDuration)
		TelemetryService:LogStat(v7, {
			customFields = {
				profilerId = item.profilerId,
				milestoneName = item.milestoneName
			}
		}, item.commitDuration)
		TelemetryService:LogStat(v8, {
			customFields = {
				profilerId = item.profilerId,
				milestoneName = item.milestoneName
			}
		}, item.exclusiveRenderDuration)
		TelemetryService:LogStat(v9, {
			customFields = {
				profilerId = item.profilerId,
				milestoneName = item.milestoneName
			}
		}, item.exclusiveCommitDuration)
	end
end

local function createProfilerData(p2, p3)
	return {
		profilerId = p2,
		milestoneName = p3,
		updateCount = 0,
		renderDuration = 0,
		commitDuration = 0,
		exclusiveRenderDuration = 0,
		exclusiveCommitDuration = 0
	}
end

local function updateProfilerData(state, p2)
	state.updateCount += 1
	state.renderDuration += p2.render.duration
	state.commitDuration += p2.commit.duration
	state.exclusiveRenderDuration += p2.render.exclusiveDuration
	state.exclusiveCommitDuration += p2.commit.exclusiveDuration
end

local function createAppLaunchReactProfilerLogger(p2, p3)
	if not isReactProfilingEnabled then
		return
	end

	local v10 = {}

	local v11 = {}

	local function correlateProfilerData()
		local result = {}

		for k, v12 in v10 do
			local v13 = #v12
			local v14 = #v11
			local v15 = 1
			local v16 = 1
			local v17 = nil
			local v18 = {
				profilerId = k,
				milestoneName = "aggregate",
				updateCount = 0,
				renderDuration = 0,
				commitDuration = 0,
				exclusiveRenderDuration = 0,
				exclusiveCommitDuration = 0
			}

			while v15 <= v13 and v16 <= v14 do
				local v19 = v12[v15]
				local v20 = v11[v16]
				v17 = v17 == nil and {
					profilerId = k,
					milestoneName = v20.eventName,
					updateCount = 0,
					renderDuration = 0,
					commitDuration = 0,
					exclusiveRenderDuration = 0,
					exclusiveCommitDuration = 0
				} or v17

				if v19.render.startTime < v20.eventTime then
					v17.updateCount += 1
					v17.renderDuration += v19.render.duration
					v17.commitDuration += v19.commit.duration
					v17.exclusiveRenderDuration += v19.render.exclusiveDuration
					v17.exclusiveCommitDuration += v19.commit.exclusiveDuration
					v18.updateCount += 1
					v18.renderDuration += v19.render.duration
					v18.commitDuration += v19.commit.duration
					v18.exclusiveRenderDuration += v19.render.exclusiveDuration
					v18.exclusiveCommitDuration += v19.commit.exclusiveDuration

					v15 += 1
				else
					if v17.updateCount > 0 then
						table.insert(result, v17)
					end

					v16 += 1
					v17 = nil
				end
			end

			if v17 and v17.updateCount > 0 then
				table.insert(result, v17)
			end

			if v18.updateCount > 0 then
				table.insert(result, v18)
			end
		end

		v10 = {}
		v11 = {}

		return result
	end

	local function getOrCreateEventsForProfiler(p4)
		local eventsForProfiler = v10[p4]

		if eventsForProfiler == nil then
			eventsForProfiler = {}
			v10[p4] = eventsForProfiler
		end

		return eventsForProfiler
	end

	local onRenderConnection = p2.onRender:connect(function(p4)
		local profilerId = p4.profilerId
		local v12 = v10[profilerId]

		if v12 == nil then
			v12 = {}
			v10[profilerId] = v12
		end

		table.insert(v12, {
			render = p4,
			commit = {
				profilerId = p4.profilerId,
				commitTime = p4.commitTime,
				duration = 0,
				exclusiveDuration = 0
			}
		})
	end)

	local onCommitConnection = p2.onCommit:connect(function(commit)
		local profilerId = commit.profilerId
		local v12 = v10[profilerId]

		if v12 == nil then
			v12 = {}
			v10[profilerId] = v12
		end

		local v13 = v12[#v12]

		if v13 == nil or v13.render.commitTime ~= commit.commitTime then
			warn("Profiler invariants are broken")
		else
			v13.commit = commit
		end
	end)

	local v12 = nil

	if defineFastFlag then
		local parts = defineFastString:split(",")
		local partSet = {}

		for k, part in parts do
			partSet[part] = true
		end

		v12 = LoggingProtocol.default:setDurationLoggerListener(function(p4)
			if partSet[p4] then
				local v13 = os.clock() * 1000
				table.insert(v11, { eventName = p4, eventTime = v13 })
			end

			if p3 ~= nil and p4 == p3 and v12 ~= nil then
				v12:disconnect()
				v12 = nil
			end
		end)
	else
		v12 = LoggingProtocol.default:setDurationLoggerListener(function(p4)
			local v13 = os.clock() * 1000
			table.insert(v11, { eventName = p4, eventTime = v13 })
		end)
	end

	local function disconnectListeners()
		if onRenderConnection ~= nil then
			onRenderConnection:disconnect()
			onRenderConnection = nil
		end

		if onCommitConnection ~= nil then
			onCommitConnection:disconnect()
			onCommitConnection = nil
		end

		if v12 ~= nil then
			v12:disconnect()
			v12 = nil
		end
	end

	task.delay(defineFastInt, function()
		if onRenderConnection ~= nil then
			onRenderConnection:disconnect()
			onRenderConnection = nil
		end

		if onCommitConnection ~= nil then
			onCommitConnection:disconnect()
			onCommitConnection = nil
		end

		if v12 ~= nil then
			v12:disconnect()
			v12 = nil
		end

		logProfilerData(correlateProfilerData())
	end)
end

return createAppLaunchReactProfilerLogger
