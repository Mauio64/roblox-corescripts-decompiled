local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/LoggingProtocol")
local SurfaceName = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")

function LUAUFORGE_MODULE_GLOBALS_aOV_logRobloxSubscriptionUpsellTelemetryEvent(p2, items)
	local entryContext = RobloxSubscriptionStore.get().getEntryContext()

	local v6 = {
		surface = if entryContext then entryContext.surfaceName else SurfaceName.Unspecified
	}

	if items then
		for k, item in items do
			v6[k] = item
		end
	end

	LoggingProtocol.default:logRobloxTelemetryEvent(p2, {}, v6)
end

return LUAUFORGE_MODULE_GLOBALS_aOV_logRobloxSubscriptionUpsellTelemetryEvent
