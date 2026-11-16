local EdpStoreAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/EdpStoreAnalytics")
local edpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local storeEnums = EdpStoreAnalytics.Constants.StoreEnums

local getActionTelemetryFieldValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").getActionTelemetryFieldValue

local function SduiEdpStoreItemClickTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "productType")

	if actionTelemetryFieldValue == nil then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "edpLocationType")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "universeId")
	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p2, p3, "productId")

	edpStoreAnalyticsLogger.logEvent(
		storeEnums.ActionType.ItemClick,
		actionTelemetryFieldValue,
		actionTelemetryFieldValue2,
		tonumber(actionTelemetryFieldValue3),
		tonumber(actionTelemetryFieldValue4),
		(tostring(actionTelemetryFieldValue4))
	)
end

return SduiEdpStoreItemClickTelemetryHandler
