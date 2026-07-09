return {
	mock = function() -- line: 13
		return {
			resalePercentageFee = 30,
			minimumFee = 1,
			priceFloor = 0
		}
	end,
	fromGetCollectibleMarketplaceResaleParameters = function(p1, _: string?) -- line: 23
		return {
			resalePercentageFee = p1.resalePercentageFee,
			minimumFee = p1.minimumFee,
			priceFloor = p1.priceFloor
		}
	end
}
