local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = Http.Url

return {
	buildStatusesUrl = UrlBuilder.new({
		path = "developer-products/v1/game-transactions",
		query = "playerId={playerId}&placeId={placeId}&status=pending&locationType=ExperienceDetailPage",
		base = Url.APIS_URL
	})
}
