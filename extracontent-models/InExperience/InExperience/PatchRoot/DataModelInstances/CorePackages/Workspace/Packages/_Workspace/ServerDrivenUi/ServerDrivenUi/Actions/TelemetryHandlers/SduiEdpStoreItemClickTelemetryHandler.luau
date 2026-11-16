local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local EdpStoreAnalytics = require(parent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local function SduiEdpStoreItemClickTelemetryHandler(p, p2, _)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "productType")

	if actionTelemetryFieldValue == nil then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "edpLocationType")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "universeId")
	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p, p2, "productId")

	EdpStoreAnalyticsLogger.logEvent(
		StoreEnums.ActionType.ItemClick,
		actionTelemetryFieldValue,
		actionTelemetryFieldValue2,
		tonumber(actionTelemetryFieldValue3),
		tonumber(actionTelemetryFieldValue4),
		(tostring(actionTelemetryFieldValue4))
	)
end

return SduiEdpStoreItemClickTelemetryHandler
