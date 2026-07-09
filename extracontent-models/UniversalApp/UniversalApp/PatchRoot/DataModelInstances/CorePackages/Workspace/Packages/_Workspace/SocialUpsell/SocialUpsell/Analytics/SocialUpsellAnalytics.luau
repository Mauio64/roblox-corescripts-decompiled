local TelemetryService = game:GetService("TelemetryService")
local SocialUpsell = script:FindFirstAncestor("SocialUpsell")

require(SocialUpsell.Types)

local SocialUpsellParent = SocialUpsell.Parent
local Cryo = require(SocialUpsellParent.Cryo)
local UpsellEntrySurfaceType = require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
local UpsellStage = require(SocialUpsell.Analytics.Enum.UpsellStage)
local _ = require(SocialUpsellParent.SocialLuaAnalytics).Analytics.Enums.EventTypes
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local FFlagAddSessionizationToAnalytics = require(SocialUpsell.Flag.FFlagAddSessionizationToAnalytics)
local FFlagAddAEGIS2Analytics = require(SocialUpsell.Flag.FFlagAddAEGIS2Analytics)
local FFlagAddUpsellEntryComponentToAnalytics = require(SocialUpsell.Flag.FFlagAddUpsellEntryComponentToAnalytics)
local v13 = game:DefineFastInt("FIntSocialUpsellEventThrottleHunderedthsPercent", 10000)
local t1 = {
	description = "Upsell Banner Analytics Event",
	backends = { "EventIngest" },
	throttlingPercentage = v13,
	lastUpdated = {
		2025,
		9,
		26
	}
}

function evaluateUpsellStage(p1, p2, p3) -- line: 29
	-- upvalues: UpsellComponent (copy), UpsellEntrySurfaceType (copy), FFlagAddAEGIS2Analytics (copy), UpsellStage (copy)
	if p2 == UpsellComponent.Modal then
		if p3 == UpsellComponent.Modal and (p1 == UpsellEntrySurfaceType.Homepage or FFlagAddAEGIS2Analytics and (p1 == UpsellEntrySurfaceType.InExperienceChatInputBar or p1 == UpsellEntrySurfaceType.InExperienceVoiceChatIcon)) then
			return UpsellStage.Fae
		end

		return UpsellStage.FaeDetails
	end

	return UpsellStage.Fae
end

local function generateUpsellIdentifier(s1: string?, s2: string?, s3: string?) -- line: 60
	if not s1 or (not s2 or not s3) then
		return nil
	end

	return s1 .. s2 .. s3
end

function logUpsellEvent(p4, t2: {[any]: any}) -- line: 71
	-- upvalues: Cryo (copy), t1 (copy), RbxAnalyticsService (copy), FFlagAddUpsellEntryComponentToAnalytics (copy), FFlagAddSessionizationToAnalytics (copy), FFlagAddAEGIS2Analytics (copy), TelemetryService (copy)
	local v24 = Cryo.Dictionary.join(t1, {
		eventName = p4
	})
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local t3 = {
		upsellEntrySurface = t2.upsellEntrySurface,
		upsellStage = t2.upsellStage,
		upsellImpressionId = t2.upsellImpressionId,
		upsellComponent = t2.upsellComponent,
		btn = t2.btn or nil,
		conversationId = t2.conversationId or nil,
		playSessionId = if PlaySessionId == "" then nil else PlaySessionId,
		clientTimeStamp = os.time(),
		upsellEntryComponent = if not FFlagAddUpsellEntryComponentToAnalytics then nil else t2.upsellEntryComponent
	}
	local upsellPurpose = t2.upsellPurpose
	local upsellEntrySurface = t2.upsellEntrySurface
	local upsellComponent = t2.upsellComponent

	t3.upsellIdentifier = if not not upsellPurpose and (not not upsellEntrySurface and upsellComponent) then upsellPurpose .. upsellEntrySurface .. upsellComponent else nil
	t3.upsellPurpose = t2.upsellPurpose

	local v30 = if not FFlagAddSessionizationToAnalytics then {} else { "addSessionInfo" }

	if FFlagAddAEGIS2Analytics then
		table.insert(v30, "addPlaceId")
		table.insert(v30, "addUniverseId")
	end

	TelemetryService:LogEvent(v24, {
		customFields = t3,
		standardizedFields = v30
	})
end

return {
	evaluateUpsellStage = evaluateUpsellStage,
	logUpsellEvent = logUpsellEvent
}
