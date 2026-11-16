local parent = script.Parent.Parent
local RobuxUpsell = {}

function RobuxUpsell.new(id: number, providerId: string, productName: string, robuxAmount: number, price: string?)
	return {
		id = id,
		providerId = providerId,
		productName = productName,
		robuxAmount = robuxAmount,
		price = price
	}
end

function RobuxUpsell.fromJson(data)
	return {
		id = data.roblox_product_id,
		providerId = data.provider_product_id,
		productName = data.roblox_product_name,
		robuxAmount = data.robux_amount,
		robuxAmountBeforeBonus = data.robux_amount_before_bonus,
		price = data.price
	}
end

return RobuxUpsell
