require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/AssetInfo")

local function sortCurrentlyWearingItems(data, data2): boolean
	local v5 = {
		isOffSale = data.isOffSale or false,
		price = data.price or data.lowestResalePrice or 0,
		favoriteCount = data.favoriteCount or 0
	}

	local v6 = {
		isOffSale = data2.isOffSale or false,
		price = data2.price or data2.lowestResalePrice or 0,
		favoriteCount = data2.favoriteCount or 0
	}

	if v5.isOffSale ~= v6.isOffSale then
		return not v5.isOffSale
	end

	if v5.price == v6.price then
		return (tonumber(data.id) or 0) < (tonumber(data2.id) or 0)
	end

	if v5.price == 0 then
		return false
	end

	if v6.price == 0 then
		return true
	end

	return v5.price > v6.price
end

return sortCurrentlyWearingItems
