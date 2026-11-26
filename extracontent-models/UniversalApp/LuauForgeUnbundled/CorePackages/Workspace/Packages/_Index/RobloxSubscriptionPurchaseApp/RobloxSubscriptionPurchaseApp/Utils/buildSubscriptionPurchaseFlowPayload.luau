local HttpService = game:GetService("HttpService")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local FFlagEnablePlusReferralTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnablePlusReferralTelemetry")

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry
local isRobloxSubscriptionProductFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isRobloxSubscriptionProductFreeTrial")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local RobloxPlusSheetKind = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")
local fFlagPlusMembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagPlusMembershipConfigChangeCheck

local function buildSubscriptionPurchaseFlowPayload(p2)
	local v5 = RobloxSubscriptionStore.get()
	local entryContext = v5.getEntryContext()
	local robloxSubscriptionProduct = v5.getRobloxSubscriptionProduct()
	local paymentSessionId = v5.getPaymentSessionId()
	local v6 = if FFlagTTOnboardingSheet then v5.getPurchaseUIOptions() else nil
	local v7, v8

	if robloxSubscriptionProduct and robloxSubscriptionProduct.ProductKey then
		v7 = robloxSubscriptionProduct.ProductKey.Id or ""
		v8 = robloxSubscriptionProduct.ProductKey.Type or ""
	else
		v7 = ""
		v8 = ""
	end

	local localizedPriceDisplayString = robloxSubscriptionProduct
		and robloxSubscriptionProduct.LocalizedPriceDisplayString
		or ""

	local v9 = (entryContext.metadata or {}).universeId

	if v9 == nil then
		local gameId = game.GameId

		if gameId > 0 then
			v9 = gameId
		end
	end

	local surfaceName = entryContext.surfaceName
	local context = entryContext.context
	local clientSessionId = entryContext.clientSessionId
	local clientSessionIdType = if clientSessionId then clientSessionId.clientSessionIdType else nil
	local v10 = not clientSessionId and "" or clientSessionId.clientSessionId
	local subscriptionPurchaseFlowPayload = {
		event_name = p2,
		client_session_id_type = clientSessionIdType == nil and "" or clientSessionIdType,
		client_session_id = v10,
		purchase_flow_uuid = v10,
		product_id = v7,
		product_type = v8,
		surface_name = surfaceName == nil and "" or tostring(surfaceName),
		surface_context = context == nil and "" or tostring(context),
		trial_status = isRobloxSubscriptionProductFreeTrial(robloxSubscriptionProduct),
		display_price = localizedPriceDisplayString,
		ingest_timestamp_milliseconds = DateTime.now().UnixTimestampMillis
	}

	if paymentSessionId ~= "" then
		subscriptionPurchaseFlowPayload.payment_session_id = paymentSessionId
	end

	if v9 ~= nil then
		subscriptionPurchaseFlowPayload.universe_id = v9
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

	if FFlagTTOnboardingSheet and v6 and v6.sheetKind == RobloxPlusSheetKind.TT then
		subscriptionPurchaseFlowPayload.event_metadata = HttpService:JSONEncode({
			sheet_kind = v6.sheetKind
		})
	end

	if fFlagPlusMembershipConfigChangeCheck and v5.getPurchaseFlowOptions().includeUpgrades == true then
		local v11 = not subscriptionPurchaseFlowPayload.event_metadata and {}
			or HttpService:JSONDecode(subscriptionPurchaseFlowPayload.event_metadata)
		v11.include_upgrades = true
		subscriptionPurchaseFlowPayload.event_metadata = HttpService:JSONEncode(v11)
	end

	return subscriptionPurchaseFlowPayload
end

return buildSubscriptionPurchaseFlowPayload
