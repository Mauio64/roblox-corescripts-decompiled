local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local t = require(parent.t)
local getVideoEventParamsValidator = require(script.Parent.getVideoEventParamsValidator)
local VideoEventInterfaceKey = require(script.Parent.VideoEventInterfaceKey)

local defineFastInt = game:DefineFastInt("DiscoveryVideoPlayEventHundredthsPercent", 0)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags2.FFlagLuaAppDiscoveryMomentVideoTelemetry

local strictInterface = t.strictInterface
local v = {
	videoAssetId = t.string,
	videoPlaybackSessionId = t.string,
	universeId = t.string,
	rootPlaceId = t.string,
	gameSetTypeId = t.optional(t.string),
	sortPos = t.optional(t.number),
	nativeAdData = t.optional(t.string),
	tileType = t.optional(t.string),
	contentType = t.optional(t.string),
	isMoment = 0
}
local isMoment

if FFlagLuaAppDiscoveryMomentVideoTelemetry then
	isMoment = t.optional(t.boolean)
end

v.isMoment = isMoment
local v2 = strictInterface(v)
local v3

if FFlagLuaAppEnableNxMRoduxApportioning then
	v3 = t.strictInterface({
		videoAssetId = t.string,
		videoPlaybackSessionId = t.string,
		gameSetTypeId = t.optional(t.string),
		sortPos = t.optional(t.number),
		nativeAdData = t.string,
		tileType = t.string,
		contentType = t.optional(t.string)
	})
end

local v4

if FFlagLuaAppEnableNxMRoduxApportioning then
	v4 = t.strictInterface({
		videoAssetId = t.string,
		videoPlaybackSessionId = t.string,
		universeId = t.string,
		rootPlaceId = t.string,
		gameSetTypeId = t.optional(t.string),
		sortPos = t.optional(t.number),
		nativeAdData = t.string,
		tileType = t.string,
		contentType = t.optional(t.string)
	})
end

local v5 = { [VideoEventInterfaceKey.DefaultGameTile] = v2 }
local OneByTwoTileAdLink = VideoEventInterfaceKey.OneByTwoTileAdLink

if not FFlagLuaAppEnableNxMRoduxApportioning then
	v3 = nil
end

v5[OneByTwoTileAdLink] = v3

local OneByTwoTileGame = VideoEventInterfaceKey.OneByTwoTileGame

if not FFlagLuaAppEnableNxMRoduxApportioning then
	v4 = nil
end

v5[OneByTwoTileGame] = v4

local v6 = {
	eventName = "discoveryVideoPlay",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 4, 23 },
	description = "Fire when discovery video playback session starts",
	links = ""
}

local function discoveryVideoPlayEvent(p, p2)
	local videoEventParamsValidator = getVideoEventParamsValidator(p2)
	local v7 = v5[videoEventParamsValidator]

	if v7 == nil then
		DiscoveryEventErrorLogger.reportError(
			"DiscoveryVideoPlayEventMissingInterface",
			"No validator registered for video event interface key",
			{ interfaceKey = videoEventParamsValidator }
		)
	else
		local v8, v9 = v7(p2)

		if not v8 then
			DiscoveryEventErrorLogger.reportError("DiscoveryVideoPlayEventInvalidInterface", v9)
		end
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(
		v6,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
		p2,
		p
	)
end

return discoveryVideoPlayEvent
