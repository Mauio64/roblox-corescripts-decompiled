return {
	mock = function()
		return { taxRate = 0.3, minimumFee = 1 }
	end,
	fromGetResaleTaxRate = function(p2)
		return { ["taxRate"] = p2.taxRate, minimumFee = p2.minimumFee }
	end
}
