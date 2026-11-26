local TelemetryService = game:GetService("TelemetryService")

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTilesTelemetry/SharedFlags").FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local v6 = fFlagLuaAppEnableOneByTwoTileFunnelTelemetry
	and { "addOSInfo", "addSessionInfo", "addSessionId" }
	or nil

local v7 = fFlagLuaAppEnableOneByTwoTileFunnelTelemetry and {} or nil

local v8 = {
	eventName = "OneByTwoTileActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 5 },
	description = "Counter for OneByTwoTileActivated events."
}

local v9 = {
	eventName = "OneByTwoTileCtaActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 5 },
	description = "Counter for OneByTwoTileCtaActivated events."
}

local v10 = {
	eventName = "OneByTwoTileGameJoinInitiated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 5 },
	description = "Counter for OneByTwoTileGameJoinInitiated events."
}

local v11 = {
	eventName = "OneByTwoTileVideoLoaded",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"LuaAppOneByTwoTileVideoLoadedTelemetryThrottleHundredthsPercent",
		0
	),
	lastUpdated = { 26, 8, 26 },
	description = "Fired when OneByTwoTile VideoDisplay LoadAsync succeeds."
}

local function makeFunnelConfig(p2, p3)
	return {
		eventName = p2,
		backends = { "EventIngest", "Points" },
		throttlingPercentage = 10000,
		lastUpdated = { 26, 9, 21 },
		description = p3,
		links = "https://roblox.atlassian.net/browse/ADS-11511"
	}
end

local v12

if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v12 = makeFunnelConfig(
		"OneByTwoTileResponseReceived",
		"Fired when an omni-recommendations response contains a OneByTwoTile."
	)
else
	v12 = nil
end

local v13

if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v13 = makeFunnelConfig("OneByTwoTilePlaced", "Fired when a OneByTwoTile is placed into a grid.")
else
	v13 = nil
end

local v14

if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v14 = makeFunnelConfig(
		"OneByTwoTileSkipped",
		"Fired when a OneByTwoTile cannot be placed into any grid."
	)
else
	v14 = nil
end

local v15

if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v15 = makeFunnelConfig("OneByTwoTileRendered", "Fired when a OneByTwoTile component mounts.")
else
	v15 = nil
end

local function logFunnelEvent(p2, p3)
	local formatted = `{p2.eventName}:{p3.oneByTwoTileFlowId}`

	if v7[formatted] then
		return
	end

	v7[formatted] = true
	TelemetryService:LogEvent(p2, { standardizedFields = v6, customFields = p3 })
end

local v16 = {
	CtaType = { GameJoin = "GameJoin", Clickout = "Clickout" }
}

function v16.logOneByTwoTileActivated()
	TelemetryService:LogCounter(v8, {}, 1)
end

function v16.logOneByTwoTileCtaActivated(p2)
	TelemetryService:LogCounter(v9, {
		customFields = { CtaType = p2 }
	}, 1)
end

function v16.logOneByTwoTileGameJoinInitiated()
	TelemetryService:LogCounter(v10, {}, 1)
end

function v16.logOneByTwoTileVideoLoaded(p2, p3, p4)
	TelemetryService:LogEvent(v11, {
		standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" },
		customFields = { videoLengthSec = p2, loadDurationSec = p3, nativeAdData = p4 }
	})
end

function v16.logOneByTwoTileResponseReceived(p2)
	local v17 = v12
	local formatted = `{v17.eventName}:{p2.oneByTwoTileFlowId}`

	if v7[formatted] then
		return
	end

	v7[formatted] = true
	TelemetryService:LogEvent(v17, { standardizedFields = v6, customFields = p2 })
end

function v16.logOneByTwoTilePlaced(p2)
	local v17 = v13
	local formatted = `{v17.eventName}:{p2.oneByTwoTileFlowId}`

	if v7[formatted] then
		return
	end

	v7[formatted] = true
	TelemetryService:LogEvent(v17, { standardizedFields = v6, customFields = p2 })
end

function v16.logOneByTwoTileSkipped(p2)
	local v17 = v14
	local formatted = `{v17.eventName}:{p2.oneByTwoTileFlowId}`

	if v7[formatted] then
		return
	end

	v7[formatted] = true
	TelemetryService:LogEvent(v17, { standardizedFields = v6, customFields = p2 })
end

function v16.logOneByTwoTileRendered(p2)
	local v17 = v15
	local formatted = `{v17.eventName}:{p2.oneByTwoTileFlowId}`

	if v7[formatted] then
		return
	end

	v7[formatted] = true
	TelemetryService:LogEvent(v17, { standardizedFields = v6, customFields = p2 })
end

return v16
