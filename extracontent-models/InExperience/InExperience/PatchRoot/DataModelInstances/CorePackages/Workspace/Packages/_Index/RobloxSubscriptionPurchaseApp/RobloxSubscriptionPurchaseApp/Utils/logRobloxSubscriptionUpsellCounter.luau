local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local LoggingProtocol = require(RobloxSubscriptionPurchaseAppParent.LoggingProtocol)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

require(RobloxSubscriptionPurchaseApp.types)
require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)

function logRobloxSubscriptionUpsellCounter(p1) -- line: 14
	-- upvalues: RobloxSubscriptionStore (copy), SurfaceName (copy), LoggingProtocol (copy)
	local v7 = RobloxSubscriptionStore.get()
	local v8 = v7.getEntryContext()
	local v9 = v7.getErrorReason()
	local v10 = if not v8 then SurfaceName.Unspecified else v8.surfaceName

	LoggingProtocol.default:logRobloxTelemetryCounter(p1, 1, {
		surface = v10,
		errorReason = v9 and tostring(v9) or nil
	})
end

return logRobloxSubscriptionUpsellCounter
