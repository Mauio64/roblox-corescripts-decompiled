local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local t = require(PurchasePromptParent.PurchasePromptDeps).t

require(PurchasePrompt.strict)

local v4 = t.interface({
	productId = t.number,
	mobileProductId = t.string,
	robuxAmount = t.number,
	isSubscriptionOnly = t.boolean,
	premiumFeatureTypeName = t.string,
	description = t.string,
	price = t.interface({
		amount = t.number,
		currency = t.interface({
			currencySymbol = t.string
		})
	})
})

return function(p1) -- line: 29
	-- upvalues: v4 (copy)
	local v6, _ = v4(p1)

	if not v6 then
		return nil
	end

	return {
		productId = p1.productId,
		mobileProductId = p1.mobileProductId,
		robuxAmount = p1.robuxAmount,
		isSubscriptionOnly = p1.isSubscriptionOnly,
		premiumFeatureTypeName = p1.premiumFeatureTypeName,
		description = p1.description,
		price = p1.price.amount,
		currencySymbol = p1.price.currency.currencySymbol
	}
end
