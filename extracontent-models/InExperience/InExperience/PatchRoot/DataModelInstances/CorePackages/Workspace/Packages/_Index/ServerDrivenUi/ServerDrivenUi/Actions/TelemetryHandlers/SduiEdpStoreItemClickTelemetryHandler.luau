local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local EdpStoreAnalytics = require(Parent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums
local getActionTelemetryFieldValue = require(Parent.SduiCoreSystem).getActionTelemetryFieldValue

local function SduiEdpStoreItemClickTelemetryHandler(p1, p2, _) -- line: 16
	-- upvalues: getActionTelemetryFieldValue (copy), EdpStoreAnalyticsLogger (copy), StoreEnums (copy)
	local v10 = getActionTelemetryFieldValue(p1, p2, "productType")

	if v10 == nil then
		return
	end

	local v11 = getActionTelemetryFieldValue(p1, p2, "edpLocationType")
	local v12 = getActionTelemetryFieldValue(p1, p2, "universeId")
	local v13 = getActionTelemetryFieldValue(p1, p2, "productId")

	EdpStoreAnalyticsLogger.logEvent(StoreEnums.ActionType.ItemClick, v10, v11, tonumber(v12), tonumber(v13), (tostring(v13)))
end

return SduiEdpStoreItemClickTelemetryHandler
