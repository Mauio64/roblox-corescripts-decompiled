local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local parent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local SurfaceContext = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceContext)
local SurfaceName = require(RobloxSubscriptionPurchaseApp.Enums.SurfaceName)
require(RobloxSubscriptionPurchaseApp.types)
require(script.Parent.CreatePaymentSessionTypes)
local HttpRequest = require(script.Parent.HttpRequest)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logRobloxSubscriptionUpsellTelemetryEvent = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellTelemetryEvent)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local FFlagSubscriptionUpsellCounterWithErrorReason = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSubscriptionUpsellCounterWithErrorReason)

local HttpService = game:GetService("HttpService")

local v = Url.APIS_URL .. "payments-gateway/v1/payment-sessions"

return function(p)
	local v2 = p or {
		context = SurfaceContext.Unspecified,
		surfaceName = SurfaceName.Unspecified,
		metadata = {}
	}

	local v3 = { entryPoint = v2.surfaceName }

	local universeId = v2.metadata.universeId

	if universeId ~= nil then
		v3.universeId = universeId
	end

	return HttpRequest.new():post(v, v3):andThen(function(p2)
		local paymentSession = p2.paymentSession
		local id = paymentSession and paymentSession.id
		return if type(id) == "string" then id else ""
	end):catch(function(p2)
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionCreatePaymentSessionFailedCounter)

		if FFlagSubscriptionUpsellCounterWithErrorReason then
			local robloxSubscriptionCreatePaymentSessionFailedEvent = RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionCreatePaymentSessionFailedEvent
			local errorReason

			if type(p2) == "table" then
				errorReason = HttpService:JSONEncode(p2)
			else
				errorReason = tostring(p2)
			end

			logRobloxSubscriptionUpsellTelemetryEvent(robloxSubscriptionCreatePaymentSessionFailedEvent, {
				errorReason = errorReason
			})
		end

		return Promise.resolve("")
	end)
end
