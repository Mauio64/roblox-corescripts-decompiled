local Home = script:FindFirstAncestor("Home")

local HomeSortDetailConstants = require(Home.HomeSortDetailPage.HomeSortDetailConstants)

local function getHomeSortDetailPageKey(p: string?, p2: number?)
	local v = (p == nil or p == "") and "Unknown" or p

	if p2 == nil then
		return `{HomeSortDetailConstants.ConfigKeyPrefix}-{v}`
	end

	return `{HomeSortDetailConstants.ConfigKeyPrefix}-{v}-{p2}`
end

return getHomeSortDetailPageKey
