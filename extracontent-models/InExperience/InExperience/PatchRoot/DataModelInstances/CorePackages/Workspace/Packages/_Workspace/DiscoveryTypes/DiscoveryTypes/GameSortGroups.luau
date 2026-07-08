local ParentParent = script.Parent.Parent
local FFlagSearchOmniAutocompletePage = require(ParentParent.SharedFlags).FFlagSearchOmniAutocompletePage

return {
	ChatGames = "ChatGames",
	Games = "Games",
	HomeGames = "HomeGames",
	GamesSeeAll = "GamesSeeAll",
	GamesList = "GamesList",
	UnifiedHomeSorts = "UnifiedHomeSorts",
	SearchLandingPage = if not FFlagSearchOmniAutocompletePage then nil else "SearchLandingPage"
}
