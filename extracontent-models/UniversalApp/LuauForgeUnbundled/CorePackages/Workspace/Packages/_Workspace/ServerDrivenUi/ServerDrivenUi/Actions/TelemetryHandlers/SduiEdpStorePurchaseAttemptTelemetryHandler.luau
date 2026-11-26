local EdpStoreAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/EdpStoreAnalytics")
local edpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local storeEnums = EdpStoreAnalytics.Constants.StoreEnums

local productKind = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/PurchasePromptLite").Enums.ProductKind

local getActionTelemetryFieldValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").getActionTelemetryFieldValue

local v5 = {
	[productKind.Gamepass] = storeEnums.ProductType.GamePasses,
	[productKind.DeveloperSubscription] = storeEnums.ProductType.Subscriptions,
	[productKind.Product] = storeEnums.ProductType.DeveloperProducts
}

return function(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "kind")
	local v6 = actionTelemetryFieldValue and v5[actionTelemetryFieldValue]

	if v6 == nil then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "edpLocationType")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "universeId")
	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p2, p3, "productId")

	edpStoreAnalyticsLogger.logEvent(
		storeEnums.ActionType.PurchaseAttemptClick,
		v6,
		actionTelemetryFieldValue2,
		tonumber(actionTelemetryFieldValue3),
		tonumber(actionTelemetryFieldValue4),
		(tostring(actionTelemetryFieldValue4))
	)
end
