local TelemetryService = game:GetService("TelemetryService")
local ParentParent = script.Parent.Parent

require(ParentParent.AppCommonLib)

local LoggingProtocol = require(ParentParent.LoggingProtocol)
local isReactProfilingEnabled = require(ParentParent.RoactUtils).Profiling.isReactProfilingEnabled
local v5 = game:DefineFastFlag("SupportTerminalMilestoneInReactProfilerLogger", false)
local v6 = game:DefineFastInt("AppLaunchReactProfilerLoggerCollectionTimeoutSec", 30)
local v7 = game:DefineFastString("SupportedAppLaunchMilestonesForReactProfilerLogger", "lua_app_starter_script_requires_end,fetch_homepage_data_begin,fetch_homepage_data_end,home_page_interactive")

local function getSupportedMilestones() -- line: 20
	-- upvalues: v7 (copy)
	local t1 = {}

	for _, v20 in (v7:split(",")) do
		t1[v20] = true
	end

	return t1
end

local t2 = {
	eventName = "AppLaunchReactProfilerUpdateCount",
	throttlingPercentage = 0,
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		25
	}
}
local t3 = {
	eventName = "AppLaunchReactProfilerRenderDuration",
	throttlingPercentage = 0,
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		25
	}
}
local t4 = {
	eventName = "AppLaunchReactProfilerCommitDuration",
	throttlingPercentage = 0,
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		25
	}
}
local t5 = {
	eventName = "AppLaunchReactProfilerExclusiveRenderDuration",
	throttlingPercentage = 0,
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		25
	}
}
local t6 = {
	eventName = "AppLaunchReactProfilerExclusiveCommitDuration",
	throttlingPercentage = 0,
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2025,
		2,
		25
	}
}

local function logProfilerData(t7: {[any]: any}) -- line: 81
	-- upvalues: TelemetryService (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
	if next(t7) == nil then
		return
	end

	for _, v23 in t7 do
		TelemetryService:LogStat(t2, {
			customFields = {
				profilerId = v23.profilerId,
				milestoneName = v23.milestoneName
			}
		}, v23.updateCount)
		TelemetryService:LogStat(t3, {
			customFields = {
				profilerId = v23.profilerId,
				milestoneName = v23.milestoneName
			}
		}, v23.renderDuration)
		TelemetryService:LogStat(t4, {
			customFields = {
				profilerId = v23.profilerId,
				milestoneName = v23.milestoneName
			}
		}, v23.commitDuration)
		TelemetryService:LogStat(t5, {
			customFields = {
				profilerId = v23.profilerId,
				milestoneName = v23.milestoneName
			}
		}, v23.exclusiveRenderDuration)
		TelemetryService:LogStat(t6, {
			customFields = {
				profilerId = v23.profilerId,
				milestoneName = v23.milestoneName
			}
		}, v23.exclusiveCommitDuration)
	end
end
local function createProfilerData(s1: string, s2: string) -- line: 120
	return {
		updateCount = 0,
		renderDuration = 0,
		commitDuration = 0,
		exclusiveRenderDuration = 0,
		exclusiveCommitDuration = 0,
		profilerId = s1,
		milestoneName = s2
	}
end
local function updateProfilerData(t8: {[any]: any}, t9: {[any]: any}) -- line: 133
	t8.updateCount = t8.updateCount + 1
	t8.renderDuration = t8.renderDuration + t9.render.duration
	t8.commitDuration = t8.commitDuration + t9.commit.duration
	t8.exclusiveRenderDuration = t8.exclusiveRenderDuration + t9.render.exclusiveDuration
	t8.exclusiveCommitDuration = t8.exclusiveCommitDuration + t9.commit.exclusiveDuration
end
local function createAppLaunchReactProfilerLogger(p1, s3: string?) -- line: 141
	-- upvalues: isReactProfilingEnabled (copy), v5 (copy), v7 (copy), LoggingProtocol (copy), v6 (copy), logProfilerData (copy)
	if not isReactProfilingEnabled then
		return
	end

	local t10 = {}
	local t11 = {}

	local function correlateProfilerData() -- line: 153
		-- upvalues: t10 (ref), t11 (ref)
		local t12 = {}

		for v43, v44 in t10 do
			local v45 = #v44
			local v46 = #t11
			local n1 = 1
			local n2 = 1
			local t14 = nil
			local t13 = {
				milestoneName = "aggregate",
				updateCount = 0,
				renderDuration = 0,
				commitDuration = 0,
				exclusiveRenderDuration = 0,
				exclusiveCommitDuration = 0,
				profilerId = v43
			}

			while n1 <= v45 and n2 <= v46 do
				local v51 = v44[n1]
				local v52 = t11[n2]

				if t14 == nil then
					local eventName = v52.eventName

					t14 = {
						updateCount = 0,
						renderDuration = 0,
						commitDuration = 0,
						exclusiveRenderDuration = 0,
						exclusiveCommitDuration = 0,
						profilerId = v43,
						milestoneName = eventName
					}
				end

				if v51.render.startTime < v52.eventTime then
					t14.updateCount = t14.updateCount + 1
					t14.renderDuration = t14.renderDuration + v51.render.duration
					t14.commitDuration = t14.commitDuration + v51.commit.duration
					t14.exclusiveRenderDuration = t14.exclusiveRenderDuration + v51.render.exclusiveDuration
					t14.exclusiveCommitDuration = t14.exclusiveCommitDuration + v51.commit.exclusiveDuration
					t13.updateCount = t13.updateCount + 1
					t13.renderDuration = t13.renderDuration + v51.render.duration
					t13.commitDuration = t13.commitDuration + v51.commit.duration
					t13.exclusiveRenderDuration = t13.exclusiveRenderDuration + v51.render.exclusiveDuration
					t13.exclusiveCommitDuration = t13.exclusiveCommitDuration + v51.commit.exclusiveDuration
					n1 += 1
				else
					if t14.updateCount > 0 then
						table.insert(t12, t14)
					end

					n2 += 1
					t14 = nil
				end
			end

			if t14 and t14.updateCount > 0 then
				table.insert(t12, t14)
			end

			if t13.updateCount > 0 then
				table.insert(t12, t13)
			end
		end

		t10 = {}
		t11 = {}

		return t12
	end
	local function getOrCreateEventsForProfiler(s4: string) -- line: 208
		-- upvalues: t10 (ref)
		local v55 = t10[s4]

		if v55 == nil then
			v55 = {}
			t10[s4] = v55
		end

		return v55
	end

	local u34 = p1.onRender:connect(function(p2) -- line: 218
		-- upvalues: t10 (ref)
		local profilerId = p2.profilerId
		local v58 = t10[profilerId]

		if v58 == nil then
			v58 = {}
			t10[profilerId] = v58
		end

		table.insert(v58, {
			render = p2,
			commit = {
				duration = 0,
				exclusiveDuration = 0,
				profilerId = p2.profilerId,
				commitTime = p2.commitTime
			}
		})
	end)
	local u35 = p1.onCommit:connect(function(p3) -- line: 234
		-- upvalues: t10 (ref)
		local profilerId = p3.profilerId
		local v61 = t10[profilerId]

		if v61 == nil then
			v61 = {}
			t10[profilerId] = v61
		end

		local v62 = v61[#v61]

		if v62 ~= nil and v62.render.commitTime == p3.commitTime then
			v62.commit = p3

			return
		end

		warn("Profiler invariants are broken")
	end)
	local u36 = nil

	if v5 then
		local t15 = {}

		for _, v39 in (v7:split(",")) do
			t15[v39] = true
		end

		local v40 = t15

		u36 = LoggingProtocol.default:setDurationLoggerListener(function(s5: string) -- line: 249
			-- upvalues: v40 (copy), t11 (ref), s3 (copy), u36 (ref)
			if v40[s5] then
				local v64 = os.clock() * 1000

				table.insert(t11, {
					eventName = s5,
					eventTime = v64
				})
			end

			if s3 ~= nil and s5 == s3 and u36 ~= nil then
				u36:disconnect()
				u36 = nil
			end
		end)
	else
		u36 = LoggingProtocol.default:setDurationLoggerListener(function(s6: string) -- line: 266
			-- upvalues: t11 (ref)
			local v66 = os.clock() * 1000

			table.insert(t11, {
				eventName = s6,
				eventTime = v66
			})
		end)
	end

	local function disconnectListeners() -- line: 275
		-- upvalues: u34 (ref), u35 (ref), u36 (ref)
		if u34 ~= nil then
			u34:disconnect()
			u34 = nil
		end

		if u35 ~= nil then
			u35:disconnect()
			u35 = nil
		end

		if u36 ~= nil then
			u36:disconnect()
			u36 = nil
		end
	end

	task.delay(v6, function() -- line: 290
		-- upvalues: u34 (ref), u35 (ref), u36 (ref), correlateProfilerData (copy), logProfilerData (copy)
		if u34 ~= nil then
			u34:disconnect()
			u34 = nil
		end

		if u35 ~= nil then
			u35:disconnect()
			u35 = nil
		end

		if u36 ~= nil then
			u36:disconnect()
			u36 = nil
		end

		local v67 = correlateProfilerData()

		logProfilerData(v67)
	end)
end

return createAppLaunchReactProfilerLogger
