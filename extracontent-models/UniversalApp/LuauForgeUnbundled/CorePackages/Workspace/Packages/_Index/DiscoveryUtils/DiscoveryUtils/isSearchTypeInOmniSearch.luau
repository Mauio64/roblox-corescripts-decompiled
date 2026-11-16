local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/RobloxAppEnums").SearchTypes

local function isSearchTypeInOmniSearch(p2): boolean
	return p2 == searchTypes.Games
		or p2 == searchTypes.Players
		or p2 == searchTypes.Auto
		or p2 == searchTypes.TopResults
end

return isSearchTypeInOmniSearch
