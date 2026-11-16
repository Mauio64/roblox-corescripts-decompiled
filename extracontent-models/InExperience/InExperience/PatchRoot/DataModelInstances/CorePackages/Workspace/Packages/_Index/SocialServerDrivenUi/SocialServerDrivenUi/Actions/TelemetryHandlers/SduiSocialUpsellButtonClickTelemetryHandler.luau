local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SocialUpsell = require(parent.SocialUpsell)

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local SocialUpsellAnalytics = SocialUpsell.Analytics.SocialUpsellAnalytics

local v = { "upsellEntrySurface", "upsellComponent", "upsellPurpose" }

local function SduiSocialUpsellButtonClickTelemetryHandler(p, p2, p3)
	local actionTelemetryFieldValues = {}
	local v2 = {}

	for _, v3 in v do
		local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, v3)
		actionTelemetryFieldValues[v3] = actionTelemetryFieldValue

		if actionTelemetryFieldValue == nil then
			table.insert(v2, v3)
		end
	end

	if #v2 > 0 then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "SocialUpsellButtonClickTelemetryHandler",
				message = `Missing telemetry fields: {table.concat(v2, ", ")}`
			},
			p3.appPage
		)
	end

	SocialUpsellAnalytics.logUpsellEvent(EventTypes.SocialUpsellButtonClick, {
		upsellEntrySurface = actionTelemetryFieldValues.upsellEntrySurface,
		upsellComponent = actionTelemetryFieldValues.upsellComponent,
		upsellPurpose = actionTelemetryFieldValues.upsellPurpose,
		upsellStage = getActionTelemetryFieldValue(p, p2, "upsellStage"),
		upsellImpressionId = getActionTelemetryFieldValue(p, p2, "upsellImpressionId"),
		btn = getActionTelemetryFieldValue(p, p2, "btn"),
		conversationId = getActionTelemetryFieldValue(p, p2, "conversationId"),
		upsellEntryComponent = getActionTelemetryFieldValue(p, p2, "upsellEntryComponent")
	})
end

return SduiSocialUpsellButtonClickTelemetryHandler
