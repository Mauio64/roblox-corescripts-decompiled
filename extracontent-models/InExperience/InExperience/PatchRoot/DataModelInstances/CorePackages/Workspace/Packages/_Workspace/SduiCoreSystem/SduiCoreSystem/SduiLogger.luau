local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local LoggingProtocol = require(parent.LoggingProtocol)
local tutils = require(parent.tutils)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiErrors)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddHasOneByTwoField = SharedFlags.FFlagLuaAppAddHasOneByTwoField
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAddHasOneByTwoFieldSdui = SharedFlags2.FFlagLuaAppAddHasOneByTwoFieldSdui
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppSduiHomeFeedStats = SharedFlags3.FFlagLuaAppSduiHomeFeedStats

local defineFastInt = game:DefineFastInt("DiscoverySduiErrorHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("DiscoverySduiTimerEventsHundredthsPercent", 0)
local defineFastInt3 = game:DefineFastInt("DiscoveryFeedStatsHundredthsPercent", 0)

local v = {
	eventName = "DiscoverySdui_ErrorDetails",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 11, 4 },
	description = "Error details related to discovery server-driven ui",
	links = ""
}

local v2 = {
	eventName = "DiscoverySdui_ErrorCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = 0,
	lastUpdated = { 24, 12, 14 },
	description = "Error related to discovery server-driven ui"
}

local v3 = {
	eventName = "DiscoverySdui_Timers",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 25, 3, 14 },
	description = "Timers related to discovery server-driven ui",
	links = ""
}

local v4 = {
	eventName = "DiscoverySdui_FeedStats",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt3,
	lastUpdated = { 25, 5, 27 },
	description = "Stats for feed response. Number of items per collection",
	links = ""
}

local function makeErrorKey(p, options) -- 1 equivalent call inferred from this helper
	return `{p}_{options.name}_{options.componentType}_{options.parserName}_{options.propName}`
end

local errorKeySet = {}
local SduiLogger = {}

function SduiLogger.clearSeenErrors()
	errorKeySet = {}
end

function SduiLogger.reportError(errorType, options, page: string, p)
	local v5 = p or LoggingProtocol.default
	assert(v5, "loggingProtocol must exist")
	local errorKey = makeErrorKey(errorType, options) -- inferred equivalent call

	if errorKeySet[errorKey] then
		return
	end

	errorKeySet[errorKey] = true
	local name

	if options then
		name = options.name
	end

	local componentType

	if options then
		componentType = options.componentType
	end

	local propName

	if options then
		propName = options.propName
	end

	local parserName

	if options then
		parserName = options.parserName
	end

	v5:logRobloxTelemetryCounter(v2, 1, {
		errorType = errorType,
		name = name,
		componentType = componentType,
		propName = propName,
		parserName = parserName,
		page = page
	})

	v5:logRobloxTelemetryEvent(
		v,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
		Cryo.Dictionary.union({ errorType = errorType, page = page }, options or {}),
		page
	)

	if not _G.__TESTEZ_RUNNING_TEST__ then
		warn(`Discovery server-driven ui error \n{errorType} \n{tutils.toString(options)}`)
	end
end

function SduiLogger.reportCounter(p: string, data, flag: boolean?, p2)
	local v5 = p2 or LoggingProtocol.default
	assert(v5, "loggingProtocol must exist")

	local v6 = {
		eventName = `DiscoverySdui_Counter_{p}`,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		lastUpdated = { 25, 2, 5 },
		description = "Counters related to discovery server-driven ui"
	}
	local v7

	if data then
		v7 = { name = 0, componentType = 0, propName = 0, parserName = 0 }
		local name

		if data then
			name = data.name
		end

		v7.name = name
		local componentType

		if data then
			componentType = data.componentType
		end

		v7.componentType = componentType
		local propName

		if data then
			propName = data.propName
		end

		v7.propName = propName
		local parserName

		if data then
			parserName = data.parserName
		end

		v7.parserName = parserName
	end

	v5:logRobloxTelemetryCounter(v6, 1, v7)

	if not (flag or _G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__) then
		warn(`Discovery server-driven ui counter \n{p} \n{tutils.toString(data)}`)
	end
end

function SduiLogger.reportTimers(items, p: string, p2)
	local v5 = p2 or LoggingProtocol.default
	assert(v5, "loggingProtocol must exist")

	for k, item in items do
		v5:logRobloxTelemetryEvent(
			v3,
			{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
			{ flow = k, durationMs = item.durationMs, count = item.count, failed = item.failed },
			p
		)
	end
end

function SduiLogger.reportOmniFeedStats(items, options, appPage, sduiResponseRequestId, p, hasOneByTwo: boolean?)
	local v5 = p or LoggingProtocol.default
	assert(v5, "loggingProtocol must exist")

	if not items then
		return
	end

	local v6 = {}
	local v7 = options or {}
	local v8 = {}

	for _, item in items do
		if not item.topicId then
			continue
		end

		local v9 = item.treatmentType == "sdui"
		v6[item.topicId] = v9

		if v9 then
			local v10 = 0
			local feedItems = v7.feed and v7.feed.props and v7.feed.props.feedItems

			if feedItems then
				for _, feedItem in feedItems do
					if feedItem.feedItemKey == item.feedItemKey then
						local items2 = feedItem.props and feedItem.props.items

						if items2 then
							v10 = #items2
						elseif feedItem.props and feedItem.props.item then
							v10 = 1
						end

						break
					end
				end
			end

			v8[item.topicId] = (v8[item.topicId] or 0) + v10
		else
			v8[item.topicId] = (v8[item.topicId] or 0) + (item.recommendationList and #item.recommendationList or 0)
		end
	end

	local v9 = {}

	for k, v10 in v8 do
		v9[`{k}_item_count`] = v10
		v9[`{k}_is_sdui`] = v6[k] and 1 or 0
	end

	v9.appPage = appPage
	v9.sduiResponseRequestId = sduiResponseRequestId

	if FFlagLuaAppAddHasOneByTwoField then
		v9.hasOneByTwo = hasOneByTwo
	end

	v5:logRobloxTelemetryEvent(v4, { "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo }, v9, appPage)
end

SduiLogger.reportSduiV2FeedStats = FFlagLuaAppSduiHomeFeedStats
	and function(items, appPage: string, sduiResponseRequestId: string?, p, hasOneByTwo: boolean?)
		local v5 = p or LoggingProtocol.default
		assert(v5, "loggingProtocol must exist")

		if next(items) == nil then
			return
		end

		local v6 = {}

		for k, item in items do
			if item.itemCount ~= nil then
				v6[`{k}_item_count`] = item.itemCount
			end

			v6[`{k}_is_sdui`] = 1
			v6[`{k}_position`] = item.position
		end

		v6.appPage = appPage
		v6.sduiResponseRequestId = sduiResponseRequestId
		v6.feedSource = "SduiV2FullPage"

		if FFlagLuaAppAddHasOneByTwoFieldSdui then
			v6.hasOneByTwo = hasOneByTwo
		end

		v5:logRobloxTelemetryEvent(v4, { "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo }, v6, appPage)
	end
	or nil
return SduiLogger
