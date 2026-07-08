local _ = script.Parent.Parent

return {
	new = function(n1: number, s1: string, s2: string, n2: number, s3: string?) -- line: 23
		return {
			id = n1,
			providerId = s1,
			productName = s2,
			robuxAmount = n2,
			price = s3
		}
	end,
	fromJson = function(t1: {[any]: any}) -- line: 39
		return {
			id = t1.roblox_product_id,
			providerId = t1.provider_product_id,
			productName = t1.roblox_product_name,
			robuxAmount = t1.robux_amount,
			robuxAmountBeforeBonus = t1.robux_amount_before_bonus,
			price = t1.price
		}
	end
}
