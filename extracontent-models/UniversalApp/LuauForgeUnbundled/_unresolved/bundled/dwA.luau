local module = require("@luauforge/bundled/dwz")
local module2 = require("@luauforge/bundled/dwB")

return function(options, p2)
	local v5 = options or {}

	return {
		SearchesInGamesStatus = module2(v5.SearchesInGamesStatus, p2),
		OmniRecommendationsMetadataRetrievalStatus = module(v5.OmniRecommendationsMetadataRetrievalStatus, p2)
	}
end
