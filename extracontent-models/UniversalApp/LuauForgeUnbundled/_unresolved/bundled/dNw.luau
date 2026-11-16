return {
	mock = function()
		return { resalePercentageFee = 30, minimumFee = 1, priceFloor = 0 }
	end,
	fromGetCollectibleMarketplaceResaleParameters = function(data, p2)
		return {
			["resalePercentageFee"] = data.resalePercentageFee,
			minimumFee = data.minimumFee,
			priceFloor = data.priceFloor
		}
	end
}
