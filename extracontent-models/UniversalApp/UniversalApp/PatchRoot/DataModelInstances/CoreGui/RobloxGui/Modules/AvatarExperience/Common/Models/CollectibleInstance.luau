return {
	fromGetCollectibleItemInstances = function(p1) -- line: 24
		return {
			collectibleInstanceId = p1.collectibleInstanceId,
			collectibleItemId = p1.collectibleItemId,
			collectibleProductId = p1.collectibleProductId,
			serialNumber = p1.serialNumber,
			isHeld = p1.isHeld,
			saleState = p1.saleState,
			price = p1.price
		}
	end,
	fromGetCollectibleResellers = function(p2, p3) -- line: 38
		return {
			collectibleInstanceId = p2.collectibleItemInstanceId,
			collectibleItemId = p3,
			collectibleProductId = p2.collectibleProductId,
			serialNumber = p2.serialNumber,
			price = p2.price,
			seller = if not p2.seller then nil else {
				sellerId = p2.seller.sellerId,
				sellerType = p2.seller.sellerType,
				name = p2.seller.name,
				hasVerifiedBadge = p2.seller.hasVerifiedBadge
			}
		}
	end
}
