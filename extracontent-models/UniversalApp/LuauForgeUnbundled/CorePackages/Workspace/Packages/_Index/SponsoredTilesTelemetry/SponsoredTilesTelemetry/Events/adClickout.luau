local TelemetryService = game:GetService("TelemetryService")

local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTilesTelemetry/Analytics").getPlatformTarget
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTilesTelemetry/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTilesTelemetry/DiscoveryUtils").DiscoveryEventErrorLogger

local v5 = {
	eventName = "adClickout",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("LuaAppAdClickoutEventThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 19 },
	description = "Fires when the user activates a sponsored ad clickout CTA",
	links = "https://github.rbx.com/Roblox/proto-schemas/blob/master/production/eventstream/ads/ads_clickout_event.proto"
}

local strictInterface = t.strictInterface({
	encryptedTrackingData = t.string,
	tileType = t.string,
	clickoutUrl = t.string
})

return function(p2, p3, p4)
	local v6 = { encryptedTrackingData = p2, tileType = p3, clickoutUrl = p4 }

	local v7, v8 = strictInterface(v6)

	if not v7 then
		discoveryEventErrorLogger.reportError("AdClickoutInvalidInterface", v8)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = v6,
		legacyOverrideTargetForEventIngest = getPlatformTarget()
	})
end
