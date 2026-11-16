local count = 0

return {
	mock = function(p2)
		local v6 = tostring(p2)

		if not v6 then
			count += 1
			v6 = tostring(count)
		end

		return { ["id"] = v6, assetType = "0", name = "" }
	end,
	fromAsset = function(data)
		return {
			["id"] = tostring(data.id),
			assetType = tostring(data.assetType),
			name = data.name,
			price = data.price,
			lowestResalePrice = data.lowestResalePrice,
			isOffSale = data.isOffSale,
			favoriteCount = data.favoriteCount
		}
	end
}
