return {
	fromProduct = function(data)
		return {
			["universeId"] = data.universeId,
			isForSale = data.isForSale,
			productId = data.productId,
			price = data.price,
			sellerId = data.sellerId
		}
	end
}
