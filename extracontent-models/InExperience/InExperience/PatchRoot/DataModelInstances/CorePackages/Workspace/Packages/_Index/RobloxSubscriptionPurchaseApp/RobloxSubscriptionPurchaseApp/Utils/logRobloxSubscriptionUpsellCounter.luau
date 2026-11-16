local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
require(RobloxSubscriptionPurchaseApp.types)
require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local FFlagEnablePlusReferralTelemetry = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnablePlusReferralTelemetry)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralEntrypointTelemetry = SharedFlags.FFlagEnablePlusReferralEntrypointTelemetry

function logRobloxSubscriptionUpsellCounter(p)
	local v = RobloxSubscriptionStore.get()
	local entryContext = v.getEntryContext()
	local errorReason = v.getErrorReason()
	local surface

	if entryContext then
		surface = entryContext.surfaceName
	else
		surface = SurfaceName.Unspecified
	end

	local v2

	if FFlagEnablePlusReferralTelemetry then
		v2 = v.getReferrerId()
	end

	if not (v2 and v2 > 0) then
		v2 = nil
	end

	local entrypoint

	if FFlagEnablePlusReferralEntrypointTelemetry and entryContext then
		entrypoint = entryContext.entrypoint
	end

	LoggingProtocol.default:logRobloxTelemetryCounter(p, 1, {
		surface = surface,
		errorReason = errorReason and tostring(errorReason) or nil,
		isReferral = v2 and "true" or nil,
		entrypoint = entrypoint
	})
end

return logRobloxSubscriptionUpsellCounter
