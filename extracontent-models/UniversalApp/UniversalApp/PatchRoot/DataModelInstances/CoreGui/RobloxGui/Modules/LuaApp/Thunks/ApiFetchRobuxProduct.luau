local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local PostGetUpsellProduct = require(Modules.LuaApp.Http.Requests.PaymentsGatewayApi.PostGetUpsellProduct)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)

require(CorePackages.Workspace.Packages.Http)

local function paymentPlatformToUpsellPlatform(p1) -- line: 11
	-- upvalues: PaymentPlatform (copy)
	if p1 == PaymentPlatform.Web then
		return "Web"
	end

	if p1 == PaymentPlatform.Apple then
		return "AppleAppStore"
	end

	if p1 == PaymentPlatform.Google then
		return "GooglePlayStore"
	end

	if p1 == PaymentPlatform.Amazon then
		return "AmazonStore"
	end

	if p1 == PaymentPlatform.UWP then
		return "WindowsStore"
	end

	if p1 == PaymentPlatform.Xbox then
		return "XboxStore"
	end

	if p1 == PaymentPlatform.Maquettes then
		return "MaquettesStore"
	end

	if p1 == PaymentPlatform.Palisades then
		return "PalisadesStore"
	end

	if p1 == PaymentPlatform.Microsoft then
		return "MicrosoftStore"
	end

	if p1 == PaymentPlatform.MilkyWay then
		return "MilkyWayStore"
	end

	return "None"
end

return function(p2, n1: number, n2: number) -- line: 45
	-- upvalues: paymentPlatformToUpsellPlatform (copy), getPaymentPlatform (copy), PostGetUpsellProduct (copy), Promise (copy)
	return function(_) -- line: 46
		-- upvalues: paymentPlatformToUpsellPlatform (copy), getPaymentPlatform (copy), PostGetUpsellProduct (copy), p2 (copy), n1 (copy), n2 (copy), Promise (copy)
		local v13 = paymentPlatformToUpsellPlatform(getPaymentPlatform())

		return PostGetUpsellProduct(p2, v13, n1, n2):andThen(function(p4) -- line: 48
			-- upvalues: Promise (copy)
			if p4 == nil or p4[1] == nil then
				return Promise.reject()
			end

			local v15 = p4[1]
			local t1 = {
				productId = v15.roblox_product_id,
				providerId = v15.provider_product_id,
				productName = v15.roblox_product_name,
				robuxAmount = v15.robux_amount,
				robuxAmountBeforeBonus = v15.robux_amount_before_bonus
			}

			return Promise.resolve(t1)
		end)
	end
end
