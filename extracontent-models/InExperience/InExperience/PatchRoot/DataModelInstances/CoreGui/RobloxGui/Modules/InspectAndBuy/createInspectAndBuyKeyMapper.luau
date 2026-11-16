local function createInspectAndBuyKeyMapper(p)
	return function(p2, ...)
		local v = "inspectAndBuy." .. p2 .. "." .. p

		for i = 1, select("#", ...) do
			v ..= "." .. tostring((select)(i, ...))
		end

		return v
	end
end

return createInspectAndBuyKeyMapper
