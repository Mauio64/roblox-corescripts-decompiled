local n1 = 0

return {
	mock = function(p1) -- line: 29
		-- upvalues: n1 (ref)
		local t1 = {}
		local str = tostring(p1)

		if not str then
			n1 += 1
			str = tostring(n1)
		end

		t1.id = str
		t1.assetType = "0"
		t1.name = ""

		return t1
	end,
	fromAsset = function(p2) -- line: 43
		return {
			id = tostring(p2.id),
			assetType = tostring(p2.assetType),
			name = p2.name,
			price = p2.price,
			lowestResalePrice = p2.lowestResalePrice,
			isOffSale = p2.isOffSale,
			favoriteCount = p2.favoriteCount
		}
	end
}
