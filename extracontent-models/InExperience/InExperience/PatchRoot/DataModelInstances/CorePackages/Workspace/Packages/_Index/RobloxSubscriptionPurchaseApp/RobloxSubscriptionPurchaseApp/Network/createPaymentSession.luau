local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(RobloxSubscriptionPurchaseAppParent.Promise)
local Url = require(RobloxSubscriptionPurchaseAppParent.Http).Url
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
local v13 = Url.APIS_URL .. "payments-gateway/v1/payment-sessions"

return function(p1) -- line: 25
	-- upvalues: SurfaceContext (copy), SurfaceName (copy), HttpRequest (copy), v13 (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), FFlagSubscriptionUpsellCounterWithErrorReason (copy), logRobloxSubscriptionUpsellTelemetryEvent (copy), HttpService (copy), Promise (copy)
	local v15 = p1 or {
		context = SurfaceContext.Unspecified,
		surfaceName = SurfaceName.Unspecified,
		metadata = {}
	}
	local t1 = {
		entryPoint = v15.surfaceName
	}
	local universeId = v15.metadata.universeId

	if universeId ~= nil then
		t1.universeId = universeId
	end

	return HttpRequest.new():post(v13, t1):andThen(function(p2) -- line: 44
		local paymentSession = p2.paymentSession
		local v20 = paymentSession and paymentSession.id

		if type(v20) == "string" then
			return v20
		end

		return ""
	end):catch(function(p3) -- line: 50
		-- upvalues: logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), FFlagSubscriptionUpsellCounterWithErrorReason (copy), logRobloxSubscriptionUpsellTelemetryEvent (copy), HttpService (copy), Promise (copy)
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionCreatePaymentSessionFailedCounter)

		if FFlagSubscriptionUpsellCounterWithErrorReason then
			logRobloxSubscriptionUpsellTelemetryEvent(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionCreatePaymentSessionFailedEvent, {
				errorReason = if type(p3) ~= "table" then tostring(p3) else HttpService:JSONEncode(p3)
			})
		end

		return Promise.resolve("")
	end)
end
