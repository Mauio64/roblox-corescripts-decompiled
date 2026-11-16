local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local EdpStoreAnalytics = require(parent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums

local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductKind = PurchasePromptLite.Enums.ProductKind

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local v = {
	[ProductKind.Gamepass] = StoreEnums.ProductType.GamePasses,
	[ProductKind.DeveloperSubscription] = StoreEnums.ProductType.Subscriptions,
	[ProductKind.Product] = StoreEnums.ProductType.DeveloperProducts
}

return function(p, p2, _)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "kind")
	local v2 = actionTelemetryFieldValue and v[actionTelemetryFieldValue]

	if v2 == nil then
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "edpLocationType")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "universeId")
	local actionTelemetryFieldValue4 = getActionTelemetryFieldValue(p, p2, "productId")

	EdpStoreAnalyticsLogger.logEvent(
		StoreEnums.ActionType.PurchaseAttemptClick,
		v2,
		actionTelemetryFieldValue2,
		tonumber(actionTelemetryFieldValue3),
		tonumber(actionTelemetryFieldValue4),
		(tostring(actionTelemetryFieldValue4))
	)
end
