local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/LoggingProtocol")

local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local getVideoEventParamsValidator = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/getVideoEventParamsValidator")
local VideoEventInterfaceKey = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Events/Video/VideoEventInterfaceKey")

local defineFastInt = game:DefineFastInt("DiscoveryVideoLoopEventHundredthsPercent", 0)
local fFlagLuaAppEnableHomepageOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppEnableHomepageOneByTwoTile
local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local strictInterface = t.strictInterface
local v5 = {
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
local v6 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then t.optional(t.boolean) else nil
v5.isMoment = v6
local v7 = strictInterface(v5)
local v8

if fFlagLuaAppEnableHomepageOneByTwoTile then
	v8 = t.strictInterface({
		videoAssetId = t.string,
		videoPlaybackSessionId = t.string,
		gameSetTypeId = t.optional(t.string),
		sortPos = t.optional(t.number),
		nativeAdData = t.string,
		tileType = t.string,
		contentType = t.optional(t.string)
	})
end

local v9

if fFlagLuaAppEnableHomepageOneByTwoTile then
	v9 = t.strictInterface({
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

local v10 = { [VideoEventInterfaceKey.DefaultGameTile] = v7 }
local oneByTwoTileAdLink = VideoEventInterfaceKey.OneByTwoTileAdLink

if not fFlagLuaAppEnableHomepageOneByTwoTile then
	v8 = nil
end

v10[oneByTwoTileAdLink] = v8

local oneByTwoTileGame = VideoEventInterfaceKey.OneByTwoTileGame

if not fFlagLuaAppEnableHomepageOneByTwoTile then
	v9 = nil
end

v10[oneByTwoTileGame] = v9

local v11 = {
	eventName = "discoveryVideoLoop",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 4, 23 },
	description = "Fire when discovery video loops",
	links = ""
}

local function discoveryVideoLoop(p2, p3)
	local v12 = getVideoEventParamsValidator(p3)
	local v13 = v10[v12]

	if v13 == nil then
		discoveryEventErrorLogger.reportError(
			"DiscoveryVideoLoopEventMissingInterface",
			"No validator registered for video event interface key",
			{ interfaceKey = v12 }
		)
	else
		local v14, v15 = v13(p3)

		if not v14 then
			discoveryEventErrorLogger.reportError("DiscoveryVideoLoopEventInvalidInterface", v15)
		end
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(
		v11,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo },
		p3,
		p2
	)
end

return discoveryVideoLoop
