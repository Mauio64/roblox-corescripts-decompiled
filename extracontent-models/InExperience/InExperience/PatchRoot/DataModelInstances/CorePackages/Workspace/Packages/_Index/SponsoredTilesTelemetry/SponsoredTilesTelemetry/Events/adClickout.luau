local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("SponsoredTilesTelemetry").Parent

local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local v = {
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

return function(encryptedTrackingData: string, tileType: string, clickoutUrl: string)
	local customFields = {
		encryptedTrackingData = encryptedTrackingData,
		tileType = tileType,
		clickoutUrl = clickoutUrl
	}

	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("AdClickoutInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields,
		legacyOverrideTargetForEventIngest = getPlatformTarget()
	})
end
