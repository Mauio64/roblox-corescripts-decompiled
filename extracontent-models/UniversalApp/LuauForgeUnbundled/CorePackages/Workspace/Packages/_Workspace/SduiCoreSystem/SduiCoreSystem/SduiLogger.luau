local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/LoggingProtocol")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local fFlagLuaAppAddHasOneByTwoField = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppAddHasOneByTwoField
local fFlagLuaAppAddHasOneByTwoFieldSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppAddHasOneByTwoFieldSdui
local fFlagLuaAppSduiHomeFeedStats = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagLuaAppSduiHomeFeedStats

local defineFastInt = game:DefineFastInt("DiscoverySduiErrorHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("DiscoverySduiTimerEventsHundredthsPercent", 0)
local defineFastInt3 = game:DefineFastInt("DiscoveryFeedStatsHundredthsPercent", 0)

local v5 = {
	eventName = "DiscoverySdui_ErrorDetails",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 11, 4 },
	description = "Error details related to discovery server-driven ui",
	links = ""
}

local v6 = {
	eventName = "DiscoverySdui_ErrorCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = 0,
	lastUpdated = { 24, 12, 14 },
	description = "Error related to discovery server-driven ui"
}

local v7 = {
	eventName = "DiscoverySdui_Timers",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 25, 3, 14 },
	description = "Timers related to discovery server-driven ui",
	links = ""
}

local v8 = {
	eventName = "DiscoverySdui_FeedStats",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt3,
	lastUpdated = { 25, 5, 27 },
	description = "Stats for feed response. Number of items per collection",
	links = ""
}

local function makeErrorKey(p2, data)
	return `{p2}_{data.name}_{data.componentType}_{data.parserName}_{data.propName}`
end

local set = {}
return {
	clearSeenErrors = function()
		set = {}
	end,
	reportError = function(p2, options, page, p3)
		local v9 = p3 or LoggingProtocol.default
		assert(v9, "loggingProtocol must exist")
		local formatted = `{p2}_{options.name}_{options.componentType}_{options.parserName}_{options.propName}`

		if set[formatted] then
			return
		end

		set[formatted] = true

		local v13 = if options then options.name else nil
		local v14 = if options then options.componentType else nil
		local v15 = if options then options.propName else nil
		local v16 = if options then options.parserName else nil
		v9:logRobloxTelemetryCounter(v6, 1, {
			errorType = p2,
			name = v13,
			componentType = v14,
			propName = v15,
			parserName = v16,
			page = page
		})

		v9:logRobloxTelemetryEvent(
			v5,
			{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
			Cryo.Dictionary.union({ errorType = p2, page = page }, options or {}),
			page
		)

		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(`Discovery server-driven ui error \n{p2} \n{module3.toString(options)}`)
		end
	end,
	reportCounter = function(p2, data, p3, p4)
		local v9 = p4 or LoggingProtocol.default
		assert(v9, "loggingProtocol must exist")

		local v10 = {
			eventName = `DiscoverySdui_Counter_{p2}`,
			backends = { LoggingProtocol.TelemetryBackends.Counter },
			throttlingPercentage = 0,
			lastUpdated = { 25, 2, 5 },
			description = "Counters related to discovery server-driven ui"
		}
		local v12

		if data then
			v12 = { name = 0, componentType = 0, propName = 0, parserName = 0 }
			local v13 = if data then data.name else nil
			v12.name = v13
			local v14 = if data then data.componentType else nil
			v12.componentType = v14
			local v15 = if data then data.propName else nil
			v12.propName = v15
			local v16 = if data then data.parserName else nil
			v12.parserName = v16
		end

		v9:logRobloxTelemetryCounter(v10, 1, v12)

		if not (p3 or _G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__) then
			warn(`Discovery server-driven ui counter \n{p2} \n{module3.toString(data)}`)
		end
	end,
	reportTimers = function(items, p2, p3)
		local v9 = p3 or LoggingProtocol.default
		assert(v9, "loggingProtocol must exist")

		for k, item in items do
			v9:logRobloxTelemetryEvent(
				v7,
				{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
				{
					flow = k,
					durationMs = item.durationMs,
					count = item.count,
					failed = item.failed
				},
				p2
			)
		end
	end,
	reportOmniFeedStats = function(items, options, appPage, sduiResponseRequestId, p2, hasOneByTwo)
		local v9 = p2 or LoggingProtocol.default
		assert(v9, "loggingProtocol must exist")

		if not items then
			return
		end

		local v10 = {}
		local v11 = options or {}
		local v12 = {}

		for k, item in items do
			if not item.topicId then
				continue
			end

			local v13 = item.treatmentType == "sdui"
			v10[item.topicId] = v13

			if v13 then
				local v14 = 0
				local feedItems = v11.feed and v11.feed.props and v11.feed.props.feedItems

				if feedItems then
					for k2, feedItem in feedItems do
						if feedItem.feedItemKey == item.feedItemKey then
							local items2 = feedItem.props and feedItem.props.items

							if items2 then
								v14 = #items2
							elseif feedItem.props and feedItem.props.item then
								v14 = 1
							end

							break
						end
					end
				end

				v12[item.topicId] = (v12[item.topicId] or 0) + v14
			else
				v12[item.topicId] = (v12[item.topicId] or 0) + (item.recommendationList and #item.recommendationList or 0)
			end
		end

		local v13 = {}

		for k, v14 in v12 do
			v13[`{k}_item_count`] = v14
			v13[`{k}_is_sdui`] = v10[k] and 1 or 0
		end

		v13.appPage = appPage
		v13.sduiResponseRequestId = sduiResponseRequestId

		if fFlagLuaAppAddHasOneByTwoField then
			v13.hasOneByTwo = hasOneByTwo
		end

		v9:logRobloxTelemetryEvent(
			v8,
			{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
			v13,
			appPage
		)
	end,
	reportSduiV2FeedStats = fFlagLuaAppSduiHomeFeedStats and function(items, appPage, sduiResponseRequestId, p2, hasOneByTwo)
		local v9 = p2 or LoggingProtocol.default
		assert(v9, "loggingProtocol must exist")

		if next(items) == nil then
			return
		end

		local v10 = {}

		for k, item in items do
			if item.itemCount ~= nil then
				v10[`{k}_item_count`] = item.itemCount
			end

			v10[`{k}_is_sdui`] = 1
			v10[`{k}_position`] = item.position
		end

		v10.appPage = appPage
		v10.sduiResponseRequestId = sduiResponseRequestId
		v10.feedSource = "SduiV2FullPage"

		if fFlagLuaAppAddHasOneByTwoFieldSdui then
			v10.hasOneByTwo = hasOneByTwo
		end

		v9:logRobloxTelemetryEvent(
			v8,
			{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
			v10,
			appPage
		)
	end or nil
}
