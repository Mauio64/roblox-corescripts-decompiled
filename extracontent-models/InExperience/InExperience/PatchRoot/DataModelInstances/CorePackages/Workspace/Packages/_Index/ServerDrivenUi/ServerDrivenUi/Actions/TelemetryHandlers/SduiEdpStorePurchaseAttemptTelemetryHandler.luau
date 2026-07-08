local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local EdpStoreAnalytics = require(Parent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums
local ProductKind = require(Parent.PurchasePromptLite).Enums.ProductKind
local getActionTelemetryFieldValue = require(Parent.SduiCoreSystem).getActionTelemetryFieldValue
local t1 = {
	[ProductKind.Gamepass] = StoreEnums.ProductType.GamePasses,
	[ProductKind.DeveloperSubscription] = StoreEnums.ProductType.Subscriptions,
	[ProductKind.Product] = StoreEnums.ProductType.DeveloperProducts
}

return function(p1, p2, _) -- line: 25
	-- upvalues: getActionTelemetryFieldValue (copy), t1 (copy), EdpStoreAnalyticsLogger (copy), StoreEnums (copy)
	local v11 = getActionTelemetryFieldValue(p1, p2, "kind")
	local v12 = v11 and t1[v11]

	if v12 == nil then
		return
	end

	local v13 = getActionTelemetryFieldValue(p1, p2, "edpLocationType")
	local v14 = getActionTelemetryFieldValue(p1, p2, "universeId")
	local v15 = getActionTelemetryFieldValue(p1, p2, "productId")

	EdpStoreAnalyticsLogger.logEvent(StoreEnums.ActionType.PurchaseAttemptClick, v12, v13, tonumber(v14), tonumber(v15), (tostring(v15)))
end
