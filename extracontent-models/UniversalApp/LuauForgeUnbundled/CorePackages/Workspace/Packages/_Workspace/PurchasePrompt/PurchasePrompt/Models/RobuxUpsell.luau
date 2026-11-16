return {
	new = function(p2, p3, p4, p5, p6)
		return {
			id = p2,
			providerId = p3,
			productName = p4,
			robuxAmount = p5,
			price = p6
		}
	end,
	fromJson = function(data)
		return {
			id = data.roblox_product_id,
			providerId = data.provider_product_id,
			productName = data.roblox_product_name,
			robuxAmount = data.robux_amount,
			robuxAmountBeforeBonus = data.robux_amount_before_bonus,
			price = data.price
		}
	end
}
