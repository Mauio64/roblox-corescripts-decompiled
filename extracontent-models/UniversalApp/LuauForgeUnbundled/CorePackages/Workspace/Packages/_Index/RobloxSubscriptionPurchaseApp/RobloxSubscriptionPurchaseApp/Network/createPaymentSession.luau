local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Http").Url

local SurfaceContext = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceContext")
local SurfaceName = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SurfaceName")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/CreatePaymentSessionTypes")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local logRobloxSubscriptionUpsellTelemetryEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellTelemetryEvent")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local FFlagSubscriptionUpsellCounterWithErrorReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagSubscriptionUpsellCounterWithErrorReason")

local HttpService = game:GetService("HttpService")

local v5 = url.APIS_URL .. "payments-gateway/v1/payment-sessions"

return function(p2)
	local v6 = p2 or {
		context = SurfaceContext.Unspecified,
		surfaceName = SurfaceName.Unspecified,
		metadata = {}
	}

	local v7 = { entryPoint = v6.surfaceName }

	local universeId = v6.metadata.universeId

	if universeId ~= nil then
		v7.universeId = universeId
	end

	return HttpRequest.new():post(v5, v7):andThen(function(p3)
		local paymentSession = p3.paymentSession
		local id = paymentSession and paymentSession.id

		if type(id) == "string" then
			return id
		end

		return ""
	end):catch(function(p3)
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionCreatePaymentSessionFailedCounter)

		if FFlagSubscriptionUpsellCounterWithErrorReason then
			local robloxSubscriptionCreatePaymentSessionFailedEvent = RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionCreatePaymentSessionFailedEvent
			local v10 = if type(p3) == "table" then HttpService:JSONEncode(p3) else tostring(p3)
			logRobloxSubscriptionUpsellTelemetryEvent(robloxSubscriptionCreatePaymentSessionFailedEvent, {
				errorReason = v10
			})
		end

		return Promise.resolve("")
	end)
end
