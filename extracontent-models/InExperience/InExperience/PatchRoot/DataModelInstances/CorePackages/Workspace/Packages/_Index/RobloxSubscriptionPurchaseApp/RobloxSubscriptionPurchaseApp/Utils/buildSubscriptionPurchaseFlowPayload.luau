local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local FFlagEnablePlusReferralTelemetry = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnablePlusReferralTelemetry)
local parent = RobloxSubscriptionPurchaseApp.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralEntrypointTelemetry = SharedFlags.FFlagEnablePlusReferralEntrypointTelemetry
local isRobloxSubscriptionProductFreeTrial = require(RobloxSubscriptionPurchaseApp.Utils.isRobloxSubscriptionProductFreeTrial)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local function buildSubscriptionPurchaseFlowPayload(event_name: string)
	local v = RobloxSubscriptionStore.get()
	local entryContext = v.getEntryContext()
	local robloxSubscriptionProduct = v.getRobloxSubscriptionProduct()
	local paymentSessionId = v.getPaymentSessionId()
	local product_id, product_type

	if robloxSubscriptionProduct and robloxSubscriptionProduct.ProductKey then
		product_id = robloxSubscriptionProduct.ProductKey.Id or ""
		product_type = robloxSubscriptionProduct.ProductKey.Type or ""
	else
		product_id = ""
		product_type = ""
	end

	local localizedPriceDisplayString = robloxSubscriptionProduct
		and robloxSubscriptionProduct.LocalizedPriceDisplayString
		or ""

	local universe_id = (entryContext.metadata or {}).universeId

	if universe_id == nil then
		local gameId = game.GameId

		if gameId > 0 then
			universe_id = gameId
		end
	end

	local surfaceName = entryContext.surfaceName
	local context = entryContext.context
	local clientSessionId = entryContext.clientSessionId
	local clientSessionIdType

	if clientSessionId then
		clientSessionIdType = clientSessionId.clientSessionIdType
	end

	local v2 = not clientSessionId and "" or clientSessionId.clientSessionId
	local subscriptionPurchaseFlowPayload = {
		event_name = event_name,
		client_session_id_type = clientSessionIdType == nil and "" or clientSessionIdType,
		client_session_id = v2,
		purchase_flow_uuid = v2,
		product_id = product_id,
		product_type = product_type,
		surface_name = surfaceName == nil and "" or tostring(surfaceName),
		surface_context = context == nil and "" or tostring(context),
		trial_status = isRobloxSubscriptionProductFreeTrial(robloxSubscriptionProduct),
		display_price = localizedPriceDisplayString,
		ingest_timestamp_milliseconds = DateTime.now().UnixTimestampMillis
	}

	if paymentSessionId ~= "" then
		subscriptionPurchaseFlowPayload.payment_session_id = paymentSessionId
	end

	if universe_id ~= nil then
		subscriptionPurchaseFlowPayload.universe_id = universe_id
	end

	if FFlagEnablePlusReferralTelemetry then
		local referrerId = v.getReferrerId()

		if referrerId and referrerId > 0 then
			subscriptionPurchaseFlowPayload.referrer_id = tostring(referrerId)
		end
	end

	if FFlagEnablePlusReferralEntrypointTelemetry and entryContext.entrypoint then
		subscriptionPurchaseFlowPayload.entrypoint = entryContext.entrypoint
	end

	return subscriptionPurchaseFlowPayload
end

return buildSubscriptionPurchaseFlowPayload
