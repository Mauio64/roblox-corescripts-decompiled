local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/LoggingProtocol")
local SurfaceName = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local FFlagEnablePlusReferralTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnablePlusReferralTelemetry")

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry

function LUAUFORGE_MODULE_GLOBALS_aQq_logRobloxSubscriptionUpsellCounter(p2)
	local v5 = RobloxSubscriptionStore.get()
	local entryContext = v5.getEntryContext()
	local errorReason = v5.getErrorReason()

	local v6 = if entryContext then entryContext.surfaceName else SurfaceName.Unspecified

	local v7 = if FFlagEnablePlusReferralTelemetry then v5.getReferrerId() else nil

	if not (v7 and v7 > 0) then
		v7 = nil
	end

	local v8 = if fFlagEnablePlusReferralEntrypointTelemetry and entryContext then entryContext.entrypoint else nil

	LoggingProtocol.default:logRobloxTelemetryCounter(p2, 1, {
		surface = v6,
		errorReason = errorReason and tostring(errorReason) or nil,
		isReferral = v7 and "true" or nil,
		entrypoint = v8
	})
end

return LUAUFORGE_MODULE_GLOBALS_aQq_logRobloxSubscriptionUpsellCounter
