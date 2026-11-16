local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local FFlagEnablePlusReferralTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnablePlusReferralTelemetry")

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry
local isRobloxSubscriptionProductFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isRobloxSubscriptionProductFreeTrial")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")

local function buildSubscriptionPurchaseFlowPayload(p2)
	local v5 = RobloxSubscriptionStore.get()
	local entryContext = v5.getEntryContext()
	local robloxSubscriptionProduct = v5.getRobloxSubscriptionProduct()
	local paymentSessionId = v5.getPaymentSessionId()
	local v6, v7

	if robloxSubscriptionProduct and robloxSubscriptionProduct.ProductKey then
		v6 = robloxSubscriptionProduct.ProductKey.Id or ""
		v7 = robloxSubscriptionProduct.ProductKey.Type or ""
	else
		v6 = ""
		v7 = ""
	end

	local localizedPriceDisplayString = robloxSubscriptionProduct
		and robloxSubscriptionProduct.LocalizedPriceDisplayString
		or ""

	local v8 = (entryContext.metadata or {}).universeId

	if v8 == nil then
		local gameId = game.GameId

		if gameId > 0 then
			v8 = gameId
		end
	end

	local surfaceName = entryContext.surfaceName
	local context = entryContext.context
	local clientSessionId = entryContext.clientSessionId
	local clientSessionIdType = if clientSessionId then clientSessionId.clientSessionIdType else nil
	local v9 = not clientSessionId and "" or clientSessionId.clientSessionId
	local subscriptionPurchaseFlowPayload = {
		event_name = p2,
		client_session_id_type = clientSessionIdType == nil and "" or clientSessionIdType,
		client_session_id = v9,
		purchase_flow_uuid = v9,
		product_id = v6,
		product_type = v7,
		surface_name = surfaceName == nil and "" or tostring(surfaceName),
		surface_context = context == nil and "" or tostring(context),
		trial_status = isRobloxSubscriptionProductFreeTrial(robloxSubscriptionProduct),
		display_price = localizedPriceDisplayString,
		ingest_timestamp_milliseconds = DateTime.now().UnixTimestampMillis
	}

	if paymentSessionId ~= "" then
		subscriptionPurchaseFlowPayload.payment_session_id = paymentSessionId
	end

	if v8 ~= nil then
		subscriptionPurchaseFlowPayload.universe_id = v8
	end

	if FFlagEnablePlusReferralTelemetry then
		local referrerId = v5.getReferrerId()

		if referrerId and referrerId > 0 then
			subscriptionPurchaseFlowPayload.referrer_id = tostring(referrerId)
		end
	end

	if fFlagEnablePlusReferralEntrypointTelemetry and entryContext.entrypoint then
		subscriptionPurchaseFlowPayload.entrypoint = entryContext.entrypoint
	end

	return subscriptionPurchaseFlowPayload
end

return buildSubscriptionPurchaseFlowPayload
