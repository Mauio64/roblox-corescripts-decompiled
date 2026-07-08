local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Url = require(ParentParentParent.Http).Url
local IXPServiceWrapper = require(ParentParentParent.IXPServiceWrapper).IXPServiceWrapper
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local logger = require(ParentParent.Utility.logger)

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

local FStringIXPLayerMobileUpsell = require(ParentParent.Flags.FStringIXPLayerMobileUpsell)
local v9 = Url.APIS_URL .. "payments-gateway/v1/products/get-upsell-suggestions"
local v10 = game:DefineFastFlag("EnableUpsellVirtualItemBadge", false)

return function(p1, n1: number, n2: number, n3: number, n4: number?, s1: string?, n5: number?, s2: string?) -- line: 21
	-- upvalues: v10 (copy), logger (copy), IXPServiceWrapper (copy), FStringIXPLayerMobileUpsell (copy), v9 (copy), HttpRbxApiService (copy), HttpService (copy)
	local badgingV2Variant = nil

	if v10 then
		logger.debug({
			message = "Virtual item flag is on"
		})

		local LayerData = IXPServiceWrapper:GetLayerData(FStringIXPLayerMobileUpsell)

		logger.debug({
			message = "Layer data",
			layerData = LayerData
		})

		if LayerData and LayerData.badgingV2Variant then
			badgingV2Variant = LayerData.badgingV2Variant
			IXPServiceWrapper:LogUserLayerExposure(FStringIXPLayerMobileUpsell)
		end
	end

	local t1 = {
		upsell_platform = p1,
		user_robux_balance = n1,
		attempt_robux_amount = n2,
		max_packages = n3,
		virtual_item_badge_variant = badgingV2Variant
	}

	if n4 ~= nil then
		t1.item_product_id = n4
	end

	if s1 ~= nil then
		t1.item_name = s1
	end

	if n5 ~= nil then
		t1.universe_id = n5
	end

	if s2 ~= nil then
		t1.analytic_id = s2
	end

	logger.debug({
		message = "Making GetUpsellSuggestions API Call",
		url = v9,
		data = t1
	})

	local ok, result = pcall(function() -- line: 76
		-- upvalues: HttpRbxApiService (copy), v9 (copy), HttpService (copy), t1 (copy)
		return HttpRbxApiService:PostAsyncFullUrl(v9, HttpService:JSONEncode(t1))
	end)

	logger.debug({
		message = "GetUpsellSuggestions API Response",
		response = result,
		success = ok
	})

	if not ok then
		return false, nil
	end

	local data = HttpService:JSONDecode(result)
	local t2 = {
		products = {},
		virtualItemBadgeType = data.virtual_item_badge_type
	}

	for i, v in ipairs(data.products) do
		t2.products[i] = {
			productId = v.roblox_product_id,
			providerId = v.provider_product_id,
			productName = v.roblox_product_name,
			robuxAmount = v.robux_amount,
			robuxAmountBeforeBonus = v.robux_amount_before_bonus,
			price = v.price,
			badgeType = v.badge_type
		}
	end

	return true, t2
end
