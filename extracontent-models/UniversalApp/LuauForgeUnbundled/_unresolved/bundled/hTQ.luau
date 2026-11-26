local module = require("@luauforge/bundled/hTR")

local module2 = require("@luauforge/bundled/hTT")

return function(options, p2)
	local v5 = options or {}

	return {
		SearchesInGames = module(v5.SearchesInGames, p2),
		SearchesInCatalog = module2(v5.SearchesInCatalog, p2)
	}
end
