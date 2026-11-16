local HomeSortDetailConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/HomeSortDetailConstants")

local function getHomeSortDetailPageKey(p2, p3)
	local v5 = (p2 == nil or p2 == "") and "Unknown" or p2

	if p3 == nil then
		return `{module.ConfigKeyPrefix}-{v5}`
	end

	return `{module.ConfigKeyPrefix}-{v5}-{p3}`
end

return getHomeSortDetailPageKey
