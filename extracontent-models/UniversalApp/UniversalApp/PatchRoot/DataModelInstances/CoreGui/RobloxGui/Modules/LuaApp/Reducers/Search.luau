local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SearchesInGames = require(Modules.LuaApp.Reducers.SearchesInGames)
local SearchesInCatalog = require(Modules.AvatarExperience.Catalog.Reducers.SearchesInCatalog)

return function(p1, p2) -- line: 10
	-- upvalues: SearchesInGames (copy), SearchesInCatalog (copy)
	local v6 = p1 or {}

	return {
		SearchesInGames = SearchesInGames(v6.SearchesInGames, p2),
		SearchesInCatalog = SearchesInCatalog(v6.SearchesInCatalog, p2)
	}
end
