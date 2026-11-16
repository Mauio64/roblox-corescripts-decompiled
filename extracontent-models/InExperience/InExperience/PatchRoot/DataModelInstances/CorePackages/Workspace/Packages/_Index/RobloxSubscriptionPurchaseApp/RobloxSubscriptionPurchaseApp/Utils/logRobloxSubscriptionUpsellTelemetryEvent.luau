local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
require(RobloxSubscriptionPurchaseApp.types)

function logRobloxSubscriptionUpsellTelemetryEvent(p, items)
	local entryContext = RobloxSubscriptionStore.get().getEntryContext()
	local surface

	if entryContext then
		surface = entryContext.surfaceName
	else
		surface = SurfaceName.Unspecified
	end

	local v = { surface = surface }

	if items then
		for k, item in items do
			v[k] = item
		end
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(p, {}, v)
end

return logRobloxSubscriptionUpsellTelemetryEvent
