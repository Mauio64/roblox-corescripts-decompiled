local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("SponsoredTilesTelemetry").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetry = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local standardizedFields = FFlagLuaAppEnableOneByTwoTileFunnelTelemetry
	and { "addOSInfo", "addSessionInfo", "addSessionId" }
	or nil

local v = FFlagLuaAppEnableOneByTwoTileFunnelTelemetry and {} or nil

local v2 = {
	eventName = "OneByTwoTileActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 5 },
	description = "Counter for OneByTwoTileActivated events."
}

local v3 = {
	eventName = "OneByTwoTileCtaActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 5 },
	description = "Counter for OneByTwoTileCtaActivated events."
}

local v4 = {
	eventName = "OneByTwoTileGameJoinInitiated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 5 },
	description = "Counter for OneByTwoTileGameJoinInitiated events."
}

local v5 = {
	eventName = "OneByTwoTileVideoLoaded",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppOneByTwoTileVideoLoadedTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 8, 26 },
	description = "Fired when OneByTwoTile VideoDisplay LoadAsync succeeds."
}

local function makeFunnelConfig(eventName: string, description: string)
	return {
		eventName = eventName,
		backends = { "EventIngest", "Points" },
		throttlingPercentage = 10000,
		lastUpdated = { 26, 9, 21 },
		description = description,
		links = "https://roblox.atlassian.net/browse/ADS-11511"
	}
end

local v6

if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v6 = makeFunnelConfig(
		"OneByTwoTileResponseReceived",
		"Fired when an omni-recommendations response contains a OneByTwoTile."
	)
else
	v6 = nil
end

local v7

if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v7 = makeFunnelConfig("OneByTwoTilePlaced", "Fired when a OneByTwoTile is placed into a grid.")
else
	v7 = nil
end

local v8

if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v8 = makeFunnelConfig("OneByTwoTileSkipped", "Fired when a OneByTwoTile cannot be placed into any grid.")
else
	v8 = nil
end

local v9

if FFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	v9 = makeFunnelConfig("OneByTwoTileRendered", "Fired when a OneByTwoTile component mounts.")
else
	v9 = nil
end

local function logFunnelEvent(p, customFields) -- 4 equivalent calls inferred from this helper
	local formatted = `{p.eventName}:{customFields.oneByTwoTileFlowId}`

	if v[formatted] then
		return
	end

	v[formatted] = true
	TelemetryService:LogEvent(p, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

local OneByTwoTileTelemetry = {
	CtaType = { GameJoin = "GameJoin", Clickout = "Clickout" }
}

function OneByTwoTileTelemetry.logOneByTwoTileActivated()
	TelemetryService:LogCounter(v2, {}, 1)
end

function OneByTwoTileTelemetry.logOneByTwoTileCtaActivated(ctaType: string)
	TelemetryService:LogCounter(v3, {
		customFields = { CtaType = ctaType }
	}, 1)
end

function OneByTwoTileTelemetry.logOneByTwoTileGameJoinInitiated()
	TelemetryService:LogCounter(v4, {}, 1)
end

function OneByTwoTileTelemetry.logOneByTwoTileVideoLoaded(videoLengthSec: number, loadDurationSec: number, nativeAdData: string?)
	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" },
		customFields = {
			videoLengthSec = videoLengthSec,
			loadDurationSec = loadDurationSec,
			nativeAdData = nativeAdData
		}
	})
end

function OneByTwoTileTelemetry.logOneByTwoTileResponseReceived(customFields)
	logFunnelEvent(v6, customFields) -- inferred equivalent call
end

function OneByTwoTileTelemetry.logOneByTwoTilePlaced(customFields)
	logFunnelEvent(v7, customFields) -- inferred equivalent call
end

function OneByTwoTileTelemetry.logOneByTwoTileSkipped(customFields)
	logFunnelEvent(v8, customFields) -- inferred equivalent call
end

function OneByTwoTileTelemetry.logOneByTwoTileRendered(customFields)
	logFunnelEvent(v9, customFields) -- inferred equivalent call
end

return OneByTwoTileTelemetry
