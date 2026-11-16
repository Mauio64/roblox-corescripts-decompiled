local parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SearchTypes = RobloxAppEnums.SearchTypes

local function isSearchTypeInOmniSearch(p): boolean
	return p == SearchTypes.Games or p == SearchTypes.Players or p == SearchTypes.Auto or p == SearchTypes.TopResults
end

return isSearchTypeInOmniSearch
