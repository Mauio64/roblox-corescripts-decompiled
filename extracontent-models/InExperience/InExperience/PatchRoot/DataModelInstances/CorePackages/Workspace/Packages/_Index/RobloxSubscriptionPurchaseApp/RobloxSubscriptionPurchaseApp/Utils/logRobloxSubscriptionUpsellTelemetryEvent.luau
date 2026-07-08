local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local LoggingProtocol = require(RobloxSubscriptionPurchaseAppParent.LoggingProtocol)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

require(RobloxSubscriptionPurchaseApp.types)

function logRobloxSubscriptionUpsellTelemetryEvent(p1, t1: {[any]: any}?) -- line: 12
	-- upvalues: RobloxSubscriptionStore (copy), SurfaceName (copy), LoggingProtocol (copy)
	local v8 = RobloxSubscriptionStore.get().getEntryContext()
	local t2 = {
		surface = if not v8 then SurfaceName.Unspecified else v8.surfaceName
	}

	if t1 then
		for v10, v11 in t1 do
			t2[v10] = v11
		end
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(p1, {}, t2)
end

return logRobloxSubscriptionUpsellTelemetryEvent
