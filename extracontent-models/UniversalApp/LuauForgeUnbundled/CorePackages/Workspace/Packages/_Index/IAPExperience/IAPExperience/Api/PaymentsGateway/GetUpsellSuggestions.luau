local url = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Http").Url
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/IxpServiceWrapper").IXPServiceWrapper

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local GetUpsellSuggestionsTypes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")
local FStringIXPLayerMobileUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FStringIXPLayerMobileUpsell")

local FFlagEnableRobuxUpsellPlusButtonExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagEnableRobuxUpsellPlusButtonExperiment")

local v5 = url.APIS_URL .. "payments-gateway/v1/products/get-upsell-suggestions"

local defineFastFlag = game:DefineFastFlag("EnableUpsellVirtualItemBadge", false)

return function(p2, p3, p4, p5, item_product_id, item_name, universe_id, analytic_id, p6)
	local badgingV2Variant = nil

	if defineFastFlag then
		logger.debug({ message = "Virtual item flag is on" })

		local layerData = ixpServiceWrapper:GetLayerData(FStringIXPLayerMobileUpsell)
		logger.debug({ message = "Layer data", layerData = layerData })

		if layerData and layerData.badgingV2Variant then
			badgingV2Variant = layerData.badgingV2Variant
			ixpServiceWrapper:LogUserLayerExposure(FStringIXPLayerMobileUpsell)
		end
	end

	local v6 = {
		upsell_platform = p2,
		user_robux_balance = p3,
		attempt_robux_amount = p4,
		max_packages = p5,
		virtual_item_badge_variant = badgingV2Variant
	}

	if FFlagEnableRobuxUpsellPlusButtonExperiment then
		v6.is_eligible_for_experiment = p6 == true
	end

	if item_product_id ~= nil then
		v6.item_product_id = item_product_id
	end

	if item_name ~= nil then
		v6.item_name = item_name
	end

	if universe_id ~= nil then
		v6.universe_id = universe_id
	end

	if analytic_id ~= nil then
		v6.analytic_id = analytic_id
	end

	logger.debug({
		message = "Making GetUpsellSuggestions API Call",
		url = v5,
		data = v6
	})

	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(v5, HttpService:JSONEncode(v6))
	end)

	logger.debug({
		message = "GetUpsellSuggestions API Response",
		response = result,
		success = success
	})

	if not success then
		return false, nil
	end

	local jsonDecode = HttpService:JSONDecode(result)
	local v7 = {
		products = {},
		virtualItemBadgeType = jsonDecode.virtual_item_badge_type,
		experimentVariant = 0
	}

	local v8 = if FFlagEnableRobuxUpsellPlusButtonExperiment then GetUpsellSuggestionsTypes.normalizeExperimentVariant(jsonDecode.experiment_variant) else nil
	v7.experimentVariant = v8

	for i, product in ipairs(jsonDecode.products) do
		v7.products[i] = {
			productId = product.roblox_product_id,
			providerId = product.provider_product_id,
			productName = product.roblox_product_name,
			robuxAmount = product.robux_amount,
			robuxAmountBeforeBonus = product.robux_amount_before_bonus,
			price = product.price,
			badgeType = product.badge_type
		}
	end

	return true, v7
end
