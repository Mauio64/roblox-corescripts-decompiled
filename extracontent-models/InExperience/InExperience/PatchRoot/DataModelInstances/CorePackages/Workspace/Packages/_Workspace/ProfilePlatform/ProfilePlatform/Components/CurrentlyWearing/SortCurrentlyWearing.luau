local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.AssetInfo)

local function sortCurrentlyWearingItems(p1, p2) -- line: 5
	local t1 = {
		isOffSale = p1.isOffSale or false,
		price = p1.price or (p1.lowestResalePrice or 0),
		favoriteCount = p1.favoriteCount or 0
	}
	local t2 = {
		isOffSale = p2.isOffSale or false,
		price = p2.price or (p2.lowestResalePrice or 0),
		favoriteCount = p2.favoriteCount or 0
	}

	if t1.isOffSale ~= t2.isOffSale then
		return not t1.isOffSale
	end

	if t1.price ~= t2.price then
		if t1.price == 0 then
			return false
		end

		if t2.price == 0 then
			return true
		end

		return t1.price > t2.price
	end

	return (tonumber(p1.id) or 0) < (tonumber(p2.id) or 0)
end

return sortCurrentlyWearingItems
