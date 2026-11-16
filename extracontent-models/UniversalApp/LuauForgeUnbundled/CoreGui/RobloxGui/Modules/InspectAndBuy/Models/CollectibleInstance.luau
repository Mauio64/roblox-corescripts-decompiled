return {
	fromGetCollectibleItemInstances = function(data)
		return {
			["collectibleInstanceId"] = data.collectibleInstanceId,
			collectibleItemId = data.collectibleItemId,
			collectibleProductId = data.collectibleProductId,
			serialNumber = data.serialNumber,
			isHeld = data.isHeld,
			saleState = data.saleState,
			price = data.price
		}
	end,
	fromGetCollectibleResellers = function(data, p2)
		return {
			["collectibleInstanceId"] = data.collectibleItemInstanceId,
			collectibleItemId = p2,
			collectibleProductId = data.collectibleProductId,
			serialNumber = data.serialNumber,
			price = data.price,
			seller = data.seller and {
				sellerId = data.seller.sellerId,
				sellerType = data.seller.sellerType,
				name = data.seller.name,
				hasVerifiedBadge = data.seller.hasVerifiedBadge
			} or nil
		}
	end
}
