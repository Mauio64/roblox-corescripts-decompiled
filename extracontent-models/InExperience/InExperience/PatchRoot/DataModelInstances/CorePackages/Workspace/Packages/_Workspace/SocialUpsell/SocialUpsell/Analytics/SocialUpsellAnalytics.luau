local TelemetryService = game:GetService("TelemetryService")
local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
require(SocialUpsell.Types)
local parent = SocialUpsell.Parent
local Cryo = require(parent.Cryo)
local UpsellEntrySurfaceType = require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
local UpsellStage = require(SocialUpsell.Analytics.Enum.UpsellStage)
local v = require(parent.SocialLuaAnalytics)
v = v.Analytics.Enums.EventTypes
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local v2 = {
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("FIntSocialUpsellEventThrottleHunderedthsPercent", 10000),
	lastUpdated = { 2025, 9, 26 },
	description = "Upsell Banner Analytics Event"
}

function evaluateUpsellStage(p, p2, p3)
	if
		p2 ~= UpsellComponent.Modal
		or p3 == UpsellComponent.Modal
		and (p == UpsellEntrySurfaceType.Homepage or p == UpsellEntrySurfaceType.InExperienceChatInputBar or p == UpsellEntrySurfaceType.InExperienceVoiceChatIcon)
	then
		return UpsellStage.Fae
	end

	return UpsellStage.FaeDetails
end

local function generateUpsellIdentifier(upsellPurpose: string?, upsellEntrySurface: string?, upsellComponent: string?) -- 1 equivalent call inferred from this helper
	if upsellPurpose and upsellEntrySurface and upsellComponent then
		return upsellPurpose .. upsellEntrySurface .. upsellComponent
	end

	return nil
end

function logUpsellEvent(eventName, data)
	local joined = Cryo.Dictionary.join(v2, { eventName = eventName })
	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	local customFields = {
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

	customFields.playSessionId = playSessionId
	customFields.clientTimeStamp = os.time()
	customFields.upsellEntryComponent = data.upsellEntryComponent

	customFields.upsellIdentifier = generateUpsellIdentifier( -- inferred equivalent call
		data.upsellPurpose,
		data.upsellEntrySurface,
		data.upsellComponent
	)

	customFields.upsellPurpose = data.upsellPurpose

	local standardizedFields = { "addSessionInfo" }
	table.insert(standardizedFields, "addPlaceId")
	table.insert(standardizedFields, "addUniverseId")

	TelemetryService:LogEvent(joined, {
		customFields = customFields,
		standardizedFields = standardizedFields
	})
end

return { evaluateUpsellStage = evaluateUpsellStage, logUpsellEvent = logUpsellEvent }
