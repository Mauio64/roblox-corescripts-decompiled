local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local Url = Http.Url

return {
	buildStatusesUrl = urlBuilder.new({
		base = Url.APIS_URL,
		path = "game-transactions/v1/receipts",
		query = "playerId={playerId}&placeId={placeId}&status=pending&locationType=ExperienceDetailPage"
	})
}
