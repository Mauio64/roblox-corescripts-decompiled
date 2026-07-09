local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local SearchTypes = require(Parent.RobloxAppEnums).SearchTypes

local function isSearchTypeInOmniSearch(p1) -- line: 4
	-- upvalues: SearchTypes (copy)
	if p1 == SearchTypes.Games or (p1 == SearchTypes.Players or p1 == SearchTypes.Auto or p1 == SearchTypes.TopResults) then
		return true
	end

	return false
end

return isSearchTypeInOmniSearch
