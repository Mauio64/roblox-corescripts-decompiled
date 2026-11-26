local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Cryo")
local UpsellEntrySurfaceType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellEntrySurfaceType")
local UpsellComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellComponent")
local UpsellStage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellStage")
local eventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialLuaAnalytics").Analytics.Enums.EventTypes
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local v5 = {
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FIntSocialUpsellEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 9, 26 },
	description = "Upsell Banner Analytics Event"
}

function LUAUFORGE_MODULE_GLOBALS_cRL_evaluateUpsellStage(p2, p3, p4)
	if
		p3 ~= UpsellComponent.Modal
		or p4 == UpsellComponent.Modal
		and (p2 == UpsellEntrySurfaceType.Homepage or p2 == UpsellEntrySurfaceType.InExperienceChatInputBar or p2 == UpsellEntrySurfaceType.InExperienceVoiceChatIcon)
	then
		return UpsellStage.Fae
	end

	return UpsellStage.FaeDetails
end

local function generateUpsellIdentifier(p2, p3, p4)
	if p2 and p3 and p4 then
		return p2 .. p3 .. p4
	end

	return nil
end

function LUAUFORGE_MODULE_GLOBALS_cRL_logUpsellEvent(p2, data)
	local joined = Cryo.Dictionary.join(v5, { eventName = p2 })
	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	local v6 = {
		upsellEntrySurface = data.upsellEntrySurface,
		upsellStage = data.upsellStage,
		upsellImpressionId = data.upsellImpressionId,
		upsellComponent = data.upsellComponent,
		btn = data.btn or nil,
		conversationId = data.conversationId or nil,
		playSessionId = 0,
		clientTimeStamp = 0,
		upsellEntryComponent = 0
	}

	if playSessionId == "" then
		playSessionId = nil
	end

	v6.playSessionId = playSessionId
	v6.clientTimeStamp = os.time()
	v6.upsellEntryComponent = data.upsellEntryComponent

	local upsellPurpose = data.upsellPurpose
	local upsellEntrySurface = data.upsellEntrySurface
	local upsellComponent = data.upsellComponent
	local v7 = if upsellPurpose and upsellEntrySurface and upsellComponent then upsellPurpose .. upsellEntrySurface .. upsellComponent else nil

	v6.upsellIdentifier = v7

	v6.upsellPurpose = data.upsellPurpose

	local v8 = { "addSessionInfo" }
	table.insert(v8, "addPlaceId")
	table.insert(v8, "addUniverseId")

	TelemetryService:LogEvent(joined, { customFields = v6, standardizedFields = v8 })
end

return {
	evaluateUpsellStage = LUAUFORGE_MODULE_GLOBALS_cRL_evaluateUpsellStage,
	logUpsellEvent = LUAUFORGE_MODULE_GLOBALS_cRL_logUpsellEvent
}
