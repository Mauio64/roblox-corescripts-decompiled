local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
require(ProfilePlatform.Common.AssetInfo)

local function sortCurrentlyWearingItems(data, data2): boolean
	local v = {
		isOffSale = data.isOffSale or false,
		price = data.price or data.lowestResalePrice or 0,
		favoriteCount = data.favoriteCount or 0
	}

	local v2 = {
		isOffSale = data2.isOffSale or false,
		price = data2.price or data2.lowestResalePrice or 0,
		favoriteCount = data2.favoriteCount or 0
	}

	if v.isOffSale ~= v2.isOffSale then
		return not v.isOffSale
	end

	if v.price == v2.price then
		return (tonumber(data.id) or 0) < (tonumber(data2.id) or 0)
	end

	return v.price ~= 0 and (v2.price == 0 or v.price > v2.price)
end

return sortCurrentlyWearingItems
