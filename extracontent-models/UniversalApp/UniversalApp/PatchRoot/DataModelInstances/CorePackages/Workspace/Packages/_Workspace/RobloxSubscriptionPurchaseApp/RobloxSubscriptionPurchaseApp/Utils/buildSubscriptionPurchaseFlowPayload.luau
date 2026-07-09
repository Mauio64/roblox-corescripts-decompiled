local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local isRobloxSubscriptionProductFreeTrial = require(RobloxSubscriptionPurchaseApp.Utils.isRobloxSubscriptionProductFreeTrial)

require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local function buildSubscriptionPurchaseFlowPayload(s1: string) -- line: 13
	-- upvalues: RobloxSubscriptionStore (copy), isRobloxSubscriptionProductFreeTrial (copy)
	local v6 = RobloxSubscriptionStore.get()
	local v7 = v6.getEntryContext()
	local v8 = v6.getRobloxSubscriptionProduct()
	local v9 = v6.getPaymentSessionId()
	local s2 = ""
	local s3 = ""

	if v8 and v8.ProductKey then
		s2 = v8.ProductKey.Id or ""
		s3 = v8.ProductKey.Type or ""
	end

	local s4 = ""

	if v8 then
		s4 = v8.LocalizedPriceDisplayString or ""
	end

	local universeId = (v7.metadata or {}).universeId

	if universeId == nil then
		local GameId = game.GameId

		if GameId > 0 then
			universeId = GameId
		end
	end

	local surfaceName = v7.surfaceName
	local context = v7.context
	local clientSessionId = v7.clientSessionId
	local v18 = if not clientSessionId then nil else clientSessionId.clientSessionIdType
	local v19 = not clientSessionId and "" or clientSessionId.clientSessionId
	local t1 = {
		event_name = s1,
		client_session_id_type = v18 == nil and "" or v18,
		client_session_id = v19,
		purchase_flow_uuid = v19,
		product_id = s2,
		product_type = s3,
		surface_name = surfaceName == nil and "" or tostring(surfaceName),
		surface_context = context == nil and "" or tostring(context),
		trial_status = isRobloxSubscriptionProductFreeTrial(v8),
		display_price = s4,
		ingest_timestamp_milliseconds = DateTime.now().UnixTimestampMillis
	}

	if v9 ~= "" then
		t1.payment_session_id = v9
	end

	if universeId ~= nil then
		t1.universe_id = universeId
	end

	return t1
end

return buildSubscriptionPurchaseFlowPayload
