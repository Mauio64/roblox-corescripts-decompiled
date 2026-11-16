local parent = script.Parent.Parent.Parent

local parent2 = parent.Parent
local Http = require(parent2.Http)
local Url = Http.Url
local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local logger = require(parent.Utility.logger)
local GetUpsellSuggestionsTypes = require(parent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)
local FStringIXPLayerMobileUpsell = require(parent.Flags.FStringIXPLayerMobileUpsell)

local FFlagEnableRobuxUpsellPlusButtonExperiment = require(parent.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment)

local url = Url.APIS_URL .. "payments-gateway/v1/products/get-upsell-suggestions"

local defineFastFlag = game:DefineFastFlag("EnableUpsellVirtualItemBadge", false)

return function(upsell_platform, user_robux_balance: number, attempt_robux_amount: number, max_packages: number, item_product_id: number?, item_name: string?, universe_id: number?, analytic_id: string?, flag: boolean?)
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

	local v = {
		upsell_platform = upsell_platform,
		user_robux_balance = user_robux_balance,
		attempt_robux_amount = attempt_robux_amount,
		max_packages = max_packages,
		virtual_item_badge_variant = badgingV2Variant
	}

	if FFlagEnableRobuxUpsellPlusButtonExperiment then
		v.is_eligible_for_experiment = flag == true
	end

	if item_product_id ~= nil then
		v.item_product_id = item_product_id
	end

	if item_name ~= nil then
		v.item_name = item_name
	end

	if universe_id ~= nil then
		v.universe_id = universe_id
	end

	if analytic_id ~= nil then
		v.analytic_id = analytic_id
	end

	logger.debug({ message = "Making GetUpsellSuggestions API Call", url = url, data = v })

	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(url, HttpService:JSONEncode(v))
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
	local v2 = {
		products = {},
		virtualItemBadgeType = jsonDecode.virtual_item_badge_type,
		experimentVariant = 0
	}
	local experimentVariant

	if FFlagEnableRobuxUpsellPlusButtonExperiment then
		experimentVariant = GetUpsellSuggestionsTypes.normalizeExperimentVariant(jsonDecode.experiment_variant)
	end

	v2.experimentVariant = experimentVariant

	for i, product in ipairs(jsonDecode.products) do
		v2.products[i] = {
			productId = product.roblox_product_id,
			providerId = product.provider_product_id,
			productName = product.roblox_product_name,
			robuxAmount = product.robux_amount,
			robuxAmountBeforeBonus = product.robux_amount_before_bonus,
			price = product.price,
			badgeType = product.badge_type
		}
	end

	return true, v2
end
