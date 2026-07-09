local Modules = script:FindFirstAncestor("DiscoveryMonolith").Modules
local OmniRecommendationsMetadataRetrievalStatus = require(Modules.LuaApp.Reducers.OmniRecommendationsMetadataRetrievalStatus)
local SearchesInGamesStatus = require(Modules.LuaApp.Reducers.SearchesInGamesStatus)

return function(p1, p2) -- line: 9
	-- upvalues: SearchesInGamesStatus (copy), OmniRecommendationsMetadataRetrievalStatus (copy)
	local v6 = p1 or {}

	return {
		SearchesInGamesStatus = SearchesInGamesStatus(v6.SearchesInGamesStatus, p2),
		OmniRecommendationsMetadataRetrievalStatus = OmniRecommendationsMetadataRetrievalStatus(v6.OmniRecommendationsMetadataRetrievalStatus, p2)
	}
end
