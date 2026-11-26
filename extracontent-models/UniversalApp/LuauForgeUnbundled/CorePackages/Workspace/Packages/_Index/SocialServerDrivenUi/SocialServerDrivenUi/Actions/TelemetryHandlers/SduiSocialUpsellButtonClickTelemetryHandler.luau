local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SocialLuaAnalytics")
local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SocialUpsell")

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local eventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local socialUpsellAnalytics = SocialUpsell.Analytics.SocialUpsellAnalytics

local v5 = { "upsellEntrySurface", "upsellComponent", "upsellPurpose" }

local function SduiSocialUpsellButtonClickTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValues = {}
	local v6 = {}

	for k, v7 in v5 do
		local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, v7)
		actionTelemetryFieldValues[v7] = actionTelemetryFieldValue

		if actionTelemetryFieldValue == nil then
			table.insert(v6, v7)
		end
	end

	if #v6 > 0 then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "SocialUpsellButtonClickTelemetryHandler",
				message = `Missing telemetry fields: {table.concat(v6, ", ")}`
			},
			p4.appPage
		)
	end

	socialUpsellAnalytics.logUpsellEvent(eventTypes.SocialUpsellButtonClick, {
		upsellEntrySurface = actionTelemetryFieldValues.upsellEntrySurface,
		upsellComponent = actionTelemetryFieldValues.upsellComponent,
		upsellPurpose = actionTelemetryFieldValues.upsellPurpose,
		upsellStage = getActionTelemetryFieldValue(p2, p3, "upsellStage"),
		upsellImpressionId = getActionTelemetryFieldValue(p2, p3, "upsellImpressionId"),
		btn = getActionTelemetryFieldValue(p2, p3, "btn"),
		conversationId = getActionTelemetryFieldValue(p2, p3, "conversationId"),
		upsellEntryComponent = getActionTelemetryFieldValue(p2, p3, "upsellEntryComponent")
	})
end

return SduiSocialUpsellButtonClickTelemetryHandler
