local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local LoggingProtocol = require(SduiCoreSystemParent.LoggingProtocol)
local tutils = require(SduiCoreSystemParent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiErrors)

local v6 = game:DefineFastInt("DiscoverySduiErrorHundredthsPercent", 0)
local v7 = game:DefineFastInt("DiscoverySduiTimerEventsHundredthsPercent", 0)
local v8 = game:DefineFastInt("DiscoveryFeedStatsHundredthsPercent", 0)
local v9 = game:DefineFastFlag("LuaAppSduiErrorPage", false)
local t1 = {
	eventName = "DiscoverySdui_ErrorDetails",
	description = "Error details related to discovery server-driven ui",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v6,
	lastUpdated = {
		24,
		11,
		4
	}
}
local t2 = {
	eventName = "DiscoverySdui_ErrorCounter",
	throttlingPercentage = 0,
	description = "Error related to discovery server-driven ui",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		24,
		12,
		14
	}
}
local t3 = {
	eventName = "DiscoverySdui_Timers",
	description = "Timers related to discovery server-driven ui",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v7,
	lastUpdated = {
		25,
		3,
		14
	}
}
local t4 = {
	eventName = "DiscoverySdui_FeedStats",
	description = "Stats for feed response. Number of items per collection",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v8,
	lastUpdated = {
		25,
		5,
		27
	}
}

local function makeErrorKey(p1, p2) -- line: 70
	return `{ p1 }_{ p2.name }_{ p2.componentType }_{ p2.parserName }_{ p2.propName }`
end

local t5 = {}

return {
	clearSeenErrors = function() -- line: 76
		-- upvalues: t5 (ref)
		t5 = {}
	end,
	reportError = function(p3, p4, s1: string, p5) -- line: 80
		-- upvalues: LoggingProtocol (copy), t5 (ref), t2 (copy), t1 (copy), Cryo (copy), v9 (copy), tutils (copy)
		local v22 = p5 or LoggingProtocol.default

		assert(v22, "loggingProtocol must exist")

		local v23 = `{ p3 }_{ p4.name }_{ p4.componentType }_{ p4.parserName }_{ p4.propName }`

		if t5[v23] then
			return
		end

		t5[v23] = true
		v22:logRobloxTelemetryCounter(t2, 1, {
			errorType = p3,
			name = if not p4 then nil else p4.name,
			componentType = if not p4 then nil else p4.componentType,
			propName = if not p4 then nil else p4.propName,
			parserName = if not p4 then nil else p4.parserName,
			page = s1
		})
		v22:logRobloxTelemetryEvent(t1, {
			"addSessionInfo",
			LoggingProtocol.StandardizedFields.addOsInfo
		}, Cryo.Dictionary.union({
			errorType = p3,
			page = if not v9 then nil else s1
		}, p4 or {}), s1)

		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(`Discovery server-driven ui error \n{ p3 } \n{ tutils.toString(p4) }`)
		end
	end,
	reportCounter = function(s2: string, p6, b1: boolean?, p7) -- line: 128
		-- upvalues: LoggingProtocol (copy), tutils (copy)
		local v28 = p7 or LoggingProtocol.default

		assert(v28, "loggingProtocol must exist")
		v28:logRobloxTelemetryCounter({
			throttlingPercentage = 0,
			description = "Counters related to discovery server-driven ui",
			eventName = `DiscoverySdui_Counter_{ s2 }`,
			backends = { LoggingProtocol.TelemetryBackends.Counter },
			lastUpdated = {
				25,
				2,
				5
			}
		}, 1, if not p6 then nil else {
			name = if not p6 then nil else p6.name,
			componentType = if not p6 then nil else p6.componentType,
			propName = if not p6 then nil else p6.propName,
			parserName = if not p6 then nil else p6.parserName
		})

		if not b1 and not _G.__TESTEZ_RUNNING_TEST__ and not _G.__TEST_SUITE_PACKAGE__ then
			warn(`Discovery server-driven ui counter \n{ s2 } \n{ tutils.toString(p6) }`)
		end
	end,
	reportTimers = function(t6: {[any]: any}, s3: string, p8) -- line: 164
		-- upvalues: LoggingProtocol (copy), t3 (copy)
		local v32 = p8 or LoggingProtocol.default

		assert(v32, "loggingProtocol must exist")

		for v33, v34 in t6 do
			v32:logRobloxTelemetryEvent(t3, {
				"addSessionInfo",
				LoggingProtocol.StandardizedFields.addOsInfo
			}, {
				flow = v33,
				durationMs = v34.durationMs,
				count = v34.count,
				failed = v34.failed
			}, s3)
		end
	end,
	reportOmniFeedStats = function(p9, p10, p11, p12, p13) -- line: 190
		-- upvalues: LoggingProtocol (copy), t4 (copy)
		local v40 = p13 or LoggingProtocol.default

		assert(v40, "loggingProtocol must exist")

		if not p9 then
			return
		end

		local v41 = p10 or {}
		local t7 = {}
		local t8 = {}

		for _, v45 in p9 do
			if v45.topicId then
				local v46 = v45.treatmentType == "sdui"

				t8[v45.topicId] = v46

				if v46 then
					local n1 = 0
					local v48 = v41.feed and (v41.feed.props and v41.feed.props.feedItems)

					if v48 then
						for _, v50 in v48 do
							if v50.feedItemKey == v45.feedItemKey then
								local v51 = v50.props and v50.props.items

								if v51 then
									n1 = #v51

									break
								end

								if not v50.props or not v50.props.item then
									break
								end

								n1 = 1

								break
							end
						end
					end

					t7[v45.topicId] = (t7[v45.topicId] or 0) + n1
				else
					t7[v45.topicId] = (t7[v45.topicId] or 0) + (v45.recommendationList and #v45.recommendationList or 0)
				end
			end
		end

		local t9 = {}

		for v53, v54 in t7 do
			t9[`{ v53 }_item_count`] = v54
			t9[`{ v53 }_is_sdui`] = not t8[v53] and 0 or 1
		end

		t9.appPage = p11
		t9.sduiResponseRequestId = p12
		v40:logRobloxTelemetryEvent(t4, {
			"addSessionInfo",
			LoggingProtocol.StandardizedFields.addOsInfo
		}, t9, p11)
	end
}
