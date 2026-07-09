return {
	mock = function() -- line: 11
		return {
			taxRate = 0.3,
			minimumFee = 1
		}
	end,
	fromGetResaleTaxRate = function(p1) -- line: 20
		return {
			taxRate = p1.taxRate,
			minimumFee = p1.minimumFee
		}
	end
}
