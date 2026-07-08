local function createInspectAndBuyKeyMapper(p1) -- line: 7
	return function(p2, ...) -- line: 9
		-- upvalues: p1 (copy)
		local v4 = "inspectAndBuy." .. p2 .. "." .. p1

		for i = 1, select("#", ...) do
			v4 ..= "." .. tostring(select(i, ...))
		end

		return v4
	end
end

return createInspectAndBuyKeyMapper
