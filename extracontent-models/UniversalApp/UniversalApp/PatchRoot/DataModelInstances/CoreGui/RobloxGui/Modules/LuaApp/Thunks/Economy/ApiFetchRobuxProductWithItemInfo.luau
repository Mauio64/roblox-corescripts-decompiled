local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local PostGetUpsellProduct = require(Modules.LuaApp.Http.Requests.PaymentsGatewayApi.PostGetUpsellProduct)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)

require(CorePackages.Workspace.Packages.Http)

local PaymentPlatformUtils = require(Modules.LuaApp.Thunks.Economy.Util.PaymentPlatformUtils)

require(Modules.LuaApp.Thunks.Economy.Types.EconomyTypes)

return function(p1, p2, p3, p4, p5, p6) -- line: 13
	-- upvalues: PaymentPlatformUtils (copy), getPaymentPlatform (copy), PostGetUpsellProduct (copy), Promise (copy)
	return function(_) -- line: 14
		-- upvalues: PaymentPlatformUtils (copy), getPaymentPlatform (copy), PostGetUpsellProduct (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), Promise (copy)
		local v14 = PaymentPlatformUtils.paymentPlatformToUpsellPlatform(getPaymentPlatform())

		return PostGetUpsellProduct(p1, v14, p2, p3, p4, p5, p6):andThen(function(p8) -- line: 25
			-- upvalues: Promise (copy)
			if p8 == nil or p8[1] == nil then
				return Promise.reject()
			end

			local v16 = p8[1]
			local t1 = {
				productId = v16.roblox_product_id,
				providerId = v16.provider_product_id,
				productName = v16.roblox_product_name,
				robuxAmount = v16.robux_amount,
				robuxAmountBeforeBonus = v16.robux_amount_before_bonus,
				price = v16.price
			}

			return Promise.resolve(t1)
		end)
	end
end
